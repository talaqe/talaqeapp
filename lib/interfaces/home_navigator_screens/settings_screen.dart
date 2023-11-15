
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/main.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_components.dart';
import 'package:talaqe/utils/constants/app_gaps.dart';
import 'package:talaqe/utils/constants/app_images.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:talaqe/widgets/settings_screen_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /// Notification toggle value
  bool _notificationToggle = false;
  List<dynamic> data=[];
  int accountid=0;
  bool haveimage=false;
  Dentist dentist=Dentist(0, "", "", "", "", "", "", "", "", "","","");

  String imagepath="";
  @override
  void initState() {
    // TODO: implement initState

    getData();
    super.initState();
  }

  Future<void> getData() async {

    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";

    int Citees = prefsssss.getInt('citiesss') ?? 0;
    print('datastring$datastring');

    if (datastring != "") {

      setState(() {
        data = json.decode(datastring);
        accountid = prefsssss.getInt('accountid') ?? 0;

      });
      Map datatype = data[0];

      var response=await CallApi().getallData("getdata/dentist/$accountid");
      var body = json.decode(utf8.decode(response.bodyBytes));
      print('respone fetchPagewithtrat  $body');
      var dentists=body[0];
      int cityid=0;
      setState(() {

        dentist.id=accountid;
        dentist.name=dentists['name']??"";
        dentist.phone=dentists['phone']??"";
        dentist.university=dentists['university']??"";
        dentist.active=dentists['active']??"";
        dentist.type=dentists['type']??"";
        dentist.identifynumber=dentists['identifynumber']??"";
        dentist.years=dentists['years']??"";
        dentist.city=dentists['city']??"";
        dentist.statusreserv=dentists['statusreserv'].toString()??"";
        dentist.avatar=dentists['avatar']??"";
        dentist.gallorywork=dentists['gallorywork']??"";

        // print('avatareeee'+element['avatar']);

        if(dentists['avatar']!=null){
          haveimage=true;
          imagepath=dentist.avatar;
          int  startIndex = dentist.avatar.indexOf(".");
          String firstpart=dentist.avatar.substring(0, startIndex);
          String lastpart=dentist.avatar.substring(1+startIndex,dentist.avatar.length );
          imagepath="$firstpart-small.$lastpart";
          print("imagepath$imagepath");
        }

      });





    }
    if(imagepath!=""){
      imagepath="https://talaqe.org/storage/app/public/$imagepath";
    }
    print("https://talaqe.org/storage/app/public/$imagepath");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* <-------- Appbar --------> */
      appBar: CoreWidgets.appBarWidget(
          screenContext: context, titleWidget: const Text('الاعدادات')),
      /* <-------- Content --------> */
      body: CustomScaffoldBodyWidget(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top extra spaces
            AppGaps.hGap15,
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius:
                      BorderRadius.all(AppComponents.defaultBorderRadius)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            AppComponents.defaultBorderRadius),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.network(imagepath,
                                    cacheHeight: 120,
                                    cacheWidth: 120)
                                .image)),
                  ),
                  AppGaps.wGap16,
                  Expanded(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحبا',
                        style: TextStyle(
                            fontSize: 16, color: Colors.white.withOpacity(0.7)),
                      ),
                      AppGaps.hGap10,
                      Text(
                        dentist.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    ],
                  )),
                  SizedBox(
                    height: 28,
                    width: 24,
                    child: PopupMenuButton<int>(
                      padding: EdgeInsets.zero,
                      position: PopupMenuPosition.over,
                      offset: const Offset(-25, 5),
                      onSelected: (value) {
                        switch (value) {
                          case 0:
                            Navigator.pushNamed(
                                context, AppPageNames.editProfileScreen);
                            break;
                          default:
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem<int>(
                              value: 0,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text('تعديل الملف الشخصي')),
                        ];
                      },
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),

                  )
                ],
              ),
            ),
            AppGaps.hGap30,
            /* <---- 'Become a pro member' menu ----> */
            SettingsListTileWidget(
              onTap: () {
                Navigator.pushNamed(context, AppPageNames.faqsScreen);

              },
              prefixSVGIconLocalAssetFileName: AppAssetImages.crownSolidIconSVG,
              prefixIconColor: AppColors.color4,
              text: 'شروط الإستخدام',
                suffixWidget: const Center()
            ),

            AppGaps.hGap20,
            SettingsListTileWidget(
              onTap: () =>
                  setState(() => _notificationToggle = !_notificationToggle),
              prefixSVGIconLocalAssetFileName:
              AppAssetImages.notificationDuoColorsIconSVG,
              prefixIconColor: AppColors.color5,
              text: '  مشاركة التطبيق',
              suffixWidget: const Center()
            ),
            AppGaps.hGap20,
            /* <---- 'Language' menu ----> */
            SettingsListTileWidget(
              onTap: () {

                  Navigator.pushNamed(context, AppPageNames.contactScreen);

              },
              prefixSVGIconLocalAssetFileName:
                  AppAssetImages.emailIconSVG
                ,
              prefixIconColor: AppColors.color4,
              text:'تواصل معنا',
                suffixWidget: const Center()
            ),
            AppGaps.hGap20,

            /* <---- 'Help' menu ----> */
            SettingsListTileWidget(
              onTap: () {
                logout();
              },
              prefixSVGIconLocalAssetFileName:
                  AppAssetImages.questionSolidIconSVG,
              prefixIconColor: AppColors.color5,
              text: 'تسجيل الخروج',
                suffixWidget: const Center()
            ),
            // Bottom extra spaces
            AppGaps.hGap120,
          ],
        ),
      )),
    );
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Route route = MaterialPageRoute(builder: (context) => const MyApp());
    Navigator.pushReplacement(context, route);
  }
}

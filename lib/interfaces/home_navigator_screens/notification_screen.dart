
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/data/notification.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/home_navigator_screens/my_home_doctors_screen.dart';
import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/widgets/notifications_screen_widgets.dart';

class NotificationScreen  extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final int _selectedCategoryIndex = 0;
  final List<Typetreatment> _Typetreatments =[];
  List<dynamic> data=[];
  int accountid=0;
  int my=0;
  double height=0;
  ScrollController scrollController = ScrollController();
  List<Notifications> _Notificationlist =[];
 bool login=false;
  List<City> _cities=[] ;
  TextEditingController searchcontroller = TextEditingController();
  Dentist dentist=Dentist(0, "", "", "", "", "", "", "", "", "","","");
  final Typetreatment _selecttype=Typetreatment(0, "", "");
  final City _selectedcities=City(0, "المدينة");
  int offset = 0;
  bool statusload=true;
  List<Widget> widgetlist =[];
  bool haveimage=false;
  String imagepath="";

  Future<void> getData() async {
    setState(() {
      _Notificationlist.clear();
    });
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";

    int Citees = prefsssss.getInt('citiesss') ?? 0;
    print('datastring$datastring');

    if (datastring != "") {

      setState(() {
        data = json.decode(datastring);
        accountid = prefsssss.getInt('accountid') ?? 0;
        searchcontroller.text="";
        if(accountid!=0){
          login=true;

        }
      });
      Map datatype = data[0];
      if(login) {
        var response = await CallApi().getallData(
            "getdata/dentist/$accountid");
        var body = json.decode(utf8.decode(response.bodyBytes));
        print('respone fetchPagewithtrat  $body');
        var dentists = body[0];
        int cityid = 0;
        setState(() {
          dentist.id = accountid;
          dentist.name = dentists['name'] ?? "";
          dentist.phone = dentists['phone'] ?? "";
          dentist.university = dentists['university'] ?? "";
          dentist.active = dentists['active'] ?? "";
          dentist.type = dentists['type'] ?? "";
          dentist.identifynumber = dentists['identifynumber'] ?? "";
          dentist.years = dentists['years'] ?? "";
          dentist.city = dentists['city'] ?? "";
          dentist.statusreserv = dentists['statusreserv'].toString() ?? "";
          dentist.avatar = dentists['avatar'] ?? "";
          dentist.gallorywork = dentists['gallorywork'] ?? "";

          // print('avatareeee'+element['avatar']);

          if (dentists['avatar'] != null) {
            haveimage = true;
            imagepath = dentist.avatar;
            int startIndex = dentist.avatar.indexOf(".");
            String firstpart = dentist.avatar.substring(0, startIndex);
            String lastpart = dentist.avatar.substring(
                1 + startIndex, dentist.avatar.length);
            imagepath = "$firstpart-small.$lastpart";
            print("imagepath$imagepath");
          }
        });
      }
      List<dynamic> typetreatments = datatype['Typetreatment'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in typetreatments) {
          print("add to areas $element");

          _Typetreatments.add(
              Typetreatment(element['id'], element['name'] ?? "",
                  element['image'] ?? ""));
        }
      });

      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());
      int? idselectedcities =prefsssss.getInt("_selectedcities");
      setState(() {
        _cities=[];
        for (var element in cities) {
          if(Citees==element['id']){
            _selectedcities.id=element['id'];
            _selectedcities.name=element['name'];
          }
          print("add to areas $element");

          _cities.add(
              City(element['id'], element['name'] ?? ""));
          if(element['id']==idselectedcities){
            _selectedcities.id=element['id'];
            _selectedcities.name=element['name'] ;
          }
        }
      });
      //_statuseslist





    }

    if(imagepath!=""){
      imagepath="https://talaqe.org/storage/app/public/$imagepath";
    }
    print("https://talaqe.org/storage/app/public/$imagepath");
    if(login) {
      _fetchPage(0);
    }
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }



  @override
  void initState() {
    // TODO: implement initState
    _Notificationlist=[];
    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent==scrollController.offset){
        _fetchPage(offset);
      }
    });
    getData();
    super.initState();
  }


  Future<void> _fetchPage(int pageKey) async {
    setState(() {
      offset=offset+10;
    });
    print('respone getnotificationss  $pageKey');
    var response;

    response = await CallApi().getallData("getnotificationss/${dentist.city}/${dentist.university}/${dentist.id}/$pageKey");

    var body = json.decode(utf8.decode(response.bodyBytes));
    print('myyyyyyyyy$body');
    if(body.toString()!="") {
      List<dynamic> statuslist = body;
      setState(() {
        for (var element in statuslist) {
          print("iddddddddsssdddddddddddd${element['id']}");
          _Notificationlist.add(


              Notifications(
                  element['id'],
                  element['title'] ?? "",
                  element['text'] ?? "",
                  element['link'] ?? "",
                  element['type'] ?? "",
                  element['account_id'].toString() ?? "",
                  element['cityid'].toString() ?? "",
                  element['universityid'].toString() ?? "",
                  element['read_at'] ?? "",
                  element['created_at'] ?? ""));
        }
        print('respone _Notificationlist  ${_Notificationlist.length}');
      });
      SharedPreferences prefsssss = await SharedPreferences.getInstance();
      prefsssss.setInt("countnotification",_Notificationlist.length);
    }
    print('respone offset  $offset');
    setState(() {
      statusload=false;
    });

  }
      @override
  Widget build(BuildContext context) {

        var screenWidth = MediaQuery
            .of(context)
            .size
            .width;
        double screenHeight = MediaQuery
            .of(context)
            .size
            .height;
    return Scaffold(
      /* <-------- Appbar --------> */
      appBar: AppBar(
        leadingWidth: 0,
        centerTitle: false,
        /* <---- Left side widget of appbar ----> */
        title: Container(
          padding: const EdgeInsets.only(top: 10),
          child: login?Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppGaps.wGap10,
              (imagepath!="")?  Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.all(AppComponents.defaultBorderRadius),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(imagepath),
                    )
                )
              ):
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.all(AppComponents.defaultBorderRadius),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset('asset/icons/avatar.png',
                            cacheHeight: 120, cacheWidth: 120)
                            .image)),
              ),
              AppGaps.wGap16,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(dentist.name??"",
                      style: const TextStyle(fontSize: 18),
                    ),
                    AppGaps.hGap4,
                    const Text('عرض حالاتي',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.secondaryFontColor,
                            fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ],
          ):const Center(),
        ),
        /* <---- Right side widgets of appbar ----> */
        actions: [
          Center(
            child: CustomIconButtonWidget(
                onTap: () {
    if(login) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MYHomeDoctorsScreen(),
          ));
    }
                },
                borderRadiusRadiusValue: AppComponents.defaultBorderRadius,
                backgroundColor: AppColors.secondaryFontColor.withOpacity(0.2),
                child: SvgPicture.asset(
                  AppAssetImages.personIconSVG,
                  height: 26,
                  width: 24,

                  color: AppColors.primaryColor,
                )),
          ),
          // Extra right spaces
          AppGaps.wGap24,
        ],
      ),
      /* <-------- Content --------> */
      body: CustomScaffoldBodyWidget(
          child: SingleChildScrollView(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top extra spaces
          AppGaps.hGap15,


          /* <----- 'Top doctors' text and 'View all' text button row -----> */
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(' الإشعارات ', style: AppComponents.headerTextStyle),

            ],
          ),
          AppGaps.wGap30,
          /* <----- Top doctors horizontal list -----> */
      login?     SizedBox(
            height:screenHeight-400,
            child: _Notificationlist.isEmpty? const Center(
              child: Text('لا تتوفر اشعارات جديدة')
            ):
            RefreshIndicator(
              displacement: 2,
              onRefresh:  getData,
              child: ListView.separated(
                  controller: scrollController,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => AppGaps.hGap16,
                  itemCount:_Notificationlist.length+1,
                  padding: const EdgeInsets.only(
                    top: 15,
                    // Bottom extra spaces
                    bottom: 30,
                  ),
                  itemBuilder:getstatuslist

                /// Single doctor data



              ),
            ),
          ):Container(
        child: Column(
          children: <Widget>[
            Image.asset('asset/logo.png',height: 150,),

            const Text("قم بانشاء حساب لتتمكن من الاستفادة من باقي خدماتنا"),
            CustomStretchedTextButtonWidget(
                buttonText: 'انشاء حساب',
                onTap: () {
                  Navigator.pushNamed(
                      context, AppPageNames.signInOrSignUpScreen);
                }),
          ],
        ),
      ),
          // Bottom extra spaces

          // Bottom spaces
          AppGaps.hGap100,
        ],
      ))),
    );
  }



  Widget getstatuslist(BuildContext context,int index) {



    if(index<_Notificationlist.length) {
      final notification=_Notificationlist[index];
      String result="";
      String type="";


      // final args = ModalRoute.of(context)!.settings.arguments as allStatus;
      return SingleNotificationWidget(notification: notification,
       );
    }else{
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
         
        ),
      );
    }



  }


}

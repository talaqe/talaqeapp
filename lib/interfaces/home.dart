
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/interfaces/home_navigator_screens/home_screen.dart';
import 'package:talaqe/interfaces/home_navigator_screens/my_product_screen.dart';
import 'package:talaqe/interfaces/home_navigator_screens/mystatus_doctors_screen.dart';
import 'package:talaqe/interfaces/home_navigator_screens/notification_screen.dart';
import 'package:talaqe/interfaces/home_navigator_screens/product_screen.dart';
import 'package:talaqe/utils/constants/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/widgets/home_navigator_screen_widgets.dart';


class HomeNavigatorScreen extends StatefulWidget {
  /// The parameter variable argument holds screen index number to show that tab
  /// screen initially.
  final Object? screenTabIndex;
  const HomeNavigatorScreen({Key? key, this.screenTabIndex}) : super(key: key);

  @override
  State<HomeNavigatorScreen> createState() => _HomeNavigatorScreenState();
}

class _HomeNavigatorScreenState extends State<HomeNavigatorScreen> {
  /// Current page index
  int _currentPageIndex = 0;
  int newnotification=0;
int accountid=0;
  bool login=false;
  /// Tabbed screen widget of selected tab
  Widget _nestedScreenWidget = const Scaffold();
  List<dynamic> data=[];
  Dentist dentist=Dentist(0, "", "", "", "", "", "", "", "", "","","");

  /* <-------- Select current page index initially --------> */
  void _setCurrentPageIndex(Object? argument) {
    if (argument != null) {
      if (argument is int) {
        _currentPageIndex = argument;
      }
    }
  }

  /* <-------- Select current tab screen --------> */
  void _setCurrentTab() {
    const int homeScreenIndex = 0;
    const int notificationsScreenIndex = 1;
    const int searchScreenIndex = 2;
    const int appointmentsScreenIndex = 3;
    const int settingsScreenIndex = 4;
    switch (_currentPageIndex) {
      case homeScreenIndex:
        _nestedScreenWidget = const HomeScreen();
        break;
      case notificationsScreenIndex:
        _nestedScreenWidget = const NotificationScreen();
        break;
      case searchScreenIndex:
        _nestedScreenWidget =  const ProductScreen();
        break;
      case appointmentsScreenIndex:
        _nestedScreenWidget = const MyProductScreen();
        break;
      case settingsScreenIndex:
        _nestedScreenWidget = const MyStatusDoctorsScreen();

        break;
      default:
      // Invalid page index set tab to dashboard screen
        _nestedScreenWidget = const HomeScreen();
    }
  }

  /* <-------- Initial state --------> */
  @override
  void initState() {
    _setCurrentPageIndex(widget.screenTabIndex);
    _setCurrentTab();
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        /* <-------- Content --------> */
        body: _nestedScreenWidget,
        /* <-------- Bottom navigator bar --------> */
        bottomNavigationBar: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            /* <----- Bottom linear shadow -----> */
            Container(
              // height: screenSize.height / 3.982,
              height: 110,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.backgroundColor.withOpacity(0),
                        AppColors.backgroundColor,
                      ])),
            ),
            /* <----- Bottom navigation bar widget -----> */
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /* <----- Home tab button -----> */
                  CustomBottomNavbarItemWidget(
                    toolTipMessage: 'الرئيسية',
                    icon:
                    Image.asset(AppAssetImages.logo, height: 30, width: 30),
                    onTap: () {
                      const currentPageIndex = 0;
                      if (currentPageIndex == _currentPageIndex) {
                        return;
                      }
                      // Set current index and tab screen
                      _currentPageIndex = currentPageIndex;
                      _setCurrentTab();
                      setState(() {});
                    },
                    isSelected: _currentPageIndex == 0,
                  ),
                  /* <----- Notification tab button -----> */
                  (newnotification==0)?   CustomBottomNavbarItemWidget(
                    toolTipMessage: 'الاشعارات',
                    icon: SvgPicture.asset(
                      AppAssetImages.notificationDuoColorsIconSVG,
                      height: 25.5,
                      width: 30,
                      color: _currentPageIndex == 1
                          ? AppColors.primaryColor
                          : null,
                    ),
                    onTap: () {
                      const currentPageIndex = 1;
                      if (currentPageIndex == _currentPageIndex) {
                        return;
                      }
                      // Set current index and tab screen
                      _currentPageIndex = currentPageIndex;
                      _setCurrentTab();
                      setState(() {});
                    },
                    isSelected: _currentPageIndex == 1,
                  ):
                  CustomBottomNavbarItemWidget(
                    notification:newnotification ,
                    toolTipMessage: 'الاشعارات',
                    icon: SvgPicture.asset(
                      AppAssetImages.notificationDuoColorsIconSVG,
                      height: 25.5,
                      width: 30,
                      color:AppColors.alertColor
                    ),
                    onTap: () {
                      setState(() {
                        newnotification=0;
                      });
                      const currentPageIndex = 1;
                      if (currentPageIndex == _currentPageIndex) {
                        return;
                      }
                      // Set current index and tab screen
                      _currentPageIndex = currentPageIndex;
                      _setCurrentTab();
                      setState(() {});
                    },
                    isSelected: _currentPageIndex == 1,
                  ),
                  /* <----- Search tab button -----> */
                  CustomBottomNavbarItemWidget(
                    toolTipMessage: 'المتجر',
                    icon: Icon( Icons.store,
                        size: 30,
                          color: _currentPageIndex == 2
                            ? AppColors.primaryColor
                            : AppColors.primaryFontColor),
                    onTap: () {
                      const currentPageIndex = 2;
                      if (currentPageIndex == _currentPageIndex) {
                        return;
                      }
                      // Set current index and tab screen
                      _currentPageIndex = currentPageIndex;
                      _setCurrentTab();
                      setState(() {});
                    },
                    isSelected: _currentPageIndex == 2,
                  ),
                  /* <----- Documents tab button -----> */
                  CustomBottomNavbarItemWidget(
                    toolTipMessage: 'منتجاتي',
                    icon: Icon( Icons.add_business_rounded,
                        size: 30,
                        color: _currentPageIndex == 3
                            ? AppColors.primaryColor
                            : AppColors.primaryFontColor),
                    onTap: () {
                      const currentPageIndex = 3;
                      if (currentPageIndex == _currentPageIndex) {
                        return;
                      }
                      // Set current index and tab screen
                      _currentPageIndex = currentPageIndex;
                      _setCurrentTab();
                      setState(() {});
                    },
                    isSelected: _currentPageIndex == 3,
                  ),
                  /* <----- Category tab button -----> */
                  CustomBottomNavbarItemWidget(
                    toolTipMessage: 'حالاتي',
                    icon: SvgPicture.asset(
                      AppAssetImages.personIconSVG,
                      height: 30,
                      width: 30,
                      color: _currentPageIndex == 4
                          ? AppColors.primaryColor
                          : null,
                    ),
                    onTap: () {
                      const currentPageIndex = 4;
                      if (currentPageIndex == _currentPageIndex) {
                        return;
                      }
                      // Set current index and tab screen
                      _currentPageIndex = currentPageIndex;
                      _setCurrentTab();
                      setState(() {});
                    },
                    isSelected: _currentPageIndex == 4,
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> getdata() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";

    int Citees = prefsssss.getInt('citiesss') ?? 0;
    print('datastring$datastring');

    if (datastring != "") {
      setState(() {
        data = json.decode(datastring);
        accountid = prefsssss.getInt('accountid') ?? 0;

        if (accountid != 0) {
          login = true;
        }
      });
    }
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


      });
      prefsssss.setString("dentisttype", dentist.type);

      var responsenotify = await CallApi().getallData("getnumbernotification/${dentist.city}/${dentist.university}/${dentist.id}");

      var bodynotify = json.decode(utf8.decode(responsenotify.bodyBytes));
      int count=bodynotify??0;
      print("countcount$count");
      int oldcount=prefsssss.getInt("countnotification") ??0;
      setState(() {
        if(count>oldcount){
          newnotification=count-oldcount;

        }
      });
    }

  }
}

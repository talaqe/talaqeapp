
import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/ads.dart';

import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  /// Page controller for managing intro content sequences.
  final PageController _pageController = PageController(   initialPage: 0,);

  String sloganText = '';
  String subtitleText = '';
  String namebutton = '';
  String linkbtn = '';
  bool showSkipButton = true;
  int _pageIndex = 0;
  int length=3;
  int accountid=0;
  int totalsavestat=0;
  final List<Ads> _Ads=[];
  var body;
  int  citiesss=0;
  var bodyrequse;
  List<dynamic> data=[];
  /// Go to next intro section
  void _gotoNextIntroSection(BuildContext context) {
    // If intro section ends, goto sign in screen.
    if (_pageController.page == _Ads.length - 1) {
      getdata();
    }
    // Goto next intro section
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastLinearToSlowEaseIn);
  }

  @override
  void initState() {
    getsaved_data ();
    if (_pageController.hasClients) {
      // _pageController.jumpToPage(0);
    }
    _pageIndex = 0;
    sloganText = "Talaqe";
    subtitleText = "منصة تلاقي";
    showSkipButton = true;
    Timer.periodic(const Duration(seconds: 5), (Timer timer)


    {
      Future.delayed(const Duration(seconds: 5), () {
        // Here you can write your code
        setState(() {
          // Here you can write your code for open new view
          if (_pageIndex < 2) {
            _pageIndex++;
          } else {
            _pageIndex = 0;
          }
          _pageController.animateToPage(
            _pageIndex,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        });
      });

    });

    super.initState();
  }
  Future<void> getsaved_data () async {
    // SharedPreferences.setMockInitialValues({});

    // savepref(utf8.decode(response.bodyBytes).toString(), "data");
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";

    data = json.decode(datastring);
    Map datatype=data[0];
    List<dynamic> ads=datatype['ads'];
     print('adss $ads');
    for (var element in ads) {
      setState(() {
        _Ads.add(
            Ads(element['id'], element['img'] ?? "",
                element['title'] ?? "",element['text'] ?? "",element['namebutton'] ?? "",element['link'] ?? ""));
      });
    }
    setState(() {
      sloganText=_Ads[0].title;
      subtitleText=_Ads[0].text;
      namebutton=_Ads[0].namebtn;
      linkbtn=_Ads[0].link;

    });



    // shpref.setInt("accountid", 0);
    // shpref.setString("active", 'notactive');

  }
  Future<void> getdata() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String activeaccount = prefsssss.getString('active') ?? "notactive";


    setState((){
      accountid = prefsssss.getInt('accountid') ?? 0;
      totalsavestat = prefsssss.getInt('totalsavestat') ?? 0;
      citiesss= prefsssss.getInt('citiesss')??0;
    });

    print("acccccc$accountid");
    DateTime date = DateTime.now();
    String day= DateFormat('EEEE').format(date);

    print('daay$accountid');
    if(day=="Frinday"){
      setState((){
        totalsavestat=0;
      });

      prefsssss.setInt('totalsavestat', 0);
    }
    var datasend={
      'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
      'id':accountid,
    };
    var response=await CallApi().postData(datasend,'active/dentist');
    print('responefffffffffff :  ${response.body}');
    setState((){
      bodyrequse=json.decode(response.body);
    });


    print("active $activeaccount");
    if(accountid==0){
      Navigator.pushNamedAndRemoveUntil(
          context, AppPageNames.signInOrSignUpScreen, (_) => false);

    }
    if(bodyrequse['success']==true){
      if(accountid!=0){
        if(bodyrequse['active']!="active") {
          print("mooooooooooooooooot"+bodyrequse['active']);

          Navigator.pushNamedAndRemoveUntil(
              context, AppPageNames.notactiveScreen, (_) => false);

        }
        if(bodyrequse['active']=="active") {
          if(citiesss==0){
            Navigator.pushNamedAndRemoveUntil(
                context, AppPageNames.setUpCityScreen, (_) => false);

          }
          if(citiesss!=0){
            Navigator.pushNamedAndRemoveUntil(
                context, AppPageNames.homeNavigatorScreen, (_) => false);

          }
        }
      }
    }else{
      Navigator.pushNamedAndRemoveUntil(
          context, AppPageNames.signInOrSignUpScreen, (_) => false);
    }
 }
  @override
  Widget build(BuildContext context) {
    /// Get screen size
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      /* <-------- Content --------> */
      extendBody: true,
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: ((value) {
          setState(() {
            sloganText = _Ads[value].title;
            subtitleText =_Ads[value].text;
            namebutton=_Ads[value].namebtn;
            linkbtn=_Ads[value].link;
            _pageIndex = value;
          });
         if(_pageIndex<_Ads.length) {
           Future.delayed(const Duration(seconds: 10), () {
             // Here you can write your code
             setState(() {
               // Here you can write your code for open new view
               if (_pageIndex < 2) {
                 _pageIndex++;
               } else {
                 _pageIndex = 0;
               }
               _pageController.animateToPage(
                 _pageIndex,
                 duration: const Duration(milliseconds: 350),
                 curve: Curves.easeIn,
               );
             });
           });
         }
        }),
        scrollDirection: Axis.horizontal,
        itemCount: _Ads.length,
        itemBuilder: (context, index) {
          /// Single intro screen data
          final introContent = _Ads[index];
          /* <---- Single Intro screen widget ----> */
          return Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Container(
                      height: screenSize.height / 2.2 + 10,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Container(
                      height: screenSize.height / 2.2,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.network(
                                "https://talaqe.org/storage/app/public/${introContent.img}",
                                cacheHeight:
                                    ((screenSize.height / 2.2) * 1.5).toInt(),
                              ).image)),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      /* <-------- Bottom bar --------> */
      bottomNavigationBar: Container(
        height: 368,
        margin: AppGaps.bottomNavBarPadding,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(AppComponents.largeBorderRadius)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: HighlightAndDetailTextWidget(
                    slogan: sloganText, subtitle: subtitleText),
              ),
              AppGaps.hGap10,
              SizedBox(
                height: 20,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        _Ads.length,
                        (index) => Builder(builder: (context) {
                              double size = _pageIndex == index ? 12 : 6;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeIn,
                                height: size,
                                width: size,
                                alignment: Alignment.center,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: SvgPicture.asset(
                                  AppAssetImages.pageIndicatorIconSVG,
                                  color: _pageIndex == index
                                      ? AppColors.primaryColor
                                      : AppColors.primaryColor.withOpacity(0.3),
                                ),
                                // child: Icon( Icons.circle,),
                              );
                            }))),
              ),
              AppGaps.hGap20,
              CustomStretchedTextButtonWidget(
                  onTap: () => gotothelink(_pageIndex),
                  buttonText: namebutton),
              showSkipButton
                  ? TextButton(
                      onPressed: () {
                        getdata();
                      },
                      child: const Text('تخطي',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.secondaryFontColor)))
                  : AppGaps.hGap48,
            ],
          ),
        ),
      ),
    );
  }

  gotothelink(int pageIndex) async {
    final Uri url = Uri.parse(linkbtn);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $linkbtn');
    }
  }
}


import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/banner.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/home_navigator_screens/settings_screen.dart';
import 'package:talaqe/signin_or_signup_screen.dart';
import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/widgets/home_doctors_screen_widgets.dart';
import 'package:talaqe/widgets/home_screen_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen  extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedCategoryIndex = 0;
  final List<Typetreatment> _Typetreatments =[];
  List<dynamic> data=[];
  int accountid=0;
  int my=0;
  int oldsize=0;
  double height=0;
  ScrollController scrollController = ScrollController();
  List<allStatus> _statuseslist =[];
  final List<AdsBanner> _banerlist =[];
  bool selectspecialtype=false;
  List<City> _cities=[] ;
  TextEditingController searchcontroller = TextEditingController();
  Dentist dentist=Dentist(0, "", "", "", "", "", "", "", "", "","","");
  final Typetreatment _selecttype=Typetreatment(0, "", "");
  final City _selectedcities=City(0, "المدينة");
  int offset = 0;
  bool statusload=true;
  bool login=false;
  List<Widget> widgetlist =[];
  bool haveimage=false;
  String imagepath="";

  Future<void> getData() async {
    setState(() {
      _statuseslist.clear();
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
        prefsssss.setString("dentisttype", dentist.type);
      }
      var response3=await CallApi().getallData("getbaner");
      var body3 = json.decode(utf8.decode(response3.bodyBytes));
      print('respone banners  $body3');
      List<dynamic> banners=body3;
      setState(() {
        for (var element in banners) {
          print("add to areas $element");

          _banerlist.add(
              AdsBanner(
                  element['id'],
                  element['image'],
                  element['link']
              )
            );
        }
      });
      List<dynamic> typetreatments = datatype['Typetreatment'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in typetreatments) {
          print("add to areas $element");
        if(!login){
          if (element['name'] != "حالات خاصة") {

            _Typetreatments.add(
                Typetreatment(element['id'], element['name'] ?? "",
                    element['image'] ?? ""));}
        }
          if(login) {
            if (dentist.type != "advanced") {
              if (element['name'] != "حالات خاصة") {
                _Typetreatments.add(
                    Typetreatment(element['id'], element['name'] ?? "",
                        element['image'] ?? ""));
              }
            } else {
              _Typetreatments.add(
                  Typetreatment(element['id'], element['name'] ?? "",
                      element['image'] ?? ""));
            }
          }

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



      if(_selectedcities.id!=0){
        fetchPagewithcity(0, _selectedcities.id);

      }else{
        _fetchPage(0);
      }

    }
    if(imagepath!=""){
      imagepath="https://talaqe.org/storage/app/public/$imagepath";
    }
    print("https://talaqe.org/storage/app/public/$imagepath");




  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }



  @override
  void initState() {
    // TODO: implement initState
    _statuseslist=[];
    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent==scrollController.offset){
        _fetchPage(offset);
      }
    });
    getData();
    super.initState();
  }

  Future<void> fetchPagewithtrat(int pageKey,int idtreatment,int cityid) async {
    setState(() {
      offset=offset+10;
    });
    print('respone pageKeytreat  $pageKey');

    print('respone idtreatment  $idtreatment');
    var response=await CallApi().getallData("getstatusss_withtreat_city/$pageKey/$idtreatment/$cityid");
    var body = json.decode(utf8.decode(response.bodyBytes));
    print('respone fetchPagewithtrat  $body');

    List<dynamic> statuslist=body;
    setState(() {

       if(pageKey==0){
         _statuseslist=[];
       }
      for (var element in statuslist) {
        print("iddddddddsss${element['id']}");
        _statuseslist.add(

            allStatus(element['id'], element['dentistid'].toString() ?? "",
                element['patientid'].toString() ?? "",
                element['type'] ?? "",
                element['typetreatment'] ?? "",
                element['treatment'] ?? "",
                element['datetreatment'] ?? "",
                element['status'] ?? "",
                element['notes'] ?? "",
                element['created_at'] ?? "",
                element['updated_at'] ?? "",
                element['nametreat'] ?? "",
                element['imgtreat'] ?? "",
                element['patientname'] ?? "",
                element['patientage'] ?? "",
                element['patientgender'] ?? "",
                element['patientcity'] ?? "",
                element['patientlocation'] ?? "",
                element['patientother'] ?? "",
                element['patientcreated_at'] ?? "",
                element['patientidentifynumber'] ?? "",
                element['patientphone'] ?? "",
                element['patientemail'] ?? "",
                element['notesp'] ?? "")    );
      }


    });
    print('respone offset  $offset');

    setState(() {
      statusload=false;
      oldsize=_statuseslist.length;
    });
  }
  Future<void> fetchPagewithcity(int pageKey,int idcity) async {
    setState(() {
      offset=offset+10;
    });
    print('respone pageKeycity  $pageKey');
    var response=await CallApi().getallData("getstatusss_withcity/$pageKey/$idcity");
    var body = json.decode(utf8.decode(response.bodyBytes));
    print('respone statuslist  $body');
    List<dynamic> statuslist=body;

    setState(() {

      if(pageKey==0){
        _statuseslist=[];
      }
      for (var element in statuslist) {
        print("iddddddddsss${element['id']}");
        _statuseslist.add(


            allStatus(element['id'], element['dentistid'].toString() ?? "",
                element['patientid'].toString() ?? "",
                element['type'] ?? "",
                element['typetreatment'] ?? "",
                element['treatment'] ?? "",
                element['datetreatment'] ?? "",
                element['status'] ?? "",
                element['notes'] ?? "",
                element['created_at'] ?? "",
                element['updated_at'] ?? "",
                element['nametreat'] ?? "",
                element['imgtreat'] ?? "",
                element['patientname'] ?? "",
                element['patientage'] ?? "",
                element['patientgender'] ?? "",
                element['patientcity'] ?? "",
                element['patientlocation'] ?? "",
                element['patientother'] ?? "",
                element['patientcreated_at'] ?? "",
                element['patientidentifynumber'] ?? "",
                element['patientphone'] ?? "",
                element['patientemail'] ?? "",
                element['notesp'] ?? "")    );
      }


    });
    print('respone _statuseslist  ${_statuseslist.length}');

    setState(() {
      statusload=false;
      oldsize=_statuseslist.length;
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    setState(() {
      offset=offset+10;
    });
    print('respone pageKey  $pageKey');
    var response;
    print('myyyyyyyyy');

    response = await CallApi().getallData("getstatusss/$pageKey");

    var body = json.decode(utf8.decode(response.bodyBytes));
    List<dynamic> statuslist=body;
    setState(() {
      if(pageKey==0){
        _statuseslist=[];
      }
      for (var element in statuslist) {
        print("iddddddddsssdddddddddddd${element['id']}");
        _statuseslist.add(


            allStatus(element['id'], element['dentistid'].toString()?? "",
                element['patientid'].toString()?? "",
                element['type'] ?? "",
                element['typetreatment'] ?? "",
                element['treatment'] ?? "",
                element['datetreatment'] ?? "",
                element['status'] ?? "",
                element['notes'] ?? "",
                element['created_at'] ?? "",
                element['updated_at'] ?? "",
                element['nametreat'] ?? "",
                element['imgtreat'] ?? "",
                element['patientname'] ?? "",
                element['patientage'] ?? "",
                element['patientgender'] ?? "",
                element['patientcity'] ?? "",
                element['patientlocation'] ?? "",
                element['patientother'] ?? "",
                element['patientcreated_at'] ?? "",
                element['patientidentifynumber'] ?? "",
                element['patientphone'] ?? "",
                element['patientemail'] ?? "",
                element['notesp'] ?? "")    );
      }
      print('respone _statuseslist  ${_statuseslist.length}');
      oldsize=_statuseslist.length;

    });
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
        title: login? Container(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
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
          ),
        ):Container(
          padding: const EdgeInsets.only(top: 10),
          child: Row(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppGaps.wGap16,
              Container(

              child:
              const Text("قم بتسجيل الدحول للاطلاع على كامل خدماتنا ",
                style: TextStyle(fontSize: 12),
              ),
              ),
              AppGaps.wGap16,
              CustomIconButtonWidget(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>   const SignInOrSignUpScreen(),
                        ));
                  },
                  borderRadiusRadiusValue: AppComponents.defaultBorderRadius,
                  backgroundColor: AppColors.primaryColor,
                  child:  const Text("دخول",
                    style: TextStyle(fontSize: 12,color: Colors.white),
                  ),
                  ),
            ],
          ),
        ),
        /* <---- Right side widgets of appbar ----> */
        actions: [
       login?   Center(
            child:  CustomIconButtonWidget(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>   const SettingsScreen(),
                      ));
                },
                borderRadiusRadiusValue: AppComponents.defaultBorderRadius,
                backgroundColor: AppColors.secondaryFontColor.withOpacity(0.2),
                child: SvgPicture.asset(
                  AppAssetImages.categoryDuoColorsIconSVG,
                  height: 26,
                  width: 24,

                  color: AppColors.primaryColor,
                )),
          ):const Center(),
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
          /* <---- Search bar ----> */
          CarouselSlider(
            options: CarouselOptions(height: 150.0,
              aspectRatio: 16/9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,),
            items: _banerlist.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: const BoxDecoration(
                          color: Colors.transparent
                      ),
                      child:  ElevatedButton(
                        onPressed: () async {
                          final Uri url = Uri.parse(i.link);
                          if (!await launchUrl(url)) {
                          throw Exception('Could not launch ${i.link}');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0x006a21ea), padding: const EdgeInsets.all(0), backgroundColor: Colors.transparent,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                        child: FadeInImage(
                          image: NetworkImage("https://talaqe.org/storage/app/public/${i.img}"),

                          fit: BoxFit.fill,

                          placeholder: const AssetImage('asset/banner.png'),
                        ),
                      ),
                  );
                },
              );
            }).toList(),
          ),
          AppGaps.hGap10,
          /* <----- Specialist horizontal list -----> */
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(0 ),
              separatorBuilder: (context, index) => AppGaps.wGap5,
              itemCount: _Typetreatments.length,
              itemBuilder: (context, index) {
                /// Single specialist
                final specialist = _Typetreatments[index];
                int  startIndex =specialist.image.indexOf(".");
                String firstpart=specialist.image.substring(0, startIndex);
                String lastpart=specialist.image.substring(1+startIndex,specialist.image.length );

                return SpecialistWidget(
                    onTap: () {

                      setState(() {
                        print("dentist.type${dentist.type}");

                        _selecttype.id=specialist.id;
                        _selecttype.name=specialist.name;
                        _selecttype.image=specialist.image;
                        offset=0;
                      });

                      scrollController.animateTo( //go to top of scroll
                          0,  //scroll offset to go
                          duration: const Duration(milliseconds: 500), //duration of scroll
                          curve:Curves.fastOutSlowIn //scroll type
                      );
                      fetchPagewithtrat(0, _selecttype.id,_selectedcities.id);
                    },
                    backgroundColor: AppColors.tertiaryColor,
                    icon:  FadeInImage(
                      image: NetworkImage("https://talaqe.org/storage/app/public/$firstpart-small.$lastpart"),
                      height: 35,
                      width:35,
                      fit: BoxFit.fill,

                      placeholder: const AssetImage('asset/gg.jpg'),
                    ),
                    titleText: specialist.name,
                    );
              },
            ),
          ),
          AppGaps.hGap10,

          /* <----- 'Top doctors' text and 'View all' text button row -----> */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('الحالات العامة ', style: AppComponents.headerTextStyle),
              Row(

                children: [

                  Container(
                      width: screenWidth/3+10,
                      height: 23,
                      padding: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                        color:Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child:   CustomTextFormField(
                          isReadOnly: true,


                          hintText: _selectedcities.name,
                          suffixIcon: SizedBox(
                            height: 30,
                            child: PopupMenuButton<int>(
                              padding: EdgeInsets.zero,
                              position: PopupMenuPosition.under,
                              itemBuilder: (context) {
                                return   getarealist();
                              },
                              icon: SvgPicture.asset(AppAssetImages.arrowDownIconSVG,
                                  color: AppColors.secondaryFontColor, width: 12),
                            ),
                          )),
                  ),
                ],
              ),

            ],
          ),

          /* <----- Top doctors horizontal list -----> */
        SizedBox(
            height:screenHeight-400,
            child: _statuseslist.isEmpty? const Center(
                child: Text('لا تتوفر حالات ')
            ):
         RefreshIndicator(
              displacement: 2,
              onRefresh:  getData,
              child: ListView.separated(
                  controller: scrollController,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => AppGaps.hGap5,
                  itemCount:_statuseslist.length+1,
                  padding: const EdgeInsets.only(
                    top: 0,
                    // Bottom extra spaces
                    bottom: 10,
                  ),
                  itemBuilder:getstatuslist

                /// Single doctor data



              ),
            )
          ),
          // Bottom extra spaces

          // Bottom spaces
          AppGaps.hGap100,
        ],
      ))),
    );
  }



  Widget getstatuslist(BuildContext context,int index) {



    if(index<_statuseslist.length) {
      final state=_statuseslist[index];
      String result="";
      if(state.created_at!="") {
        result = state.created_at.substring(
            0, state.created_at.indexOf('T'));
      }
      // final args = ModalRoute.of(context)!.settings.arguments as allStatus;
      return DoctorListTileWidget(
          onTap: () {
            if(login) {
              Navigator.pushNamed(
                  context, AppPageNames.generalStatusScreen,
                  arguments: state);
            }else{
              Navigator.pushNamed(
                  context, AppPageNames.needloginScreen);
            }
          },
          imageProvider: Image
              .network(CallApi.imgurl +state.imgtreat)
              .image,
          isActive: false,
          name: "${state.nametreat} ${state.notesp}",
          reviewText: state.patientname,
          designationText: 'عامة',
          hospitalName: 'تاريخ الإضافة $result');
    }else{
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(

        ),
      );
    }



  }
  List<PopupMenuItem<int>> getarealist() {
    List<PopupMenuItem<int>> list = [];
    for (var element in _cities) {
      print('ffff${element.name}');
      list.add( PopupMenuItem<int>(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Row(
            children: [

              Text(element.name,style:const TextStyle( fontFamily: 'exar',)),
            ],
          ),

          onPressed: () async {
            setState(() {
            _selectedcities.id=element.id;
            _selectedcities.name=element.name;
            offset=0;
          });
          SharedPreferences shpref= await SharedPreferences.getInstance();
          shpref.setInt('citiesss', _selectedcities.id);
          fetchPagewithcity(0,_selectedcities.id);
          Navigator.pop(context);
          },

        ),
      ),);
    }
    return list;

  }


}

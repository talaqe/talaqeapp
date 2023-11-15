import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/data/Gallorywork.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/data/universities.dart';
import 'package:talaqe/data/years.dart';
import 'package:talaqe/fail.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_components.dart';
import 'package:talaqe/utils/constants/app_gaps.dart';
import 'package:talaqe/utils/constants/app_images.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';


import '../CallApi.dart';

class EdittoprotifolioScrean extends StatefulWidget {
int protifolioid;
EdittoprotifolioScrean({super.key, this.protifolioid=0});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Edittoprotifolio();
  }

}



class _Edittoprotifolio extends State<EdittoprotifolioScrean> {
  String cityname="";
  String univname="";
  String yearsname="";
  String typename="";
  City _selectedcities=City(0, "المدينة");
  final List<University> _universities=[] ;
  University _selecteduniversity=University(0,"الجامعة",0);

  final List<Typetreatment> _Typetreatments =[];
  TextEditingController name=TextEditingController();
  TextEditingController massege=TextEditingController();
  Typetreatment _selecttypetreatment=Typetreatment(0,"اختر نوع العلاج","");
  int _protifolioid = 0;
  Gallorywork gallorywork=Gallorywork(0, "", "", "", "", "", "", "", "","","");
  int accountid=0;
  List<dynamic> data=[];
  bool hidePassword = true;
  late File imageFile=File("");
  final List<City> _cities=[] ;
  TextEditingController phone = TextEditingController();
  TextEditingController cityid = TextEditingController();
  TextEditingController universityid = TextEditingController();
  TextEditingController typeid = TextEditingController();
  TextEditingController year = TextEditingController();
  bool haveimage=false;
  Dentist dentist=Dentist(0, "", "", "", "", "", "", "", "", "","","");
  bool _isVisible=false;
  Years years=Years('primary',"السنة ");

  String imagepath="";
  @override
  void initState() {
    // TODO: implement initState
    _protifolioid=widget.protifolioid;
    getData();

    super.initState();
  }
  Future<void> senddata(BuildContext context) async {
    var data={'api_key': 'fYqUL6SU6bMJ_K4z9Nbb1TACyz1GZ7jbPgG',
      'id':accountid.toString(),
      'name':name.text,
      "phone": phone.text,
      "city": _selectedcities.id,
      "university":_selecteduniversity.id,
      "years":years.id,};

    var response=await CallApi().postData(data,'protifolio/edit');

    // var body=json.decode(response.body);
    var body = json.decode(utf8.decode(response.bodyBytes));
    print('respone getallldatttasaalllslk  ${response.body}');

    var responese=await CallApi().getallData('alldata');
    // var body=json.decode(response.body);
    var bodye = json.decode(utf8.decode(responese.bodyBytes));
    print('respone alldata  $body');

    // savepref(utf8.decode(response.bodyBytes).toString(), "data");
    SharedPreferences shpref= await SharedPreferences.getInstance();

    shpref.setString('data', utf8.decode(responese.bodyBytes).toString());
    if(body.toString()==""){
      print('respone ssssssssssss ');

      showdialogfail(context);
    }else {
      if (body['success'] == true) {


        print('respone ${response.body}');
        showdialogsuccess(context);
      }else{
        showdialogfail(context);

      }
    }
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      /* <-------- Appbar --------> */
      appBar: CoreWidgets.appBarWidget(
          screenContext: context, titleWidget: const Text('تغيير معلومات الملف الشخصي ')),
      body: CustomScaffoldBodyWidget(
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: 130,
                              width: 130,
                              margin: const EdgeInsets.only(bottom: 25),
                              decoration: BoxDecoration(
                                  borderRadius:  const BorderRadius.all(
                                      AppComponents.hugeBorderRadius),
                                  image:DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Image.network(imagepath,
                                          cacheHeight: 120,
                                          cacheWidth: 120)
                                          .image)),
                            ),
                            Positioned(
                              child: CustomIconButtonWidget(
                                  onTap: () {
                                    changeImage();
                                  },
                                  fixedSize: const Size(53, 53),
                                  hasBorder: true,
                                  border: Border.all(color: Colors.white, width: 3),
                                  borderRadiusRadiusValue:
                                  AppComponents.largeBorderRadius,
                                  backgroundColor: AppColors.primaryColor,
                                  child:
                                  SvgPicture.asset(AppAssetImages.cameraIconSVG)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  AppGaps.hGap30,
                  CustomTextFormField(
                    controller: name,
                    labelPrefixIcon: SvgPicture.asset(AppAssetImages.personIconSVG),
                    labelText: 'الاسم ',
                    hintText: dentist.name,
                  ),
                  AppGaps.hGap30,
                  CustomTextFormField(
                    controller: phone,
                    labelPrefixIcon: SvgPicture.asset(
                        AppAssetImages.phoneCallingIconSVG,
                        color: AppColors.secondaryFontColor),

                    labelText: 'رقم الهاتف',
                    hintText: dentist.phone,
                  ),

                  AppGaps.hGap30,
                  CustomTextFormField(
                    controller: cityid,
                      isReadOnly: true,
                      labelPrefixIcon: SvgPicture.asset(
                        AppAssetImages.groupIconSVG,
                        color: AppColors.secondaryFontColor,
                      ),
                      labelText: 'المدينة',
                      hintText: cityname,
                      suffixIcon: SizedBox(
                        height: 28,
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
                  AppGaps.hGap30,
                  /* <---- Birth date text field ----> */
                  CustomTextFormField(
                      controller: universityid,
                    labelPrefixIcon: SvgPicture.asset(AppAssetImages.calenderIconSVG,
                        color: AppColors.secondaryFontColor),
                    labelText: 'الجامعة',
                    hintText: univname,
                      suffixIcon: SizedBox(
                        height: 28,
                        child: PopupMenuButton<int>(
                          padding: EdgeInsets.zero,
                          position: PopupMenuPosition.under,
                          itemBuilder: (context) {
                            return getuniversitylist();

                          },
                          icon: SvgPicture.asset(AppAssetImages.arrowDownIconSVG,
                              color: AppColors.secondaryFontColor, width: 12),
                        ),
                      ),
                  ),
                  AppGaps.hGap30,
                  /* <---- Address text field ----> */
                  CustomTextFormField(
                    controller: year,
                    minLines: 1,
                    maxLines: 2,
                    labelPrefixIcon: SvgPicture.asset(AppAssetImages.locationIconSVG,
                        color: AppColors.secondaryFontColor),
                    labelText: " السنة الدراسية: ",
                    hintText: yearsname,
                      suffixIcon: SizedBox(
                        height: 28,
                        child: PopupMenuButton<int>(
                          padding: EdgeInsets.zero,
                          position: PopupMenuPosition.under,
                          itemBuilder: (context) {
                            return getyearslist();
                          },
                          icon: SvgPicture.asset(AppAssetImages.arrowDownIconSVG,
                              color: AppColors.secondaryFontColor, width: 12),
                        ),
                      )
                  ),
                  AppGaps.hGap30,
                  /* <---- Address text field ----> */
                  CustomTextFormField(
                    isReadOnly:true,
                    minLines: 1,
                    maxLines: 2,
                    labelPrefixIcon: SvgPicture.asset(AppAssetImages.locationIconSVG,
                        color: AppColors.secondaryFontColor),
                    labelText: "عددالحالات المحجوزة: ",
                    hintText: dentist.statusreserv,
                  ),
                  AppGaps.hGap30,
                  /* <---- Address text field ----> */
                  CustomTextFormField(
                    isReadOnly:true,

                    minLines: 1,
                    maxLines: 2,
                    labelPrefixIcon: SvgPicture.asset(AppAssetImages.locationIconSVG,
                        color: AppColors.secondaryFontColor),
                    labelText: "  نوع الحساب: ",
                    hintText: typename,
                  ),
                  // Bottom extra spaces
                  AppGaps.hGap30,
                ],
              ))),
      bottomNavigationBar: CustomScaffoldBottomBarWidget(
          child: CustomStretchedTextButtonWidget(
              onTap: () {
                senddata(context);
              }, buttonText: 'حفظ')),
    );
  }
  Widget gettreatmentlist() {
    List<Widget> list = [];
    for (var element in _Typetreatments) {
      print('ffff${element.name}');
      list.add( ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          children: [
           
            Text(element.name,
            style:const TextStyle( fontFamily: 'exar',)),
          ],
        ),

        onPressed: (){setState(() {
          _selecttypetreatment=element;

        });
        Navigator.pop(context);
        },

      ),);
    }
    return SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(top: 20),
            child:  Column(
              children: list,
            )
        ));

  }


  List<PopupMenuItem<int>> getyearslist() {
    List<PopupMenuItem<int>> list = [];
    List<Years> yearslist = [
      Years('primary','السنة الاولى'),
      Years('primary','السنة الثانية'),
      Years('primary','السنة الثالثة'),
      Years('forth',' السنة الرابعة'),
      Years('fifth','  السنة الخامسة'),
      Years('excellent',' امتياز'),
      Years('master','ماستر '),
    ];
    for (var element in yearslist) {
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

          onPressed: (){setState(() {
            years=element;
            yearsname=element.name;
          });
          Navigator.pop(context);
          },

        ),
      ),);
    }
    return list;

  }
  void showdialog(BuildContext context) {
    showDialog<void>(
        context: context,
        // barrierDismissible: barrierDismissible,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(top: 0.0, right: 0.0),
                      decoration: const BoxDecoration(
                          color: Colors.white,


                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 0.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[


                          Container(
                            margin: const EdgeInsets.all(20.0),
                            child: const Center(
                              child: Text('الرجاء التاكد من المعلومات',
                                style: TextStyle(
                                  fontFamily: 'exar',
                                ),),
                            ),

                          ),

                          InkWell(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,

                              ),
                              child: const Text(
                                "اغلاق",
                                style: TextStyle(
                                    color:  Color(0xFF6F1CE6),
                                    fontFamily: 'exar',
                                    fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(dialogContext).pop();


                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(dialogContext).pop();

                        },
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          );
        });
  }

  List<PopupMenuItem<int>> getuniversitylist() {
    List<PopupMenuItem<int>> list = [];
    if(_selectedcities.id==0){
      list.add(const PopupMenuItem<int>(child: Text("الرجاء اختيار المدينة اولا",style:TextStyle( fontFamily: 'exar',))));
    }
    for (var element in _universities) {
      if(element.cityid==_selectedcities.id) {
        list.add(
          PopupMenuItem<int>(
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

              onPressed: () {
                setState(() {
                  _selecteduniversity = element;
                  univname=element.name;
                  universityid.text = element.name;
                });
                Navigator.pop(context);
              },

            ),
          ),);
      }

    }
    return list;

  }
  void showdialogsuccess(BuildContext context) {
    showDialog<void>(
        context: context,
        // barrierDismissible: barrierDismissible,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(top: 0.0, right: 0.0),
                      decoration: const BoxDecoration(
                          color: Colors.white,


                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 0.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[


                          Container(
                            margin: const EdgeInsets.all(20.0),
                            child: const Center(
                              child: Text(' تم حفط المعلومات',
                                style: TextStyle(
                                  fontFamily: 'exar',
                                ),),
                            ),

                          ),

                          InkWell(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,

                              ),
                              child: const Text(
                                "متابعة",
                                style: TextStyle(
                                    color:  Color(0xFF6F1CE6), fontSize: 20.0,
                                  fontFamily: 'exar',),
                                textAlign: TextAlign.center,

                              ),
                            ),
                            onTap: () {
                              //AddImageprotiflio
                              Navigator.of(dialogContext).pop();
                              Navigator.pushNamed(
                                  context, AppPageNames.editProfileScreen);




                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(dialogContext).pop();

                        },
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color:  Color(0xFF6F1CE6)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          );
        });
  }

  void showdialogfail(BuildContext context){
    showDialog<void>(
        context: context,
        // barrierDismissible: barrierDismissible,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(top: 0.0, right: 0.0),
                      decoration: const BoxDecoration(
                          color: Colors.white,


                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 0.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[


                          Container(
                            margin: const EdgeInsets.all(20.0),
                            child: const Center(
                              child: Text('فشل بارسال الرسالة الرجاح التحقق من الاتصال ومعاودة المحاولة',
                                style: TextStyle(
                                  fontFamily: 'exar',
                                ),),
                            ),

                          ),

                          InkWell(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,

                              ),
                              child: const Text(
                                "نعم",
                                style: TextStyle(
                                    color:   Color(0xFF6F1CE6), fontSize: 25.0,
                                  fontFamily: 'exar',),
                                textAlign: TextAlign.center,

                              ),
                            ),
                            onTap: () {
                              Navigator.pop(dialogContext);

                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(dialogContext).pop();

                        },
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color:  Color(0xFF6F1CE6)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          );
        });

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

          onPressed: (){setState(() {
            _selectedcities=element;
            _isVisible = true;
            cityname=element.name;
            cityid.text=element.name;
          });
          Navigator.pop(context);
          },

        ),
      ),);
    }
    return list;

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


      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());
      setState(() {
        for (var element in cities) {

          print("add to areas $element");

          if(element['id']==int.parse(dentist.city)){
            _selectedcities.id=element['id'];
            _selectedcities.name=element['name'] ;
            cityname=element['name'];
          }
        }
      });
      List<dynamic> universities = datatype['University'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in universities) {
          print("add to areas $element");
          if(element['id']==int.parse(dentist.university)) {
            univname=element['name'];
            _selecteduniversity.id=element['id'];
            _selecteduniversity.name=element['name'];
            _selecteduniversity.cityid=element['cityid'];
          }
        }
      });

      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in universities) {
          print("add to areas $element");

          _universities.add(
              University(element['id'], element['name'] ?? "",
                  int.parse(  element['cityid'].toString()??"0")));
        }
      });
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in cities) {

          print("add to areas $element");

          _cities.add(
              City(element['id'], element['name'] ?? ""));
        }
      });
      if(dentist.type=='normal'){
        typename="عادي";
      }else if(dentist.type=="medium"){
        typename="فضي";

      }else{
        typename="ذهبي";

      }
    }

    setState(() {
    if(dentist.years=="primary"){
      yearsname="سنة اولى/ثانية/ثالثة";
      years=Years('primary',"السنة ");
    }else if(dentist.years=='forth'){
      years= Years('forth',' السنة الرابعة');
      yearsname="سنة رابعة";
    }else if(dentist.years=='fifth'){
      years=Years('fifth','  السنة الخامسة');
      yearsname="سنة خامسة";
    }else if(dentist.years=='excellent'){
      years=Years('excellent',' امتياز');
      yearsname="امتياز ";
    }else if(dentist.years=='master'){
      years=Years('master','ماستر ');
      yearsname="ماستر ";
    }



    name.text=dentist.name;
    phone.text=dentist.phone;

  });



    if(imagepath!=""){
      imagepath="https://talaqe.org/storage/app/public/$imagepath";
    }
    print("https://talaqe.org/storage/app/public/$imagepath");



  }

  Future<void> changeImage() async {
    if (kIsWeb) {
      // running on the web!
      final Uri url = Uri.parse(
          'https://talaqe.org/api/uploadimg/$accountid/profileimg');
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
      else {
        PickedFile? pickedFile = await ImagePicker().getImage(
          source: ImageSource.gallery,
          maxWidth: 1800,
          maxHeight: 1800,
        );
        if (pickedFile != null) {
          setState(() {
            imageFile = File(pickedFile.path);
          });
          Map<String, String> iddata = {

            'id': accountid.toString()};

          var response2 = await CallApi().addImagedentist(
              iddata, imageFile.path);
          print('responedddddd :  $response2');
          var body = json.decode(response2);
          SharedPreferences prefsssss = await SharedPreferences.getInstance();

          prefsssss.setString("imagedintest", body["success"]);
          String image = body["success"];
          setState(() {
            int startIndex = image.indexOf(".");
            String firstpart = image.substring(0, startIndex);
            String lastpart = image.substring(1 + startIndex, image.length);
            imagepath = "$firstpart-small.$lastpart";
            print("imagepath$imagepath");
          });
          _refreshData();
        }
      }
  }
  Future<void> _refreshData() async {
    try {
      var response = await CallApi().getallData('alldata');
      // var body=json.decode(response.body);
      var body = json.decode(utf8.decode(response.bodyBytes));
      print('respone getallldatttasaallls  ${response.body}');
      SharedPreferences shpref= await SharedPreferences.getInstance();
      shpref.setString('data', utf8.decode(response.bodyBytes).toString());
    } on TimeoutException catch (_) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Fail()));
    }
    on SocketException catch (_) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Fail()));
    }
    getData();

  }
}
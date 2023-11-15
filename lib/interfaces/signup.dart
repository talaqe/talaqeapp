import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/data/universities.dart';
import 'package:talaqe/data/years.dart';
import 'package:talaqe/interfaces/active.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_gaps.dart';
import 'package:talaqe/utils/constants/app_images.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:talaqe/widgets/sign_in_screen_widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../fail.dart';
import '../CallApi.dart';
import 'index.dart';

import 'package:image_picker/image_picker.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignupWidgetState();
  }

}



class _SignupWidgetState extends State<Signup> {
  String link = "https://talaqe.org/api";
  String textt="";
  bool showProgress = false;
  final List<City> _cities=[] ;
  City _selectedcities=City(0,"المدينة");
 String options="f";
  final List<University> _universities=[] ;
  University _selecteduniversity=University(0,"الجامعة",0);
  bool hidePassword = true;

  final List<Typetreatment> _typetreatments=[] ;
  Typetreatment _selectedtypetreatment=Typetreatment(0,"نوع المعالجة","");
  Years years=Years('primary',"السنة ");
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController cityid = TextEditingController();
  TextEditingController universityid = TextEditingController();
  TextEditingController typeid = TextEditingController();
  TextEditingController numberid = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController image = TextEditingController();
  bool _isVisible=false;
  bool progress=false;
  List<dynamic> data=[];
  late File imageFile=File("");

  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";
    if (datastring != "") {
      data = json.decode(datastring);

      Map datatype=data[0];
      List<dynamic> typetreatments = datatype['Typetreatment'];
      // print('respone areas  ' + data['areas'].toString());
      var about=datatype['About'];
      Map datatypeabout=about[0];
      textt=datatypeabout['textappcheck'].toString();
      print('respone areas  ${datatypeabout['textappcheck']}');
      setState(() {
        for (var element in typetreatments) {
          print("add to areas $element");

          _typetreatments.add(
              Typetreatment(element['id'], element['name'] ?? "",
                  element['image'] ?? ""));
        }
      });
      List<dynamic> universities = datatype['University'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in universities) {
          print("add to areas $element");

          _universities.add(
              University(element['id'], element['name'] ?? "",
                int.parse(  element['cityid'].toString()??"0")));
        }
      });
      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in cities) {
          
          print("add to areas $element");

          _cities.add(
              City(element['id'], element['name'] ?? ""));
        }
      });

    }
  }

  @override
  initState() {
    getData();
    super.initState();
  }
bool isfile=false;

   @override
  Widget build(BuildContext context) {
     var screenWidth = MediaQuery
         .of(context)
         .size
         .width;
     var screenHeight = MediaQuery
         .of(context)
         .size
         .height;
    return Scaffold(
      /* <-------- Content --------> */
      body: CustomScaffoldBodyWidget(
          child: SafeArea(
            top: true,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /* <----- App logo -----> */
                      Image.asset(AppAssetImages.logo, height: 63.49),
                      AppGaps.hGap20,
                      /* <---- App name text ----> */
                      Image.asset(AppAssetImages.talaqeText, width: 200),

                      AppGaps.hGap60,

                      /* <----- Name text field -----> */
                      CustomTextFormField(
                        controller: name,
                        labelPrefixIcon: SvgPicture.asset(
                            AppAssetImages.personIconSVG,
                            color: AppColors.secondaryFontColor),
                        labelText: 'الاسم',
                        hintText: 'الرجاء ادخال الاسم الكامل',
                      ),
                      AppGaps.wGap30,
                      CustomTextFormField(
                        controller: phone,
                        labelPrefixIcon: SvgPicture.asset(
                            AppAssetImages.phoneCallingIconSVG,
                            color: AppColors.secondaryFontColor),
                        labelText: 'رقم الهاتف ',
                        hintText: 'الرجاء ادخال رقم الهاتف',
                      ),
                      AppGaps.wGap30,
                      /* <----- Password text field -----> */
                      CustomTextFormField(
                        controller: password,
                        isPasswordTextField: hidePassword,
                        labelPrefixIcon: SvgPicture.asset(
                            AppAssetImages.lockIconSVG,
                            color: AppColors.secondaryFontColor),
                        labelText: 'كلمة المرور',
                        hintText: 'الرجاء ادخال كلمة المرور ',
                        suffixIcon: IconButton(
                            padding: const EdgeInsets.only(bottom: 10),
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            // Toggles hide password
                            onPressed: () =>
                                setState(() => hidePassword = !hidePassword),
                            icon: SvgPicture.asset(
                              AppAssetImages.eyeIconSVG,
                              width: 22,
                              color: hidePassword
                                  ? AppColors.secondaryFontColor
                                  : AppColors.primaryColor,
                            )),
                      ),
                      AppGaps.wGap30,
                      CustomTextFormField(
                          isReadOnly: true,
                          labelPrefixIcon: SvgPicture.asset(
                            AppAssetImages.locationIconSVG,
                            color: AppColors.secondaryFontColor,
                            width: 12,
                          ),
                          labelText: 'المدينة',
                          hintText: _selectedcities.name,
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
                      AppGaps.wGap30,
                      CustomTextFormField(
                          isReadOnly: true,
                          labelPrefixIcon: SvgPicture.asset(
                            AppAssetImages.medalBadgeIconSVG,
                            color: AppColors.secondaryFontColor,
                            width: 12,
                          ),
                          labelText: 'الجامعة',
                          hintText: _selecteduniversity.name,
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
                          )),
                      AppGaps.wGap30,
                      CustomTextFormField(
                          isReadOnly: true,
                          labelPrefixIcon: SvgPicture.asset(
                            AppAssetImages.checkMarkTickIconSVG,
                            color: AppColors.secondaryFontColor,
                            width: 12,
                          ),
                          labelText: 'السنة الدراسية',
                          hintText: years.name,
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
                          )),
                      AppGaps.wGap30,
                      SizedBox(
                          width:screenWidth-10 ,
                          child:    Row(
                            children: [   Radio(
                                value: "m",
                                groupValue: options,
                                onChanged: (value){
                                  setState(() {
                                    options = value.toString();
                                  });
                                }),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: const Color(0xFF6F1CE6), elevation: 0, backgroundColor: Colors.transparent,
                                  padding: EdgeInsets.zero ,
                                  shadowColor:  Colors.transparent,
                                ),
                                onPressed: () {
                                  showdialogtext(context);

                                }, child:   const Text('الموافقة على شروط التسجيل',style:TextStyle( fontFamily: 'exar',)),
                              ),

                            ],
                          )
                      ),
                      AppGaps.wGap30,
                   !kIsWeb?Container(
                          color:  Colors.transparent,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: !isfile
                              ?   ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xff0000000), elevation: 0, backgroundColor: Colors.transparent,
                              padding: EdgeInsets.zero ,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {
                              setState((){
                                progress=true;
                              });
                              // _checkPermission(context);
                              _getFromGallery();
                            },
                            child:Row(
                                children: [
                                  SvgPicture.asset(
                                    AppAssetImages.cameraIconSVG,
                                    color: AppColors.secondaryFontColor,
                                    width: 18,
                                  ),
                                  const SizedBox(width:2),
                                  const Text("ارفاق اثبات هوية",style:TextStyle( fontFamily: 'exar',))
                                ]
                            ),
                          ):Column(
                              children:[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color(0xff0000000), elevation: 0, backgroundColor: Colors.white,
                                    padding: EdgeInsets.zero ,
                                    shadowColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    setState((){
                                      progress=true;
                                    });
                                    // _checkPermission(context);
                                    _getFromGallery();
                                  },
                                  child:const Row(
                                      children: [
                                        Icon(Icons.camera_alt),
                                        SizedBox(width:2),
                                        Text("ارفاق اثبات هوية",
                                            style:TextStyle( fontFamily: 'exar',))
                                      ]
                                  ),),
                                Image.file(
                                  imageFile,
                                  width:screenWidth-10,
                                  fit: BoxFit.cover,
                                )
                              ]
                          )
                      ):Container(),
                      AppGaps.hGap40,
                      CustomStretchedTextButtonWidget(
                          buttonText: 'انشاء حساب',
                          onTap: () {

                            if(imageFile.path!="" && phone.text!="" && name.text!="" && name.text != "" && password.text !="" && _selectedcities.id!=0 && _selecteduniversity.id!=0){
                              if(options!="f"){
                                senddata(context);
                              }else{
                                showdialog(context);
                              }

                            }else {
                              showdialog(context);
                            }
                          }),
                      AppGaps.hGap15,
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text('هل تملك حساب بالفعل؟',
                              style:
                              TextStyle(color: AppColors.secondaryFontColor)),
                          AppGaps.wGap3,
                          /* <----- 'Sign in' text button -----> */
                          CustomTightTextButtonWidget(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, AppPageNames.signInScreen);
                              },
                              child: const Text('تسجيل الدخول'))
                        ],
                      ),

                      AppGaps.hGap30,
                    ]),
              ),
            ),
          )),
    );
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

  /// Get from gallery
  _getFromGallery() async {
    if (!kIsWeb) {
      // running on the web!

      print('filee${imageFile.path}');
      PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,

      );

      print('filee${imageFile.path}');
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          isfile = true;
        });
        print('affilee${imageFile.path}');
      }
      setState(() {
        progress = false;
      });
    }
  }
  Future<void> senddata(BuildContext context) async {
    setState(() {
      showProgress=true;
    });
    if(imageFile.path!="") {
  var data={
    'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
    'name':name.text,
    'phone':phone.text,

    'type':"normal",
    'password':password.text,
    'city':_selectedcities.id,
    'years':years.id,
    'university':_selecteduniversity.id,

  };
      var response=await CallApi().postData(data,'signup/dentist');
      print('respone :  ${response.body}');

      var body=json.decode(response.body);

      if(body.toString()==""){
        print('respone ssssssssssss ');
 }
      else {

        int id=0;
        if (body['success'] ==true) {
          setState(() {
            id = body['id'] ?? "0";

          });

            print('imageFile :  ${imageFile.path}');

            Map<String, String> iddata = {
              'id': id.toString()};

            // NOT running on the web! You can check for additional platforms here.
          if (kIsWeb) {
            SharedPreferences prefsssss = await SharedPreferences.getInstance();
            prefsssss.setInt("accountid", id);
            prefsssss.setString("yearss", years.id);
            prefsssss.setString("active", "notactive");
            // running on the web!
            final Uri url = Uri.parse(
                'https://talaqe.org/api/uploadimg/$id/signupimg');
            if (!await launchUrl(url)) {
              throw Exception('Could not launch $url');
            }
            if (!await launchUrl(url)) {
              throw Exception('Could not launch $url');
            }
            Route route = MaterialPageRoute(builder: (context) => const Active());
            Navigator.pushReplacement(context, route);
          } else {
            var response2 = await CallApi().addImage(iddata, imageFile.path);
            print('respone :  $response2');

            SharedPreferences prefsssss = await SharedPreferences.getInstance();
            prefsssss.setInt("accountid", id);
            prefsssss.setString("yearss", years.id);
            prefsssss.setString("active", "notactive");

            Route route = MaterialPageRoute(builder: (context) => const Active());
            Navigator.pushReplacement(context, route);
            setState(() {
              showProgress = false;
            });
          }
        } else {
          showfaildialog(context,'فشل تسجيل الدخول . الرجاء التحقق من المعلومات واعادة المحاولة');

          setState(() {
            showProgress = false;
          });
        }

      }
    }else{
      showfaildialog(context,"الرجاء التاكد من رفع الصورة");
    }
    setState(() {
      showProgress=false;
    });
    }

  void showfaildialog(BuildContext context,text) {
    setState(() {
      showProgress = false;
    });
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
                            child: Center(
                              child: Text(text,style:const TextStyle( fontFamily: 'exar',)),
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
                                style: TextStyle( fontFamily: 'exar',
                                    color: Color(0xFF334541), fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();

                        },
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: Color(0xFF6F1CE6),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
          );
        });
  }


  List<PopupMenuItem<int>> getyearslist() {
    List<PopupMenuItem<int>> list = [];
    List<Years> yearslist = [
      Years('primary','السنة الاولى'),
      Years('primary','السنة الثانية'),
      Years('primary','السنة الثالثة'),
      Years('primary',' السنة الثالثة سريري'),
      Years('forth',' السنة الرابعة'),
      Years('fifth','  السنة الخامسة'),
      Years('excellent',' امتياز'),
      Years('master','ماستر '),
      Years('primary','عيادة خاصة '),
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

          });
          Navigator.pop(context);
          },

        ),
      ),);
    }
    return list;

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
            cityid.text=element.name;
          });
          Navigator.pop(context);
          },

        ),
      ),);
    }
    return list;

  }
  Widget gettypelist() {
    List<Widget> list = [];
    for (var element in _typetreatments) {
      list.add( ElevatedButton(
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
          _selectedtypetreatment=element;

          typeid.text=element.name;
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


  void showdialogtext(BuildContext context) {

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
                            child: Center(
                              child: Text(textt,style:const TextStyle( fontFamily: 'exar',)),
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
                                style: TextStyle( fontFamily: 'exar',
                                    color: Color(0xFF334541), fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();

                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();

                        },
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: Color(0xFF6F1CE6),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
          );
        });
  }
  void _checkPermission(BuildContext context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    Map<Permission, PermissionStatus> statues = await [
      Permission.camera,
      Permission.storage,
      Permission.photos
    ].request();
    PermissionStatus? statusCamera = statues[Permission.camera];
    PermissionStatus? statusStorage = statues[Permission.storage];
    PermissionStatus? statusPhotos = statues[Permission.photos];
    bool isGranted = statusCamera == PermissionStatus.granted &&
        statusStorage == PermissionStatus.granted &&
        statusPhotos == PermissionStatus.granted;
    if (isGranted) {
      //openCameraGallery();
      //_openDialog(context);
    }
    bool isPermanentlyDenied =
        statusCamera == PermissionStatus.permanentlyDenied ||
            statusStorage == PermissionStatus.permanentlyDenied ||
            statusPhotos == PermissionStatus.permanentlyDenied;
    if (isPermanentlyDenied) {
      _showSettingsDialog(context);
    }
  }

  void _showSettingsDialog(BuildContext context) {

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
                              child: Text("يحتاج هذا التطبيق على اذن للوصول للصور الخاصة بك",style:TextStyle( fontFamily: 'exar',)),
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
                                style: TextStyle( fontFamily: 'exar',
                                    color: Color(0xFF334541), fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              openAppSettings();
                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();

                        },
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: Color(0xFF6F1CE6),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
          );
        });
  }
}
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/interfaces/addstatus_screan.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_gaps.dart';
import 'package:talaqe/utils/constants/app_images.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';

import '../navDrawer.dart';
import 'package:talaqe/data/account.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../fail.dart';
import '../CallApi.dart';

class AddpatientScrean extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Addpatient();
  }

}


class _Addpatient extends State<AddpatientScrean> {
  List<dynamic> data=[];
  bool showProgress = false;
  // Account account= null;
  Patient _selectedpetient=new Patient(0, "اختر مريض", "", "", "", "", "", "", "", "", "");
  List<Patient> _patientlist =[];
  int accountid=0;
  List<DropdownMenuItem<City>> citiesItems = [
  ];
  City city=new City(0, "اختر مدينة");
  List<City> citees=[] ;


  String gendervalue='اختر جنس';
  TextEditingController  name=new TextEditingController();
  TextEditingController  age=new TextEditingController();
  TextEditingController  gender=new TextEditingController();
  TextEditingController  cityy=new TextEditingController();
  TextEditingController  location=new TextEditingController();
  TextEditingController  other=new TextEditingController();
  TextEditingController  identifynumber=new TextEditingController();
  TextEditingController  phone=new TextEditingController();
  TextEditingController  email=new TextEditingController();
  String namearea="";
  String  options="m";
  final _formKeyy = GlobalKey<FormState>();
  List<Color>colors=[];

  @override
  void initState() {
    // TODO: implement initState

    getdata();
    super.initState();
  }

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

    return  Scaffold(
      appBar: CoreWidgets.appBarWidget(
          screenContext: context, titleWidget: const Text(' اضافة مريض')),
      body: CustomScaffoldBodyWidget(
          child: SingleChildScrollView(
              child:  showProgress?   Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 100),
                child: Center(child:  CircularProgressIndicator(

                  valueColor:  new AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                  ,)
                ),
              )
                  : Form(
                key: _formKeyy,
                child: Column(
                  children: [
                    AppGaps.hGap60,
                    CustomTextFormField(
                      controller: name,
                      labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.cardIconSVG,
                          color: AppColors.secondaryFontColor),
                      labelText: ' اسم المريض',
                      hintText: ' ادخل اسم المريض',
                    ),
                    AppGaps.hGap20,
                    /* <----- Email text field -----> */
                    CustomTextFormField(
                      controller: age,
                      labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.cardIconSVG,
                          color: AppColors.secondaryFontColor),
                      labelText: ' العمر',
                      hintText: ' ادخل العمر',
                    ),
                    AppGaps.hGap20,
                    Container(
                      alignment: Alignment.centerRight,
                      width: screenWidth-50,
                      child: Text('اختر جنس',
                        style: TextStyle( fontFamily: 'exar',),),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width:screenWidth/2-50 ,
                            child:    Row(
                              children: [   Radio(
                                  value: "m",
                                  groupValue: options,
                                  onChanged: (value){
                                    setState(() {
                                      options = value.toString();
                                    });
                                  }),
                                Text("ذكر",style: TextStyle( fontFamily: 'exar',),),
                              ],
                            )
                        ),
                        Container(
                            width:screenWidth/2-50 ,
                            child:          Row(
                              children: [   Radio(
                                  value: "f",
                                  groupValue: options,
                                  onChanged: (value){
                                    setState(() {
                                      options = value.toString();
                                    });
                                  }),
                                Text(" انثى",
                                  style: TextStyle( fontFamily: 'exar',),),
                              ],
                            )),
                      ],
                    ),
                    AppGaps.hGap20,

                    CustomTextFormField(
                        isReadOnly: true,
                        labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.locationIconSVG,
                          color: AppColors.secondaryFontColor,
                          width: 12,
                        ),
                        labelText: 'المدينة',
                        hintText: city.name,
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
                    AppGaps.wGap20,

                    /* <----- Email text field -----> */
                    CustomTextFormField(
                      controller: location,
                      labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.cardIconSVG,
                          color: AppColors.secondaryFontColor),
                      labelText: ' الموقع',
                      hintText: ' ادخل الموقع',
                    ),
                    AppGaps.hGap20,
                    CustomTextFormField(
                      controller: other,
                      labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.cardIconSVG,
                          color: AppColors.secondaryFontColor),
                      labelText: ' مشاكل صحية',
                      hintText: ' ادخل مشاكل صحية اخرى ان وجدت',
                    ),
                    AppGaps.hGap20,
                    CustomTextFormField(
                      controller: identifynumber,
                      labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.cardIconSVG,
                          color: AppColors.secondaryFontColor),
                      labelText: '  رقم الملف',
                      hintText: ' ادخل رقم الملف    ',
                    ),
                    AppGaps.hGap20,
                    CustomTextFormField(
                      controller: phone,
                      labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.cardIconSVG,
                          color: AppColors.secondaryFontColor),
                      labelText: '  رقم الهاتف',
                      hintText: ' ادخل رقم الهاتف    ',
                    ),
                    AppGaps.hGap20,
                    CustomStretchedTextButtonWidget(
                      onTap: () {
                        if(city.id!=0 && name.text!="" && age.text!="" && phone.text!="" ){
                          senddata();
                        }else{
                          showdilog(context);
                        }

                      },
                      buttonText: 'حفظ',
                    ),
                    AppGaps.hGap20,
                  ],
                ),
              )
          )),
    );
  }
  void showdilog(BuildContext context) {
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
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(top: 0.0, right: 0.0),
                      decoration: BoxDecoration(
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
                            margin: EdgeInsets.all(20.0),
                            child: Center(
                              child: Text('الرجاء ادخال المعلومات كاملة',
                                style: TextStyle(
                                  fontFamily: 'exar',
                                ),),
                            ),

                          ),

                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,

                              ),
                              child: Text(
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
                        child: Align(
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
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(top: 0.0, right: 0.0),
                      decoration: BoxDecoration(
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
                            margin: EdgeInsets.all(20.0),
                            child: Center(
                              child: Text('تم ارسال الرسالة بنجاح',
                                style: TextStyle(
                                  fontFamily: 'exar',
                                ),),
                            ),

                          ),

                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,

                              ),
                              child: Text(
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
                        child: Align(
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
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(top: 0.0, right: 0.0),
                      decoration: BoxDecoration(
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
                            margin: EdgeInsets.all(20.0),
                            child: Center(
                              child: Text('فشل بارسال الرسالة الرجاح التحقق من الاتصال ومعاودة المحاولة',
                                style: TextStyle(
                                  fontFamily: 'exar',
                                ),),
                            ),

                          ),

                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,

                              ),
                              child: Text(
                                "نعم",
                                style: TextStyle(
                                    color:  AppColors.primaryColor,
                                    fontFamily: 'exar',
                                    fontSize: 25.0),
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
                        child: Align(
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



  void showfaildialog(BuildContext context) {
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
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(top: 0.0, right: 0.0),
                      decoration: BoxDecoration(
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
                            margin: EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                  'هذا المريض موجود مسبقا',
                              style:TextStyle(
                                fontFamily: 'exar',
                              )),
                            ),

                          ),

                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,

                              ),
                              child: Text(
                                "متابعة",
                                style: TextStyle( fontFamily: 'exar',
                                    color: AppColors.primaryColor, fontSize: 20.0),
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
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: AppColors.primaryColor,
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

  void showsuccessdialog(BuildContext context) {
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
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(top: 0.0, right: 0.0),
                      decoration: BoxDecoration(
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
                            margin: EdgeInsets.all(20.0),
                            child: Center(
                              child: Text('تمت العملية بنجاح',
                              style:TextStyle( fontFamily: 'exar',)),
                            ),

                          ),

                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,

                              ),
                              child: Text(
                                "متابعة",
                                style: TextStyle( fontFamily: 'exar',
                                    color: AppColors.primaryColor, fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () async {

                              Navigator.of(dialogContext).pop();

                              Navigator.pushNamed(context, AppPageNames.addStatusScreen);


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
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: AppColors.primaryColor,
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
  List<PopupMenuItem<int>> getarealist() {
    List<PopupMenuItem<int>> list = [];
    citees.forEach((element) {
      print('ffff'+element.name);
      list.add( PopupMenuItem<int>(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            primary: Colors.transparent,
            onPrimary: Colors.black,
          ),
          child: Row(
            children: [
              Text(element.name,style:TextStyle( fontFamily: 'exar',)),
            ],
          ),

          onPressed: (){setState(() {
            city=element;
          });
          Navigator.pop(context);
          },

        ),
      ),);
    });
    return list;

  }


  Future<void> getdata() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";
    print('datastring'+datastring);
    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
      });
      print("account id" + accountid.toString());
      Map datatype = data[0];
      List<dynamic> patientlist = datatype['Patient'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        patientlist.forEach((element) {

          print("add to patient " + element.toString());

          _patientlist.add(
              Patient(element['id'],
                element['name'] ?? "",
                element['age'] ?? "",
                element['gender'] ?? "",
                element['city'] ?? "",
                element['location'] ?? "",
                element['other'] ?? "",
                element['created_at'] ?? "",
                element['identifynumber'] ?? "",
                element['phone'] ?? "",
                element['email'] ?? "",
              ));
        });
      });
      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        cities.forEach((element) {
          print("add to areas " + element.toString());

          citees.add(
              City(
                  element['id'],element['name']
              )
          );
           colors.add(new Color(0xFFE0CDFF));

        });

      });
    }

  }


  Future<void> senddata() async {
    setState((){
      showProgress=true;
    });
    var body;
    try{
      var data={'api_key': 'fYqUL6SU6bMJ_K4z9Nbb1TACyz1GZ7jbPgG',
        'phone':phone.text,
        'email':email.text,
        'age':age.text,
        'gender':options,
        'name':name.text,
        'other':other.text,
        'city':city.id,
        'location':location.text,
        'identifynumber':identifynumber.text,
      };

      var response=await CallApi().postData(data,'add/patient');
      print('responeffdfdf '+response.body.toString());
      SharedPreferences prefsssss = await SharedPreferences.getInstance();
      body = json.decode(utf8.decode(response.bodyBytes));
      prefsssss.setString("patientiidd", body['id'].toString());
      prefsssss.setString("patientiiddname", body['name'].toString());

    } on TimeoutException catch (_) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Fail()));
    }
    on SocketException catch (_) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Fail()));
    }
    if(body.toString()==""){
      print('respone ssssssssssss ');

      showfaildialog(context);
    }else {


      int id;
      if (body['success'] ==true) {
        setState(() {

          id = body['id'] ??"0";
        });


        setState(() {
          showProgress = false;

        });
        showsuccessdialog(context);


      } else {
        showfaildialog(context);
      }

    }
  }


}
import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/product.dart';
import 'package:talaqe/data/toothes.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/add_patient_screan.dart';
import 'package:talaqe/interfaces/addtooth.dart';
import 'package:talaqe/interfaces/findpatient.dart';
import 'package:talaqe/interfaces/findperson_screan.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_components.dart';
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

class EditMyproductScrean extends StatefulWidget {
  final Object? argument;
  EditMyproductScrean({Key? key, this.argument}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _EditMyproductScrean();
  }

}


class _EditMyproductScrean extends State<EditMyproductScrean> {
  List<dynamic> data = [];
  bool showProgress = false;
  bool showProgress1 = false;
  List<Widget> list = [];
  List<City> _cities = [];
  bool isfile=false;
  String productstatus="waiting";
  String status="للبيع";
  int patientid = 0;
  String namepatient = "";
  Column listColums = new Column();

  // Account account= null;

  List<Patient> _patientlist = [];
  List<Typetreatment> _typetreamtlist = [];
  Product product = Product(0, "", "","","","","","","","","","","");
  int accountid = 0;
  City _selectedcities = City(0, "المدينة");
  int offset = 0;
  bool selectpatientstatus = false;
  List<Widget> wlist = [];
  String toothss = "0";
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController pricecontroller = new TextEditingController();
  TextEditingController descriptioncontroller = new TextEditingController();
  TextEditingController phonecontroller = new TextEditingController();
  List<DropdownMenuItem<City>> citiesItems = [
  ];
  City city = new City(0, "اختر مدينة");
  Container Tooths = Container();
  late File imageFile=File("");
  bool progress=false;

  ScrollController scrollController = ScrollController();

  List <String> toothplace = [];
  String namearea = "";
  String toothshowtext = "عدداسنان الحالة";
  String options = "general";
  final _formKeyy = GlobalKey<FormState>();

  void _setChatScreenParameter(Object? argument) {
    if (argument != null && argument is Product) {
      product = argument;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _setChatScreenParameter(widget.argument);
    _cities = [city];
    getdata();
    list = [];
    super.initState();
  }

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
      appBar: CoreWidgets.appBarWidget(
          screenContext: context, titleWidget: const Text(' تعديل المنتج'),
        actions: [
          Center(
            child: CustomIconButtonWidget(
                onTap: () {
                  Navigator.pushNamed(
                      context, AppPageNames.editimagesProductScreen,
                      arguments: product);
                },
                borderRadiusRadiusValue: AppComponents.defaultBorderRadius,
                backgroundColor: AppColors.secondaryFontColor.withOpacity(0.2),
                child: SvgPicture.asset(
                  AppAssetImages.plusIconSVG,
                  height: 26,
                  width: 24,

                  color: AppColors.primaryColor,
                )),
          ),
          // Extra right spaces
          AppGaps.wGap24,
        ],),
      body: CustomScaffoldBodyWidget(
          child: SingleChildScrollView(
              child: showProgress ? Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(top: 100),
                child: Center(child: CircularProgressIndicator(

                  valueColor: new AlwaysStoppedAnimation<Color>(
                      Color(0xFF6F1CE6))
                  ,)
                ),
              )
                  : Form(
                key: _formKeyy,
                child: Column(
                  children: [

                    AppGaps.hGap20,
                    /* <----- Email text field -----> */
                    CustomTextFormField(
                      controller: namecontroller,
                      labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.contactBookSolidIconSVG,
                          color: AppColors.secondaryFontColor),
                      labelText: ' اسم المنتج',
                      hintText: 'ادخل الاسم',
                    ),
                    AppGaps.hGap20,
                    /* <----- Email text field -----> */
                    CustomTextFormField(
                      controller: pricecontroller,
                      labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.dollarSymbolIconSVG,
                          color: AppColors.secondaryFontColor),
                      labelText: ' السعر ',
                      hintText: 'ادخل السعر',
                    ),
                    AppGaps.hGap20,
                    /* <----- Email text field -----> */
                    CustomTextFormField(
                      controller: phonecontroller,
                      labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.phoneCallingIconSVG,
                          color: AppColors.secondaryFontColor),
                      labelText: ' رقم الهاتف ',
                      hintText: 'ادخل رقم الهاتف',
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
                        hintText: _selectedcities.name,
                        suffixIcon: SizedBox(
                          height: 28,
                          child: PopupMenuButton<int>(
                            padding: EdgeInsets.zero,
                            position: PopupMenuPosition.under,
                            itemBuilder: (context) {
                              return getarealist();
                            },
                            icon: SvgPicture.asset(
                                AppAssetImages.arrowDownIconSVG,
                                color: AppColors.secondaryFontColor, width: 12),
                          ),
                        )),
                    AppGaps.hGap20,
                    CustomTextFormField(
                        isReadOnly: true,
                        labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.locationIconSVG,
                          color: AppColors.secondaryFontColor,
                          width: 12,
                        ),
                        labelText: 'الحالة',
                        hintText: status,
                        suffixIcon: SizedBox(
                          height: 28,
                          child: PopupMenuButton<int>(
                            padding: EdgeInsets.zero,
                            position: PopupMenuPosition.under,
                            itemBuilder: (context) {
                              return getststuslist();
                            },
                            icon: SvgPicture.asset(
                                AppAssetImages.arrowDownIconSVG,
                                color: AppColors.secondaryFontColor, width: 12),
                          ),
                        )),
                    AppGaps.hGap20,
                    CustomTextFormField(
                      controller: descriptioncontroller,
                      maxLines: 5,
                      minLines: 1,
                      labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.cardIconSVG,
                          color: AppColors.secondaryFontColor),
                      labelText: 'تفاصيل المنتج',
                      hintText: 'ادخل التفاصيل',
                    ),
                    AppGaps.hGap20,
                    /* <----- Email text field -----> */
                    Container(
                        color:  Colors.transparent,
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        child: !isfile
                            ?   ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.zero ,
                            shadowColor: Colors.transparent,
                            primary:  Colors.transparent,
                            onPrimary: Color(0xFF0000000),
                          ),
                          onPressed: () {
                            setState((){
                              progress=true;
                            });
                            _getFromGallery();
                          },
                          child:Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssetImages.cameraIconSVG,
                                  color: AppColors.secondaryFontColor,
                                  width: 18,
                                ),
                                SizedBox(width:2),
                                Text("ارفاق صورة الغلاف",style:TextStyle( fontFamily: 'exar',))
                              ]
                          ),
                        ):Column(
                            children:[
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding: EdgeInsets.zero ,
                                  shadowColor: Colors.transparent,
                                  primary: Colors.white,
                                  onPrimary: Color(0xFF0000000),
                                ),
                                onPressed: () {
                                  setState((){
                                    progress=true;
                                  });
                                  _getFromGallery();
                                },
                                child:Row(
                                    children: [
                                      Icon(Icons.camera_alt),
                                      SizedBox(width:2),
                                      Text("ارفاق صورة الغلاف",
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
                    ),

                    AppGaps.hGap60,
                    CustomStretchedTextButtonWidget(
                      onTap: () {
                        senddata();
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
  List<PopupMenuItem<int>> getststuslist() {
    List<PopupMenuItem<int>> list = [];
    List<String> liststatus=[
      "للبيع"," ملغي ","تم البيع"
    ];
    liststatus.forEach((element) {
      print('ffff' + element);
      list.add(PopupMenuItem<int>(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            primary: Colors.transparent,
            onPrimary: Colors.black,
          ),
          child: Row(
            children: [
              Text(element, style: TextStyle(fontFamily: 'exar',)),
            ],
          ),

          onPressed: () {
            setState(() {
              status=element;
              if(element=="للبيع"){

                productstatus="accepted";
              } if(element==" ملغي "){

                productstatus="cancel";
              }
              if(element=="تم البيع"){

                productstatus="prid";

              }
            });
            Navigator.pop(context);
          },

        ),
      ),);
    });
    return list;
  }
  _getFromGallery() async {
    print('filee'+imageFile.path);
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,

    );

    print('filee'+imageFile.path);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        isfile=true;
      });
      print('affilee'+imageFile.path);
    }
    setState((){
      progress=false;
    }) ;
  }
  List<PopupMenuItem<int>> getarealist() {
    List<PopupMenuItem<int>> list = [];
    _cities.forEach((element) {
      print('ffff' + element.name);
      list.add(PopupMenuItem<int>(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            primary: Colors.transparent,
            onPrimary: Colors.black,
          ),
          child: Row(
            children: [
              Text(element.name, style: TextStyle(fontFamily: 'exar',)),
            ],
          ),

          onPressed: () {
            setState(() {
              _selectedcities = element;
            });
            Navigator.pop(context);
          },

        ),
      ),);
    });
    return list;
  }

  void showfaildialog(BuildContext context) {
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
                                'فشل تعديل البيانات الرجاء المحاولة مرة ثانية',
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
                                "متابعة",
                                style: TextStyle(fontFamily: 'exar',
                                    color: AppColors.primaryColor,
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
                            child: Icon(Icons.close, color: AppColors
                                .primaryColor,
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
                                    color: Color(0xFF6F1CE6),
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
                            child: Icon(Icons.close, color: AppColors
                                .primaryColor),
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

  void showdialogfail(BuildContext context) {
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
                                'فشل بارسال الرسالة الرجاح التحقق من الاتصال ومعاودة المحاولة',
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
                                    color: AppColors.primaryColor,
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
                            child: Icon(Icons.close, color: AppColors
                                .primaryColor),
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
                              child: Text('الرجاء التاكد من المعلومات',
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
                                    color: Color(0xFF6F1CE6),
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
                            child: Icon(Icons.close, color: AppColors
                                .primaryColor),
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


  void showsuccessdialog() {
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
                                  style: TextStyle(fontFamily: 'exar',)),
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
                                style: TextStyle(fontFamily: 'exar',
                                    color: AppColors.primaryColor,
                                    fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              Navigator.pushNamed(
                                  context, AppPageNames.editimagesProductScreen,
                                  arguments: product);
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
                            child: Icon(Icons.close, color: AppColors
                                .primaryColor,
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


  getpatientlist() {
    var screanwidth = MediaQuery
        .of(context)
        .size
        .width;
    var screanheight = MediaQuery
        .of(context)
        .size
        .height;
    print('ffffffffffffffffffffffff' + list.length.toString());
  }

  Future<void> getdata() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();

    var response = await CallApi().getallData('alldata');
    // var body=json.decode(response.body);
    var datastring = utf8.decode(response.bodyBytes);
    // print('respone alldata  '+datastring.toString());
    if (datastring != "") {
      data = json.decode(datastring);
      String patientid = prefsssss.getString('patientiidd') ?? "0";
      String patientname = prefsssss.getString('patientiiddname') ?? "";
      print("patientidddddd" + patientid);
      int Citees = prefsssss.getInt('citiesss') ?? 0;

      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
        namecontroller.text=product.title;
        pricecontroller.text=product.price;
        phonecontroller.text=product.phone;
        descriptioncontroller.text=product.description;

      });

      print("account id" + accountid.toString());
      Map datatype = data[0];

      if (selectpatientstatus == true) {
        prefsssss.setString("patientiidd", "");
      }
      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());
      int? idselectedcities = prefsssss.getInt("_selectedcities");
      setState(() {
        _cities = [];
        cities.forEach((element) {
          if (Citees == element['id']) {
            _selectedcities.id = element['id'];
            _selectedcities.name = element['name'];
          }
          print("add to areas " + element.toString());

          _cities.add(
              City(element['id'], element['name'] ?? ""));
          if (element['id'] == idselectedcities) {
            _selectedcities.id = element['id'];
            _selectedcities.name = element['name'];
          }
        });
      });

      List<dynamic> typetreatments = datatype['Typetreatment'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        typetreatments.forEach((element) {
          print("add to areas " + element.toString());

          _typetreamtlist.add(
              Typetreatment(element['id'], element['name'] ?? "",
                  element['image'] ?? ""));
        });
      });
      list = [];
      listColums = Column(
        children: [
          Text('ابدا بالبحث اولا',
              style: TextStyle(
                fontFamily: 'exar',
              ))
        ],
      );
    }
  }

  Future<void> senddata() async {
    setState(() {
      showProgress = true;
    });
    var body;
    int id = 0;

    try {
      var data = {'api_key': 'fYqUL6SU6bMJ_K4z9Nbb1TACyz1GZ7jbPgG',
        'id': product.id,
        'name': namecontroller.text,
        'dentistid': accountid,
        'status': productstatus,
        'phone': phonecontroller.text,
        'price': pricecontroller.text,
        'description': descriptioncontroller.text,
        'city': _selectedcities.id,
      };
      var response = await CallApi().postData(data, 'edit/product');
      print('responeffdfdfproduct ' + response.body.toString());

      body = json.decode(utf8.decode(response.bodyBytes));
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
    if (body.toString() == "") {
      print('respone ssssssssssss ');

      showfaildialog(context);
    } else {
      if (body['success'] == true) {
        setState(() {
          id = body['id'] ?? "0";
        });
        if (isfile) {
          print('imageFile :  ' + imageFile.path);

          Map<String, String> iddata = {
            'id': id.toString()};

          var response2 = await CallApi().addImageproduct(
              iddata, imageFile.path);
          print('response2 prductimageFile :  ' + response2.toString());

        }
        showsuccessdialog();
      }
    }

  }

}

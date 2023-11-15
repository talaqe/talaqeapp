import 'dart:async';
import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/toothes.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/addtooth.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_gaps.dart';
import 'package:talaqe/utils/constants/app_images.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';


import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../fail.dart';
import '../CallApi.dart';

  class AddstatusScrean extends StatefulWidget {
  const AddstatusScrean({super.key});


  @override
  State<StatefulWidget> createState() {
  // TODO: implement createState
  return _Addstatus();
  }

  }


  class _Addstatus extends State<AddstatusScrean> {
    List<dynamic> data=[];
    bool showProgress = false;
    bool showProgress1 = false;
    List<Widget> list = [];
    List<City> _cities=[] ;
    int patientid=0;
    String namepatient="";
    Column listColums=const Column();
    // Account account= null;
    Patient _selectedpetient=Patient(0, "اختر مريض", "", "", "", "", "", "", "", "", "");
    List<Patient> _patientlist =[];
    final List<Typetreatment> _typetreamtlist =[];
    Typetreatment _selecttypetreatment=Typetreatment(0,"اختر نوع العلاج","");
    int accountid=0;
    final City _selectedcities=City(0, "المدينة");
    int offset=0;
    bool selectpatientstatus=false;
    List<Widget> wlist=[];
    String toothss="0";
    List<TextEditingController>   notess =[TextEditingController()];
    TextEditingController searchcontroller=TextEditingController();
    List<DropdownMenuItem<City>> citiesItems = [
   ];
    City city=City(0, "اختر مدينة");
    Container Tooths=Container();

    List<Tooth> selecttooth=[];
    String gendervalue='اختر جنس';
    List<String> placetoothlist=[
      'up',
      'down'
      ];
    List<String> toothlist=[
      'L1',
      'L2',
      'L3',
      'L4',
      'L5',
      'L6',
      'L7',
      'L8',

      'R1',
      'R2',
      'R3',
      'R4',
      'R5',
      'R6',
      'R7',
      'R8',

    ];
    ScrollController scrollController = ScrollController();

    TextEditingController  notes=TextEditingController();
    TextEditingController  numbertooth=TextEditingController();
   List <String> toothplace=[];
    String namearea="";
    String toothshowtext="عدداسنان الحالة";
   String  options="general";
  final _formKeyy = GlobalKey<FormState>();
    List<String> english = [ "لاتوجد تفاصيل",'1', '2', '3', '4', '5', '6', '7', '8', '9'];

    @override
  void initState() {
    // TODO: implement initState
      _cities = [city];
      getdata();
      list=[];
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
          screenContext: context, titleWidget: const Text(' اضافة حالة')),
      body: CustomScaffoldBodyWidget(
          child: SingleChildScrollView(
              child:  showProgress?   Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(top: 100),
                child: const Center(child:  CircularProgressIndicator(

                  valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                  ,)
                ),
              )
                  : Form(
                key: _formKeyy,
                    child: Column(
                children: [
                  AppGaps.hGap60,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height: 50,
                          // margin:EdgeInsets.only(right:20),
                          // width: screenWidth- 15,
                          child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0, backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.person,
                                    color: Color(0xFF464545)),
                                const SizedBox(height:2),
                                Row(
                                  children: [
                                    Text(_selectedpetient.name,
                                      style: const TextStyle( fontFamily: 'exar',fontSize: 14, color: Color(0xFF464545)),),
                                    const SizedBox(width: 10,),


                                  ],
                                )

                              ],
                            ),


                            onPressed: (){
                              Navigator.pushNamed(context, AppPageNames.searchPersontScreen);
                              // showModalBottomSheet(
                              //   context: context,
                              //     isScrollControlled:true,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.vertical(
                              //             top: Radius.circular(20)
                              //         )
                              //     ),
                              //   builder: (context) {
                              //     return StatefulBuilder(
                              //         builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {
                              //           return  ;
                              //         });
                              //   });


                            },
                          )

                      ),
                      SizedBox(
                          height: 50,
                          // margin:EdgeInsets.only(right:20),
                          // width: screenWidth/2- 15,
                          child:  ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0, backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.add,
                                color: Color(0xFF464545)),
                                SizedBox(height:2),
                                Text("اضف مريض جديد",

                                  style: TextStyle(fontSize: 14,
                                      fontFamily: 'exar',
                                      color: Color(0xFF464545)),)],
                            ),


                            onPressed: (){
                              Navigator.pushNamed(context, AppPageNames.addPatientScreen);


                            },
                          )

                      ),
                    ],
                  ),
                    AppGaps.hGap20,
                  Container(
                    alignment: Alignment.centerRight,
                    width: screenWidth-50,
                    child: const Text('اختر نوع الحالة',
                      style: TextStyle(
                        fontFamily: 'exar',
                      ),),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width:screenWidth/2-50 ,
                          child:    Row(
                            children: [   Radio(
                                value: "general",
                                groupValue: options,
                                onChanged: (value){
                                  setState(() {
                                    options = value.toString();
                                  });
                                }),
                              const Text("عامة",
                                  style:TextStyle(
                                    fontFamily: 'exar',
                                  )),
                            ],
                          )
                      ),
                      SizedBox(
                          width:screenWidth/2-50 ,
                          child:          Row(
                            children: [   Radio(
                                value: "special",
                                groupValue: options,
                                onChanged: (value){
                                  setState(() {
                                    options = value.toString();
                                  });
                                }),
                              const Text(" خاصة",
                                  style:TextStyle(
                                    fontFamily: 'exar',
                                  )),
                            ],
                          )),
                    ],
                  ),
                  AppGaps.hGap20,
                  CustomTextFormField(
                      isReadOnly: true,
                      labelPrefixIcon: SvgPicture.asset(
                        AppAssetImages.medalBadgeIconSVG,
                        color: AppColors.secondaryFontColor,
                        width: 12,
                      ),
                      labelText: 'نوع العلاج',
                      hintText:_selecttypetreatment.name,
                      suffixIcon: SizedBox(
                        height: 28,
                        child: PopupMenuButton<int>(
                          padding: EdgeInsets.zero,
                          position: PopupMenuPosition.under,
                          itemBuilder: (context) {
                            return gettreatmentlist();
                          },
                          icon: SvgPicture.asset(AppAssetImages.arrowDownIconSVG,
                              color: AppColors.secondaryFontColor, width: 12),
                        ),
                      )),

                  AppGaps.hGap20,
                  /* <----- Email text field -----> */
                    CustomTextFormField(
                      controller: notes,
                      labelPrefixIcon: SvgPicture.asset(
                          AppAssetImages.cardIconSVG,
                          color: AppColors.secondaryFontColor),
                      labelText: 'تفاصيل الحالة',
                      hintText: 'ادخل التفاصيل',
                    ),
                  AppGaps.hGap20,
                  CustomTextFormField(
                      isReadOnly: true,
                      labelPrefixIcon: SvgPicture.asset(
                        AppAssetImages.medalBadgeIconSVG,
                        color: AppColors.secondaryFontColor,
                        width: 12,
                      ),
                      labelText: ' عدد الاسنان ',
                      hintText:toothshowtext,
                      suffixIcon: SizedBox(
                        height: 28,
                        child: PopupMenuButton<int>(
                          padding: EdgeInsets.zero,
                          position: PopupMenuPosition.under,
                          itemBuilder: (context) {
                            return gettreatmentlist();
                          },
                          icon: SvgPicture.asset(AppAssetImages.arrowDownIconSVG,
                              color: AppColors.secondaryFontColor, width: 12),
                        ),
                      )),


                  AppGaps.hGap20,

                  CustomStretchedTextButtonWidget(
                      onTap: () {

                        if(_selectedpetient.id==0 || numbertooth.text=='' || _selecttypetreatment.id==0){
                          showdialog(context);
                        }else{
                          if(numbertooth.text=="لاتوجد تفاصيل"){
                            numbertooth.text="0";
                          }
                          senddata();
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
                                child: Text(
                                  'فشل تعديل البيانات الرجاء المحاولة مرة ثانية',
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
                          child: const Align(
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
    Widget getarealist() {
      List<Widget> list = [];
      for (var element in _cities) {
        print('ffff${element.name}');
        list.add( ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Row(
            children: [
             
              Text(element.name),
            ],
          ),

          onPressed: () async {setState(() {
            _selectedcities.id=element.id;
            _selectedcities.name=element.name;


          });
          SharedPreferences shpref= await SharedPreferences.getInstance();
          shpref.setInt('citiesss', _selectedcities.id);

          Navigator.of(context).pop();

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
    String replaceFarsiNumber(String input) {
      const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const farsi = ['۰', '١', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

      for (int i = 0; i < english.length; i++) {
        input = input.replaceAll(farsi[i], english[i]);
      }
       print("ddddfgg$input");
      return input;
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
                              child: Text('تم ارسال الرسالة بنجاح',
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


    void showsearch(BuildContext context) {


      var screenWidth = MediaQuery
          .of(context)
          .size
          .width;
      var screenHeight = MediaQuery
          .of(context)
          .size
          .height;
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
                  color: Colors.white,
                  height: screenHeight/2,
                  child: SingleChildScrollView(
                      controller: scrollController,

                      child: Column(

                        children: [
                          const SizedBox(height: 10,),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left:3.0,right: 5),
                                child: Container(
                                    width: screenWidth-50,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color:const Color(0xFF9267DD),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: ElevatedButton(
                                      style:  ElevatedButton.styleFrom(
                                          elevation: 0, backgroundColor: const Color(0xFF9267DD),
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.0),
                                          )
                                      ),
                                      onPressed: (){
                                        showModalBottomSheet(context: context,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20)
                                                )
                                            ),
                                            builder: (context){
                                              return   getarealist();
                                            });
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.account_balance_rounded,
                                            color: Colors.white,),
                                          Text(_selectedcities.name,style: const TextStyle(
                                              color: Colors.white, fontFamily: 'exar',
                                              fontSize: 12
                                          ),)
                                        ],
                                      ),
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal:5.0),
                                child: Row(
                                  children: [
                                    Container(height: 53,
                                        width: screenWidth-150,
                                        decoration: const BoxDecoration(
                                          color:Color(0xFF9267DD),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                        child: TextField(
                                          style: const TextStyle(
                                              color: Colors.white
                                          ),
                                          controller: searchcontroller,
                                          decoration: const InputDecoration(
                                              labelStyle: TextStyle(
                                                  color: Colors.white
                                              ),
                                              hintStyle:  TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'exar',
                                              ),
                                              border: InputBorder.none,

                                              hintText:' ابحث عن اسم المريض او رقمه'
                                          ),
                                        )
                                    ),
                                    Container(height: 53,
                                      decoration: const BoxDecoration(
                                        color:Color(0xFF9267DD),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          bottomLeft: Radius.circular(12),
                                        ), ),
                                      child: IconButton(onPressed: (){
                                        offset=0;
                                        search(searchcontroller.text);
                                      }, icon: const Icon(Icons.search,
                                        color: Colors.white,),
                                        padding: EdgeInsets.zero,),
                                    )
                                  ],

                                ),
                              ),
                            ],
                          ),
                          showProgress1?   Container(
                            alignment: Alignment.bottomCenter,
                            margin: const EdgeInsets.only(top: 100),
                            child: const Center(child:  CircularProgressIndicator(

                              valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                              ,)
                            ),
                          )
                              :
                          Column(
                            children: list,
                          )
                        ],
                      )),
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
                                child: Text('تمت العملية بنجاح',
                                style:TextStyle( fontFamily: 'exar',)),
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
                          child: const Align(
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

    List<PopupMenuItem<int>> gettoothlist() {
      List<PopupMenuItem<int>> list = [];
      for (var element in english) {
        list.add(
          PopupMenuItem<int>(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Row(
                children: [
                 
                  Text(element,style:const TextStyle( fontFamily: 'exar',)),
                ],
              ),

              onPressed: () {
                setState(() {
                  numbertooth.text=element;
                  toothshowtext=element;

                });
                Navigator.pop(context);
              },

            ),
          ),);

      }
      return list;

    }

    List<PopupMenuItem<int>> gettreatmentlist() {
      List<PopupMenuItem<int>> list = [];
      for (var element in _typetreamtlist) {
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
                  _selecttypetreatment=element;

                });
                Navigator.pop(context);
              },

            ),
          ),);

      }
      return list;

    }

     getpatientlist() {
      var screanwidth=MediaQuery.of(context).size.width;
      var screanheight=MediaQuery.of(context).size.height;
      print('ffffffffffffffffffffffff${list.length}');



    }
    Future<void> getdata() async {
      SharedPreferences prefsssss = await SharedPreferences.getInstance();

      var response=await CallApi().getallData('alldata');
      // var body=json.decode(response.body);
      var datastring = utf8.decode(response.bodyBytes);
      // print('respone alldata  '+datastring.toString());
      if (datastring != "") {
        data = json.decode(datastring);
        String patientid=prefsssss.getString('patientiidd') ?? "0";
        String patientname=prefsssss.getString('patientiiddname') ?? "";
        print("patientidddddd$patientid");
        int Citees=prefsssss.getInt('citiesss')??0;

        setState(() {
          accountid = prefsssss.getInt('accountid') ?? 0;
          if(patientid!="0"){
            _selectedpetient.id=int.parse(patientid);
            _selectedpetient.name=patientname;
            selectpatientstatus=true;
          }
        });

        print("account id$accountid");
        Map datatype = data[0];

        if(selectpatientstatus==true){
          prefsssss.setString("patientiidd", "");
        }
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

          List<dynamic> typetreatments = datatype['Typetreatment'];
          // print('respone areas  ' + data['areas'].toString());

          setState(() {
            for (var element in typetreatments) {
              print("add to areas $element");

              _typetreamtlist.add(
                  Typetreatment(element['id'], element['name'] ?? "",
                      element['image'] ?? ""));
            }
          });
          list=[];
          listColums=const Column(
            children: [
              Text('ابدا بالبحث اولا',
              style:TextStyle(
                fontFamily: 'exar',
              ))
            ],
          );



      }

    }

    Future<void> senddata() async {
      setState((){
        showProgress=true;
      });
     var body;
     int id=0;

      try{
        var data={'api_key': 'fYqUL6SU6bMJ_K4z9Nbb1TACyz1GZ7jbPgG',
          'patientid':_selectedpetient.id,
          'dentistid':accountid,
          'type':options,
          'dentist':accountid,
          'typetreatment':_selecttypetreatment.id,
          'notes':notes.text,
          'city':city.id,
           };
        var response=await CallApi().postData(data,'add/status');
        print('responeffdfdf ${response.body}');

        body = json.decode(utf8.decode(response.bodyBytes));
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
      if(body.toString()==""){
        print('respone ssssssssssss ');

        showfaildialog(context);
      }else {



        if (body['success'] ==true) {
          setState(() {

            id = body['id'] ??"0";
          });



          SharedPreferences prefsssss = await SharedPreferences.getInstance();
          prefsssss.setString("patientiidd", _selectedpetient.id.toString());
          if(numbertooth.text=="0"){

            var response=await CallApi().getallData('alldata');
            prefsssss.setString('data', utf8.decode(response.bodyBytes).toString());
            showsuccessdialog();
            setState(() {
              showProgress = false;

            });
          } if(numbertooth.text!="0") {
            setState(() {
              showProgress = false;

            });
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    Addtooth(
                        statusid: id, statusnumtooth: int.parse(numbertooth.text))));
          }
        } else {
          showfaildialog(context);
        }

      }
    }

  Future<void> search(String searchtext) async {
      // String search=searchcontroller.text;
       setState((){
         showProgress1=true;
       });
       print('respone offset:  $offset');

       var response1=await CallApi().getallData('getsearchdata/'+searchtext+"/"+_selectedcities.id.toString()+"/"+offset.toString());
       print('respone getsearchdata:  ${response1.body}');

       var body1=json.decode(response1.body);
       //_patientlist
       if (body1['success'] == true) {
         setState(() {

           _patientlist=[];
           List<dynamic> patientsarray=body1["patientsarray"];
           for (var element in patientsarray) {
             _patientlist.add(
                 Patient(
                   element['id'],
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

           }
         });

       }
      setState((){

        list=[];
       listColums=const Column();
       if(search!="") {
         if (offset > 0) {
           list.add(Container(
             decoration: const BoxDecoration(
                 border: Border(
                     bottom: BorderSide(width: 2,
                         color: Colors.grey)
                 )

             ),
             child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                 foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
                 shadowColor: Colors.transparent,
               ),
               child: const Row(
                 mainAxisAlignment: MainAxisAlignment
                     .spaceBetween,
                 children: [
                   Text("السابق",
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: Colors.black,
                       fontFamily: 'exar',
                     ),),
                   Icon(Icons.arrow_upward_rounded, color: Colors.black,),

                 ],
               ),
               onPressed: () {
                 scrollController.animateTo( //go to top of scroll
                     0, //scroll offset to go
                     duration: const Duration(milliseconds: 500), //duration of scroll
                     curve: Curves.fastOutSlowIn //scroll type
                 );
                 setState(() {
                   offset = offset - 10;
                   search(searchtext);
                 });
               },


             ),


           )
           );
         }
         for (var element in _patientlist) {
           list.add(Container(
             decoration: const BoxDecoration(
                 border: Border(
                     bottom: BorderSide(width: 2,
                         color: Colors.grey)
                 )

             ),
             child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                 foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
                 shadowColor: Colors.transparent,
               ),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(element.name,
                       style: const TextStyle(fontFamily: 'exar',)),

                 ],
               ),

               onPressed: () {
                 setState(() {
                   _selectedpetient = element;
                 });
                 Navigator.pop(context);
               },

             ),
           ),);
         }
         if (list.isNotEmpty) {
           list.add(Container(
             decoration: const BoxDecoration(
                 border: Border(
                     bottom: BorderSide(width: 2,
                         color: Colors.grey)
                 )

             ),
             child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                 foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
                 shadowColor: Colors.transparent,
               ),
               child: const Row(
                 mainAxisAlignment: MainAxisAlignment
                     .spaceBetween,
                 children: [
                   Text("المزيد",
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: Colors.black,
                       fontFamily: 'exar',
                     ),),
                   Icon(Icons.arrow_downward_rounded, color: Colors.black,),

                 ],
               ),
               onPressed: () {
                 scrollController.animateTo( //go to top of scroll
                     0, //scroll offset to go
                     duration: const Duration(milliseconds: 500), //duration of scroll
                     curve: Curves.fastOutSlowIn //scroll type
                 );
                 setState(() {
                   offset = offset + 10;
                   search(searchtext);
                 });
               },


             ),


           )
           );
         }
       }
       if(list.isEmpty){
         if(offset>0){
           list.add(Container(
             decoration: const BoxDecoration(
                 border: Border(
                     bottom: BorderSide(width: 2,
                         color: Colors.grey)
                 )

             ),
             child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                 foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
                 shadowColor: Colors.transparent,
               ),
               child: const Row(
                 mainAxisAlignment: MainAxisAlignment
                     .spaceBetween,
                 children: [
                   Text("السابق",
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       color: Colors.black,
                       fontFamily: 'exar',
                     ),),
                   Icon(Icons.arrow_upward_rounded, color: Colors.black,),

                 ],
               ),
               onPressed: () {
                 scrollController.animateTo( //go to top of scroll
                     0, //scroll offset to go
                     duration: const Duration(milliseconds: 500), //duration of scroll
                     curve: Curves.fastOutSlowIn //scroll type
                 );
                 setState(() {
                   offset = offset - 10;
                   search(searchtext);
                 });
               },


             ),


           )
           );
         }
         else{
           list.add( Container(
             margin: const EdgeInsets.only(top: 20),
             alignment: Alignment.topCenter,
             child: const Text('لا تتوفر نتائج',
               style: TextStyle(
                 fontFamily: 'exar',
               ),),
           ));
         }
       }
        showProgress1=false;
        offset=offset+10;
      });

    }

  void endsearch() {
    String search=searchcontroller.text;


    setState((){
      list=[];
      showProgress1=false;
      searchcontroller.text="";
      listColums=const Column();

    });
  }


  }



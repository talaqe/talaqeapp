import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/toothes.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/add_patient_screan.dart';
import 'package:talaqe/interfaces/addstatus_screan.dart';
import 'package:talaqe/interfaces/index.dart';
import 'package:talaqe/main.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';

import '../navDrawer.dart';
import 'package:talaqe/data/account.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../fail.dart';
import '../CallApi.dart';

class Addtooth extends StatefulWidget {
int statusid;
int statusnumtooth;
Addtooth({super.key, this.statusid=0,this.statusnumtooth=0});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Addtooth();
  }

}


class _Addtooth extends State<Addtooth> {
  List<dynamic> data=[];
  int _statusid=0;
  int _statusnumbertooth=0;
  bool showProgress = false;
  // Account account= null;
  final Patient _selectedpetient=Patient(0, "اختر مريض", "", "", "", "", "", "", "", "", "");
  final List<Patient> _patientlist =[];
  final List<Typetreatment> _typetreamtlist =[];
  final Typetreatment _typetreatment=Typetreatment(0, "", "");
  final Typetreatment _selecttypetreatment=Typetreatment(0,"اختر نوع العلاج","");
  int accountid=0;
  int numbertooth=0;
  List<Widget> wlist=[];
  List<TextEditingController>   notess =[];

  List<DropdownMenuItem<City>> citiesItems = [
  ];
  City city=City(0, "اختر مدينة");
  Container Tooths=Container();
  List<City> citees=[] ;

  List<Tooth> selecttooth=[];
  String gendervalue='اختر جنس';
  List<String> placetoothlist=[
    'upper',
    'lower'
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
  TextEditingController  notes=TextEditingController();
  List <String> toothplace=[];
  String namearea="";
  String  options="general";
  final _formKeyy = GlobalKey<FormState>();
  Status status=Status(0, "", "", "", "", "", "", "", "", "", "");
  Patient patient=Patient(0, "", "", "", "", "", "", "", "", "", "");
  @override
  void initState() {
    // TODO: implement initState

    _statusid=widget.statusid;
    _statusnumbertooth=widget.statusnumtooth;
    getdata();
    print("idddd$_statusid");

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

    return  MaterialApp(
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: const Locale('ar', 'AE'),
      home: Scaffold(
        drawer: const NavDrawer(),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // backgroundColor: AppColors.primaryColor,
          backgroundColor:Colors.transparent ,
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color(0xFFFFFFFF), //change your color here
          ),
          title: const Row(
            children: <Widget>[
              Text("اضف اسنان للحالة",style: TextStyle(  color: Color(0xFFFFFFFF),
                fontFamily: 'exar',),),
              SizedBox(width: 10.0,),
//0xFF591DC1
            ],
          ),

          //Text(widget.title)
        ),
        body: Stack(
            children: [
              Container(
                width: screenWidth,
                height: 120,
                margin: const EdgeInsets.only(right: 0,left: 0,top: 0,bottom: 5),
                padding: const EdgeInsets.only(top: 50,right:50,left: 50 ),
                color: AppColors.primaryColor,


              ),

              Container(

                margin: const EdgeInsets.only(top: 90,bottom: 0,left:0 ,right: 0),
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child:   showProgress?   Container(
                    alignment: Alignment.bottomCenter,
                    margin: const EdgeInsets.only(top: 100),
                    child: const Center(child:  CircularProgressIndicator(

                      valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                      ,)
                    ),
                  )
                      : Container(

                    margin: const EdgeInsets.only(top: 20.0,left: 0.0,right: 0.0,bottom: 0.0),

                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKeyy,
                        child: Column(
                            children:<Widget> [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      // margin:EdgeInsets.only(right:20),
                                      // width: screenWidth- 15,
                                      child:   Row(
                                        children: [
                                          const Icon(Icons.person,
                                              color: Color(0xff0000000)),
                                          const SizedBox(height:2),
                                          Text(" المريض: ${patient.name}",
                                            style: const TextStyle(fontSize: 10,
                                                fontFamily: 'exar',
                                                color: Color(0xFF000000)),)],
                                      ),

                                    ),
                                    SizedBox(
                                      height: 50,
                                      // margin:EdgeInsets.only(right:20),
                                      // width: screenWidth/2- 15,
                                      child:   Row(
                                        children: [
                                          const Icon(Icons.list_alt_outlined,
                                              color: Color(0xff0000000)),
                                          const SizedBox(height:2),
                                          Text("نوع العلاج : ${_typetreatment.name}",
                                            style: const TextStyle(fontSize: 10,
                                                fontFamily: 'exar',
                                                color: Color(0xFF000000)),)],
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20.0,),
                              Container(
                                alignment: Alignment.center,
                                width: screenWidth-50,
                                child: const Text('معلومات الاسنان : ',
                                style:TextStyle(
                                  fontFamily: 'exar',
                                )),
                              ),
                              const SizedBox(height: 20,),

                              gettoothlistwidget(),


                              const SizedBox(height: 20.0,),
                              ElevatedButton(
                                onPressed: () {

                                  senddata();

                                },
                                style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 10.0), backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0))),
                                child: const Text(
                                  "حفظ",
                                  style: TextStyle(color: Colors.white,
                                      fontFamily: 'exar',fontSize: 15),
                                ),
                              ),
                              const SizedBox(height: 5,),

                            ]
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ]
        ),

      ),
    );
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
                              style:TextStyle(
                                fontFamily: 'exar',
                              )),
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
                                    fontFamily: 'exar',
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
                              style:TextStyle(
                                fontFamily: 'exar',
                              )),
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
                            onTap: () async {
                              SharedPreferences prefsssss = await SharedPreferences.getInstance();

                              var response=await CallApi().getallData('alldata');
                              prefsssss.setString('data', utf8.decode(response.bodyBytes).toString());

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


  Future<void> getdata() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();

    var response=await CallApi().getallData('alldata');
    // var body=json.decode(response.body);
    var datastring = utf8.decode(response.bodyBytes);
    // print('respone alldata  '+datastring.toString());
    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
      });
      print("account id$accountid");
      Map datatype = data[0];
  
      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in cities) {
          print("add to areas $element");

          citees.add(
              City(
                  element['id'],element['name']
              )
          );


        }



      List<dynamic> statuseslist = datatype['Status'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in statuseslist) {
          print("add to areas $element");

          if (element["id"] == _statusid) {
            status.id= element['id'];
            status.dentistid=     element['dentistid'] ?? "";
            status.patientid=   element['patientid'] ?? "";
            status.type=   element['type'] ?? "";
            status.typetreatment=   element['typetreatment'] ?? "";
            status.treatment=   element['treatment'] ?? "";
            status.datetreatment=   element['datetreatment'] ?? "";
            status.status=   element['status'] ?? "";
            status.notes=  element['notes'] ?? "";
            status.created_at=  element['created_at'] ?? "";
            status.updated_at=  element['updated_at'] ?? "";

          }

        }
       
      });
        List<dynamic> typetreatments = datatype['Typetreatment'];
        // print('respone areas  ' + data['areas'].toString());

        setState(() {
          for (var element in typetreatments) {
            print("add to areas $element");
            if(element['id']==int.parse(status.typetreatment)){
              _typetreatment.id=element['id'];
              _typetreatment.name=element['name'];
              _typetreatment.image=element['image'];
            }
            _typetreamtlist.add(
                Typetreatment(element['id'], element['name'] ?? "",
                    element['image'] ?? ""));
          }
        });
      });
      List<dynamic> patientlist = datatype['Patient'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {

        for (var element in patientlist) {
          print("add to patient $element");
          if (element["id"] == int.parse(status.patientid)) {
            print("add to patient $element");

            patient.id =  element['id'];
            patient.name=    element['name'] ?? "";
            patient.age=    element['age'] ?? "";
            patient.gender= element['gender'] ?? "";
            patient.city= element['city'] ?? "";
            patient.location= element['location'] ?? "";
            patient.other=  element['other'] ?? "";
            patient.created_at=   element['created_at'] ?? "";
            patient.identifynumber=   element['identifynumber'] ?? "";
            patient.phone=   element['phone'] ?? "";
            patient.email=   element['email'] ?? "";


          }
        }
      });
      // print("statuseslist"+_laststatus.length.toString());

    }

  }

  Future<void> senddata() async {
    var body;
    setState((){
      showProgress=true;
    });
    try{
      List listtooth=[];
      for(int i=0;i<_statusnumbertooth;i++){
        listtooth.add({
          'type':_typetreatment.id,
          'tothplace':selecttooth[i].tothplace,
          'toothnumber':selecttooth[i].toothnumber,
          'notes':notess[i].text,
        });
      }
      var data={'api_key': 'fYqUL6SU6bMJ_K4z9Nbb1TACyz1GZ7jbPgG',
        'patientid':patient.id,
        'numbertooth':_statusnumbertooth,
        'statusid':_statusid,
         'listtooth':listtooth,
      };
      var response=await CallApi().postData(data,'add/tooth');
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


      int id;
      if (body['success'] ==true) {


        setState(() {
          showProgress = false;

        });
        showsuccessdialog();


      } else {
        showfaildialog(context);
      }

    }
  }


  Widget gettoothplacelist(int i) {
    List<Widget> list = [];
    for (var element in placetoothlist) {
      print('ffff$element');
      list.add( ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          children: [
           
            Text(element,
            style:const TextStyle(
              fontFamily: 'exar',
            )),
          ],
        ),

        onPressed: (){setState(() {
          selecttooth[i].tothplace=element;

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
  Widget gettoothlist(int i) {
    List<Widget> list = [];

    for (var element in toothlist) {
      print('ffff$element');
      list.add( ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          children: [
           
            Text(element,
            style:const TextStyle(
              fontFamily: 'exar',
            )),
          ],
        ),

        onPressed: (){setState(() {
          selecttooth[i].toothnumber=element;

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

  gettoothlistwidget() {
    List<Widget> list=[];
    print('numbertooth$_statusnumbertooth');
    for(int i=0;i<_statusnumbertooth;i++){
      selecttooth.add(Tooth(0,"0","0","",'upper','L1',"",""));
      notess.add(TextEditingController());
      list.add(Container(
        width: MediaQuery
            .of(context)
            .size
            .width - 50,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 10, right: 15, left: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), //color of shadow
              spreadRadius: 2, //spread radius
              blurRadius: 5, // blur radius
              offset: const Offset(0, 2), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.centerRight,

                      margin: const EdgeInsets.only(right: 5),
                      child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF9267DD),
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Image.asset("asset/tooth.jpg",
                                  width: 50,)
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: Column(

                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,

                                    children: [
                                      Container(
                                        child: const Text("مكان السن: ",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontFamily: 'exar',
                                          ),),
                                      ),
                                      //selectplace
                                      Container(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0, backgroundColor: Colors.transparent,
                                                shadowColor: Colors.transparent
                                            ),
                                            child: Text(
                                              selecttooth[i].tothplace,
                                              style: const TextStyle(fontSize: 10,
                                                  fontFamily: 'exar',
                                                  color: Color(0xFF000000)),),


                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .vertical(
                                                          top: Radius.circular(
                                                              20)
                                                      )
                                                  ),
                                                  builder: (context) {
                                                    return gettoothplacelist(i);
                                                  });

                                            },
                                          )
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [ const Text("  رقم السن: ",
                                      style: TextStyle(
                                        fontFamily: 'exar',
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0, backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent
                                        ),
                                        child: Text(selecttooth[i].toothnumber,
                                          style: const TextStyle(fontSize: 10,
                                              fontFamily: 'exar',
                                              color: Color(0xFF000000)),),


                                        onPressed: () {
                                          showModalBottomSheet(context: context,
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .vertical(
                                                      top: Radius.circular(20)
                                                  )
                                              ),
                                              builder: (context) {
                                                return gettoothlist(i);
                                              });

                                        },
                                      )
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ]
                      )
                  ),


                ],
              ),
            ),

            Container(

              child: Column(
                children: [
                  Container(

                    alignment: Alignment.centerRight,

                    child: const Text(" ملاحظات ",
                      style: TextStyle(
                        fontFamily: 'exar',
                        color: Color(0xff0000000),
                      ),
                    ),

                  ),
                  Container(

                    alignment: Alignment.center,

                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      minLines: 1,
                      maxLines: 5,
                      controller: notess[i],
                      textAlign: TextAlign.right,

                      decoration: const InputDecoration(
                        filled: true,
                        focusColor: Color(0xFF000000),
                        hoverColor: Color(0xFF000000),
                        fillColor: Color(0x00ffffff),
                        hintStyle: TextStyle( fontFamily: 'exar',
                            fontSize: 15.0, color: Color(0xFF000000)),

                        border: UnderlineInputBorder(),
                        hintText: "ملاحظات",
                      ),
                      onEditingComplete: () {
                        selecttooth[i].notes = notess[i].text;
                      },
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      ));
    }
    print("Dddh${list.length}");
       return Container(
          child: Column(
            children:  list,
          ),
        );


  }


}



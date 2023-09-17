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
Addtooth({this.statusid=0,this.statusnumtooth=0});
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
  Patient _selectedpetient=new Patient(0, "اختر مريض", "", "", "", "", "", "", "", "", "");
  List<Patient> _patientlist =[];
  List<Typetreatment> _typetreamtlist =[];
  Typetreatment _typetreatment=new Typetreatment(0, "", "");
  Typetreatment _selecttypetreatment=Typetreatment(0,"اختر نوع العلاج","");
  int accountid=0;
  int numbertooth=0;
  List<Widget> wlist=[];
  List<TextEditingController>   notess =[];

  List<DropdownMenuItem<City>> citiesItems = [
  ];
  City city=new City(0, "اختر مدينة");
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
  TextEditingController  notes=new TextEditingController();
  List <String> toothplace=[];
  String namearea="";
  String  options="general";
  final _formKeyy = GlobalKey<FormState>();
  Status status=Status(0, "", "", "", "", "", "", "", "", "", "");
  Patient patient=new Patient(0, "", "", "", "", "", "", "", "", "", "");
  @override
  void initState() {
    // TODO: implement initState

    this._statusid=widget.statusid;
    this._statusnumbertooth=widget.statusnumtooth;
    getdata();
    print("idddd"+_statusid.toString());

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
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ar', 'AE'), // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      locale: Locale('ar', 'AE'),
      home: Scaffold(
        drawer: NavDrawer(),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // backgroundColor: AppColors.primaryColor,
          backgroundColor:Colors.transparent ,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Color(0xFFFFFFFF), //change your color here
          ),
          title: Row(
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
                margin: EdgeInsets.only(right: 0,left: 0,top: 0,bottom: 5),
                padding: EdgeInsets.only(top: 50,right:50,left: 50 ),
                color: AppColors.primaryColor,


              ),

              Container(

                margin: EdgeInsets.only(top: 90,bottom: 0,left:0 ,right: 0),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                ),
                child: SingleChildScrollView(
                  child:   showProgress?   Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(top: 100),
                    child: Center(child:  CircularProgressIndicator(

                      valueColor:  new AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                      ,)
                    ),
                  )
                      : Container(

                    margin: EdgeInsets.only(top: 20.0,left: 0.0,right: 0.0,bottom: 0.0),

                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKeyy,
                        child: Column(
                            children:<Widget> [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 50,
                                      // margin:EdgeInsets.only(right:20),
                                      // width: screenWidth- 15,
                                      child:   Row(
                                        children: [
                                          Icon(Icons.person,
                                              color: Color(0xFF0000000)),
                                          SizedBox(height:2),
                                          Text(" المريض: "+patient.name,
                                            style: TextStyle(fontSize: 10,
                                                fontFamily: 'exar',
                                                color: Color(0xFF000000)),)],
                                      ),

                                    ),
                                    Container(
                                      height: 50,
                                      // margin:EdgeInsets.only(right:20),
                                      // width: screenWidth/2- 15,
                                      child:   Row(
                                        children: [
                                          Icon(Icons.list_alt_outlined,
                                              color: Color(0xFF0000000)),
                                          SizedBox(height:2),
                                          Text("نوع العلاج : "+_typetreatment.name,
                                            style: TextStyle(fontSize: 10,
                                                fontFamily: 'exar',
                                                color: Color(0xFF000000)),)],
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20.0,),
                              Container(
                                alignment: Alignment.center,
                                width: screenWidth-50,
                                child: Text('معلومات الاسنان : ',
                                style:TextStyle(
                                  fontFamily: 'exar',
                                )),
                              ),
                              SizedBox(height: 20,),

                              gettoothlistwidget(),


                              SizedBox(height: 20.0,),
                              ElevatedButton(
                                onPressed: () {

                                  senddata();

                                },
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 10.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0)),
                                    primary: AppColors.primaryColor),
                                child: Text(
                                  "حفظ",
                                  style: TextStyle(color: Colors.white,
                                      fontFamily: 'exar',fontSize: 15),
                                ),
                              ),
                              SizedBox(height: 5,),

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
      print("account id" + accountid.toString());
      Map datatype = data[0];
  
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


        });



      List<dynamic> statuseslist = datatype['Status'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        statuseslist.forEach((element) {
          print("add to areas " + element.toString());

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

        });
       
      });
        List<dynamic> typetreatments = datatype['Typetreatment'];
        // print('respone areas  ' + data['areas'].toString());

        setState(() {
          typetreatments.forEach((element) {
            print("add to areas " + element.toString());
            if(element['id']==int.parse(status.typetreatment)){
              _typetreatment.id=element['id'];
              _typetreatment.name=element['name'];
              _typetreatment.image=element['image'];
            }
            _typetreamtlist.add(
                Typetreatment(element['id'], element['name'] ?? "",
                    element['image'] ?? ""));
          });
        });
      });
      List<dynamic> patientlist = datatype['Patient'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {

        patientlist.forEach((element) {
          print("add to patient " + element.toString());
          if (element["id"] == int.parse(status.patientid)) {
            print("add to patient " + element.toString());

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
        });
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
      print('responeffdfdf '+response.body.toString());

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
    placetoothlist.forEach((element) {
      print('ffff'+element);
      list.add( ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          primary: Colors.transparent,
          onPrimary: Colors.black,
        ),
        child: Row(
          children: [
           
            Text(element,
            style:TextStyle(
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
    });
    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 20),
            child:  Column(
              children: list,
            )
        ));

  }
  Widget gettoothlist(int i) {
    List<Widget> list = [];

    toothlist.forEach((element) {
      print('ffff'+element);
      list.add( ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          primary: Colors.transparent,
          onPrimary: Colors.black,
        ),
        child: Row(
          children: [
           
            Text(element,
            style:TextStyle(
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
    });
    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 20),
            child:  Column(
              children: list,
            )
        ));

  }

  gettoothlistwidget() {
    List<Widget> list=[];
    print('numbertooth'+_statusnumbertooth.toString());
    for(int i=0;i<_statusnumbertooth;i++){
      selecttooth.add(new Tooth(0,"0","0","",'upper','L1',"",""));
      notess.add(new TextEditingController());
      list.add(Container(
        width: MediaQuery
            .of(context)
            .size
            .width - 50,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), //color of shadow
              spreadRadius: 2, //spread radius
              blurRadius: 5, // blur radius
              offset: Offset(0, 2), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      alignment: Alignment.centerRight,

                      margin: EdgeInsets.only(right: 5),
                      child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: Color(0xFF9267DD),
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Image.asset("asset/tooth.jpg",
                                  width: 50,)
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Column(

                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,

                                    children: [
                                      Container(
                                        child: Text("مكان السن: ",
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontFamily: 'exar',
                                          ),),
                                      ),
                                      //selectplace
                                      Container(
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                shadowColor: Colors.transparent,
                                                primary: Colors.transparent
                                            ),
                                            child: Text(
                                              selecttooth[i].tothplace,
                                              style: TextStyle(fontSize: 10,
                                                  fontFamily: 'exar',
                                                  color: Color(0xFF000000)),),


                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
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
                                    children: [ Text("  رقم السن: ",
                                      style: TextStyle(
                                        fontFamily: 'exar',
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            shadowColor: Colors.transparent,
                                            primary: Colors.transparent
                                        ),
                                        child: Text(selecttooth[i].toothnumber,
                                          style: TextStyle(fontSize: 10,
                                              fontFamily: 'exar',
                                              color: Color(0xFF000000)),),


                                        onPressed: () {
                                          showModalBottomSheet(context: context,
                                              shape: RoundedRectangleBorder(
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

                    child: Text(" ملاحظات ",
                      style: TextStyle(
                        fontFamily: 'exar',
                        color: Color(0xFF0000000),
                      ),
                    ),
                    alignment: Alignment.centerRight,

                  ),
                  Container(

                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      minLines: 1,
                      maxLines: 5,
                      controller: notess[i],
                      textAlign: TextAlign.right,

                      decoration: InputDecoration(
                        filled: true,
                        focusColor: Color(0xFF000000),
                        hoverColor: Color(0xFF000000),
                        fillColor: Color(0xFFFFFF),
                        hintStyle: TextStyle( fontFamily: 'exar',
                            fontSize: 15.0, color: Color(0xFF000000)),

                        border: UnderlineInputBorder(),
                        hintText: "ملاحظات",
                      ),
                      onEditingComplete: () {
                        selecttooth[i].notes = notess[i].text;
                      },
                    ),
                    alignment: Alignment.center,
                  ),

                ],
              ),
            ),

          ],
        ),
      ));
    }
    print("Dddh" + list.length.toString());
       return Container(
          child: Column(
            children:  list,
          ),
        );


  }


}



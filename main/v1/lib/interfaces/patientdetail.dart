import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/Gallorywork.dart';
import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/fail.dart';
import 'package:talaqe/interfaces/addimagetoprotiflio.dart';
import 'package:talaqe/interfaces/addtoprotifolio.dart';
import 'package:talaqe/interfaces/dataaccount.dart';

import 'package:talaqe/interfaces/images.dart';
import 'package:talaqe/interfaces/mynotifiy.dart';
import 'package:talaqe/interfaces/mystatus.dart';
import 'package:talaqe/interfaces/showprotifolio.dart';
import 'package:talaqe/interfaces/tooth.dart';
import 'package:talaqe/navDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/account.dart';
class PAtientdetail extends StatefulWidget{
  Patient patient;
  PAtientdetail({required this.patient});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PAtientdetail();

  }


}
class _PAtientdetail extends State<PAtientdetail> with SingleTickerProviderStateMixin{
  List<dynamic> data=[];
  List<City> _cities=[] ;
  bool showprogres=true;
  String linkcode="";
  String    gender="ذكر";
  City _selectedcities=City(0, "المدينة");
  String _url="https://talaqe.org/storage/app/public/";


  List<allStatus> _statuseslist =[];
  Patient patient=Patient(0, "", "", "", "", "", "", "", "", "", "");
  Account account =new Account(0,"","");
  Typetreatment _selecttype=Typetreatment(0, "", "");
  int counter = 0;
  TextEditingController searchcontroller = new TextEditingController();

  Container hometab =new Container();
  String searchword=" ";
  bool activesearch=false;
  bool progresss=true;
  @override
  void initState() {
    // TODO: implement initState
    patient=widget.patient;
    getData();

    super.initState();
  }
  Future<void> _refreshData() async {
    try {
      var response = await CallApi().getallData('alldata');
      // var body=json.decode(response.body);
      var body = json.decode(utf8.decode(response.bodyBytes));
      print('respone getallldatttasaallls  ' + response.body.toString());
      SharedPreferences shpref= await SharedPreferences.getInstance();
      shpref.setString('data', utf8.decode(response.bodyBytes).toString());
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
    getData();
  }


  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();

    String datastring = prefsssss.getString('data') ?? "";


    data = json.decode(datastring);

    Map datatype=data[0];




    List<dynamic> cities = datatype['City'];
    // print('respone areas  ' + data['areas'].toString());

    setState(() {
      cities.forEach((element) {

        print("add to areas " + element.toString());

        _cities.add(
            City(element['id'], element['name'] ?? ""));
        if(element['id']==int.parse(patient.city)){
          _selectedcities.id=element['id'];
          _selectedcities.name=element['name'] ;
        }
      });
    });
    var response = await CallApi().getallData('getlaststatus/'+patient.id.toString());
    // var body=json.decode(response.body);
    List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
    print('respone body  ' + response.body.toString());
    setState(() {
      body.forEach((element) {
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
                patient.name,
                patient.age,
                patient.gender,
                patient.city,
                patient.location,
                patient.other,
                patient.created_at,
                patient.identifynumber,
                patient.phone,
                patient.email,
                element['notesp'] ?? "") );
      });
    });

    setState(() {
      showprogres=false;
    });
    if(patient.gender=="f"){
      gender="انثى";
    }else{
      gender="ذكر";
    }
  }
  var items = [
    "الغاء الفلترة"
  ];
  @override
  Widget build(BuildContext context) {
    var screanwidth=MediaQuery.of(context).size.width;
    var screanheight=MediaQuery.of(context).size.height;
    return  Scaffold(


      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop() ,
        ),
        title:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        SizedBox(height:25),

                        SizedBox(width:10),
                       Container(
                         width: 5*screanwidth/6-120,
                         child:  Text(' ملف المريض',
                             style:TextStyle( fontFamily: 'exar',
                                 fontWeight: FontWeight.bold,
                                 color: Colors.white,
                                 fontSize: 17.0)),
                       ),

                      ]
                  ),
                ]
            )
        ),
        backgroundColor:Colors.transparent ,
        elevation: 0,
      ),
      backgroundColor:AppColors.primaryColor,

      body:Stack(

              children:[
    SizedBox(height: 10),
          Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(right: 0,left: 0,top: 100),
                      height: screanheight,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius:  BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),

                      ),
                      child:SingleChildScrollView(
                        child: Stack(
                          children: [
                            Container(

                              margin: EdgeInsets.only(top: 0),
                              alignment: Alignment.topCenter,
                              child: Text(" معلومات المريض",
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'exar',
                                    fontWeight: FontWeight.bold,
                                    color:AppColors.primaryColor
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.only(bottom: 10,right: 5,left: 5,top: 40),
                              decoration: BoxDecoration(
                                color: Color(0xFFE9DEF9),
                                borderRadius:  BorderRadius.all( Radius.circular(15)),
                                boxShadow:[
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
                                    margin: EdgeInsets.only(right: 0),
                                    child:         Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(

                                          child: Row(
                                            children: [
                                              Text("  العمر: " ,
                                                style: TextStyle( fontFamily: 'exar',
                                                  color: Color(0xFF000000),
                                                ),
                                              ),
                                              Text( patient.age,
                                                style: TextStyle( fontFamily: 'exar',
                                                  color:AppColors.primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // width: MediaQuery.of(context).size.width/2-60,
                                          alignment: Alignment.centerRight,
                                          margin: EdgeInsets.only(right: 5),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 5),
                                          // width: MediaQuery.of(context).size.width/2-60,
                                          child: Row(
                                            children: [
                                              Text("الجنس: ",
                                                style: TextStyle( fontFamily: 'exar',
                                                  color: Color(0xFF000000),
                                                ),),
                                              Text(gender,
                                                style: TextStyle( fontFamily: 'exar',
                                                  color:AppColors.primaryColor,
                                                ),),
                                            ],
                                          ),
                                          alignment: Alignment.centerLeft,
                                        ),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child:         Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(

                                          child:  Text(" المدينة: " ,
                                            style: TextStyle( fontFamily: 'exar',
                                              color: Color(0xFF000000),
                                            ),
                                          ),
                                          alignment: Alignment.centerRight,
                                          // width: MediaQuery.of(context).size.width/2-60,
                                          margin: EdgeInsets.only(right: 5),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(_selectedcities.name,
                                            style: TextStyle( fontFamily: 'exar',
                                              color:AppColors.primaryColor,
                                            ),),
                                          alignment: Alignment.centerLeft,
                                          // width: MediaQuery.of(context).size.width/2-60,
                                        ),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 5),
                                    child:         Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(

                                          child:  Text(" الموقع " ,
                                            style: TextStyle( fontFamily: 'exar',
                                              color: Color(0xFF000000),
                                            ),
                                          ),
                                          alignment: Alignment.centerRight,
                                          // width: MediaQuery.of(context).size.width/2-60,
                                          margin: EdgeInsets.only(right: 5),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(patient.location??"",
                                            style: TextStyle( fontFamily: 'exar',
                                              color:AppColors.primaryColor,
                                            ),),
                                          alignment: Alignment.centerLeft,
                                          // width: MediaQuery.of(context).size.width/2-60,
                                        ),

                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child:         Column(
                                      children: [
                                        Container(

                                          child:  Text(" مشاكل صحية اخرى " ,
                                            style: TextStyle( fontFamily: 'exar',
                                              color: Color(0xFF000000),
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width-50,
                                          margin: EdgeInsets.only(right: 5),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Text(patient.other??"",
                                            style: TextStyle( fontFamily: 'exar',
                                              color:AppColors.primaryColor,
                                            ),),
                                          alignment: Alignment.center,
                                          width: MediaQuery.of(context).size.width-100,
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(top: 200),
                              width: screanwidth,
                              height: 30,
                              alignment: Alignment.topCenter,
                              child: Text("  السجل الطبي السابق",
                                style: TextStyle(
                                    fontSize: 20, fontFamily: 'exar',
                                    fontWeight: FontWeight.bold,
                                    color:AppColors.primaryColor
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 250),
                                child:showprogres?   Container(
                                  child: Center(
                                      child:  CircularProgressIndicator(

                                        valueColor:  new AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                                        ,)

                                  ),
                                )
                                    : getstatuslist(screanheight))


                          ],
                        ),
                      ),

                    )

              ]
          )
      ,

    );
  }
  Widget getarealist() {
    List<Widget> list = [];
    _cities.forEach((element) {
      print('ffff'+element.name);
      list.add( ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: Colors.transparent,
          primary: Colors.transparent,
          onPrimary: Colors.black,
        ),
        child: Row(
          children: [
           
            Text(element.name,
            style:TextStyle(
              fontFamily: 'exar',
            )),
          ],
        ),

        onPressed: () async {setState(() {
          _selectedcities=element;

        });
        SharedPreferences prefsssss = await SharedPreferences.getInstance();
        prefsssss.setInt("_selectedcities", _selectedcities.id);
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

  Widget getstatuslist(double hight) {
    List<Widget> list =[];
    String stattelast="";
    String typelast="";
    setState(() {
      _statuseslist.forEach((status) {


            if(status.type=="general"){

              typelast="عامة";

            }else{
              typelast="خاصة";

            }
            if(status.status=="end"){
              stattelast="مكتملة";

            }
            if(status.status=='accept'){
              stattelast='جاري التواصل';
            }
            if(status.status=='accepttreat'){
              stattelast=' تحت العلاج';
            }
            String result = status.created_at.substring(
                0, status.created_at.indexOf('T'));


            list.add(
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 30,
                  // height: 200,

                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(bottom: 10, right: 5, left: 5),
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
                  child:  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      primary: Colors.transparent,
                      // onPrimary: Color(0xFF6A21EA),
                    ),
                    onPressed: () async {
                      SharedPreferences prefsssss = await SharedPreferences.getInstance();

                      var response=await CallApi().getallData("getstatus/tooth_image/"+status.id.toString());
                      var body = json.decode(utf8.decode(response.bodyBytes));

                      prefsssss.setString('tooth_image', utf8.decode(response.bodyBytes).toString());
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Toothinterf(argument:
                          status
                          )
                            ));


                    },
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(

                                child: Row(
                                  children: [
                                    Text("  نوع العلاج: ",
                                      style: TextStyle(
                                        fontSize: 12, fontFamily: 'exar',
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    Text(status.nametreat,
                                      style: TextStyle(
                                        fontSize: 12, fontFamily: 'exar',
                                        color:AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.centerRight,

                                margin: EdgeInsets.only(right: 5),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Text("الحالة: ",
                                      style: TextStyle(
                                        fontSize: 12, fontFamily: 'exar',
                                        color: Color(0xFF000000),
                                      ),),
                                    Text(stattelast,
                                      style: TextStyle(
                                        fontSize: 12, fontFamily: 'exar',
                                        color:AppColors.primaryColor,
                                      ),),
                                  ],
                                ),
                                alignment: Alignment.centerLeft,
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              Container(

                                child:Row(
                                  children: [
                                    Text(" النوع: ",
                                      style: TextStyle(
                                        fontSize: 12, fontFamily: 'exar',
                                        color: Color(0xFF000000),
                                      ),),
                                    Text( typelast,
                                      style: TextStyle(
                                        fontSize: 12, fontFamily: 'exar',
                                        color:AppColors.primaryColor,
                                      ),),
                                  ],
                                ),
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(right: 5),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [Text("التاريخ:  ",
                                    style: TextStyle(
                                      fontSize: 12, fontFamily: 'exar',
                                      color: Color(0xFF000000),
                                    ),),
                                    Text(result,
                                      style: TextStyle(
                                        fontSize: 12, fontFamily: 'exar',
                                        color:AppColors.primaryColor,
                                      ),),],
                                ),
                                alignment: Alignment.centerLeft,
                              ),

                            ],
                          ),
                        ),
                        Container(

                          child:         Column(
                            children: [
                              Container(

                                child:  Text(" ملاحظات " ,
                                  style: TextStyle(
                                    fontSize: 12, fontFamily: 'exar',
                                    color: Color(0xFF0000000),
                                  ),
                                ),
                                alignment: Alignment.center,

                              ),
                              Container(

                                child: Text(status.notes ,                                               style: TextStyle(
                                  fontSize: 12, fontFamily: 'exar',
                                  color:AppColors.primaryColor,
                                ),),
                                alignment: Alignment.center,
                              ),

                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child:         Column(
                            children: [
                              Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(

                                    child:  Text(" وصف العلاج المطبق " ,
                                      style: TextStyle(
                                        fontSize: 12, fontFamily: 'exar',
                                        color: Color(0xFF0000000),
                                      ),
                                    ),
                                    alignment: Alignment.centerRight,

                                  ),
                                  Container(

                                    child: Row(
                                      children: [
                                        Text(" التاريخ:  ",
                                          style: TextStyle(
                                            fontSize: 12, fontFamily: 'exar',
                                            color: Color(0xFF000000),
                                          ),
                                        ),
                                        Text(status.datetreatment,
                                          style: TextStyle(
                                            fontSize: 12, fontFamily: 'exar',
                                            color:AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,

                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(status.treatment ,                                               style: TextStyle(
                                  fontSize: 12, fontFamily: 'exar',
                                  color:AppColors.primaryColor,
                                ),),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width-100,
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );


      });
    });
    if(list.length==0){
      return Container(
        height: hight,
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: Text("لا يتوفر سجل ",
        style:TextStyle(
          fontFamily: 'exar',
        )),
      );
    }
    return
  Container(
    color: Colors.white,
    child: Column(

            children:list,

        ),
  );


  }

  Future<void> search() async {
    SharedPreferences shpref= await SharedPreferences.getInstance();
    shpref.setString('search', searchcontroller.text);

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
                              child: Text('فشل حفظ التعديلات',style: TextStyle( fontFamily: 'exar',),),
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


  Future<void> _sharegallory () async {
    String sharelink="https://talaqe.org/protfolio/dentist/"+linkcode;
    String name=account.name;
    // Share.share(' معرض اعمال الطبيب $name على تطبيق تلاقي  $sharelink', subject: '!');
  }

  void changeImage() {

  }
}

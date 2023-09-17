import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:talaqe/data/Gallorywork.dart';
import 'package:talaqe/data/account.dart';
import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/interfaces/addtoprotifolio.dart';
import 'package:talaqe/interfaces/dataaccount.dart';
import 'package:talaqe/interfaces/images.dart';
import 'package:talaqe/interfaces/protifolo.dart';
import 'package:talaqe/interfaces/tooth.dart';
import 'package:talaqe/main.dart';
import 'package:talaqe/utils/constants/app_colors.dart';

import '../CallApi.dart';
import '../data/typetreatments.dart';
import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class End_Detail_stat extends StatefulWidget{
  allStatus status;
  End_Detail_stat({required this.status});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _End_Detail_stat();
  }


}
class _End_Detail_stat extends State<End_Detail_stat>{
  allStatus status=allStatus(0, "", "", "","","","","","","","","","","","","","","","","","","","","");

  int numstat=-1;
  bool reservstat=true;

  City city=new City(0, "");
  Typetreatment typetreatment=new Typetreatment(0, "", "");
  List<Typetreatment> _Typetreatments =[];
  List<Status> _laststatus =[];
  List<Gallorywork> _galloeryworklist =[];
  List<dynamic> data=[];
  String statte="عامة";
  String statustype="";
  bool progressstatus=true;
  String _url="https://talaqe.org/storage/app/public/";
  int accountid=0;
  int  allowedyear=0;
  String gender="";
  Account account =new Account(0,"","");
  @override
  void initState() {
    this.status=widget.status;

    // TODO: implement initState
    getdata();
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
    // TODO: implement build
    return  Scaffold(
        key: ValueKey(6),
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0xFFE5E5E5),
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop() ,
          ),
          backgroundColor:Colors.transparent ,
          elevation: 0,
          title:    Container(
            margin: EdgeInsets.only(top: 15),
            child:   progressstatus?Container():
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Column(
                    children: [

                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[

                            Text( status.patientname,
                                style:TextStyle( fontFamily: 'exar',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 17.0)),
                          ]
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[

                            Text( status.nametreat,
                                style:TextStyle( fontFamily: 'exar',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 14.0)),
                          ]
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      progressstatus?Container():

                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              primary: Colors.transparent,
                              onPrimary: Color(0xFF6A21EA),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Toothinterf(argument: status,)));

                            },
                            child: Container(

                                padding:EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: Color(0xFF9267DD),
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Image.asset("asset/tooth.jpg",
                                  width:25,)
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              primary: Colors.transparent,
                              onPrimary: Color(0xFF6A21EA),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Imageinterfac(argument:status)));

                            },
                            child: Container(
                                padding:EdgeInsets.all(2.0),
                                decoration: BoxDecoration(
                                    color: Color(0xFF9267DD),
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child:Icon(Icons.image,
                                  size: 30,
                                )
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ]
            ),
          ),
        ),
        body:  progressstatus?Container(
          child: Center(
              child:  CircularProgressIndicator(

                valueColor:  new AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                ,)

          ),
        ):Stack(
            children:[

              Container(
                width: screenWidth,
                height: screenHeight/3,
                margin: EdgeInsets.only(right: 0,left: 0,top: 0,bottom: 5),
                padding: EdgeInsets.only(top: 50,right:50,left: 50 ),
                color: AppColors.primaryColor,


              ),

              Container(
                  width: MediaQuery.of(context).size.width,
                  // height:MediaQuery.of(context).size.height+(numstat*260),
                  margin: EdgeInsets.only(top: 130,bottom: 5,left:0 ,right: 0),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:  BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                  ),
                  child:   SingleChildScrollView(

                      child:Stack(children:[
                        Container(
                          margin: EdgeInsets.only(top: 0),
                          alignment: Alignment.center,
                          child:     Text("تفاصيل الحالة",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'exar',
                                color:AppColors.primaryColor
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,

                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(bottom: 10,right: 5,left: 5,top: 40),
                          decoration: BoxDecoration(
                            color: Color(0xFFF0EAF9),
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
                                margin: EdgeInsets.only(right: 10),
                                child:         Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(

                                      child: Row(
                                        children: [
                                          Text(" النوع : ",
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                              fontFamily: 'exar',
                                            ),
                                          ),
                                          Text(statustype ,
                                            style: TextStyle(
                                              fontFamily: 'exar',
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
                                      child:Row(
                                        children: [
                                          Text("الحالة : ",
                                            style: TextStyle( fontFamily: 'exar',
                                              color: Color(0xFF000000),
                                            ),),
                                          Text(statte,
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
                                margin: EdgeInsets.only(right: 10),
                                child:         Column(
                                  children: [
                                    Container(

                                      child:  Text(" ملاحظات: " ,
                                        style: TextStyle(
                                          fontFamily: 'exar',
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width-50,
                                      margin: EdgeInsets.only(right: 5),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(status.notes ,
                                        style: TextStyle(
                                          fontFamily: 'exar',
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
                          margin: EdgeInsets.only(top: 150),
                          alignment: Alignment.center,
                          child: Text(" معلومات المريض",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color:AppColors.primaryColor
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(bottom: 10,right: 5,left: 5,top: 190),
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
                                            style: TextStyle(
                                              fontFamily: 'exar',
                                              color: Color(0xFF000000),
                                            ),
                                          ),
                                          Text( status.patientage,
                                            style: TextStyle(
                                              fontFamily: 'exar',
                                              color:AppColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.only(right: 5),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: [
                                          Text("الجنس: ",
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                            ),),
                                          Text(gender,
                                            style: TextStyle(
                                              fontFamily: 'exar',
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
                                  children: [
                                    Container(

                                      child:  Text(" المدينة: " ,
                                        style: TextStyle(
                                          fontFamily: 'exar',
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                      alignment: Alignment.centerRight,
                                      width: MediaQuery.of(context).size.width/2-50,
                                      margin: EdgeInsets.only(right: 5),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(city.name,
                                        style: TextStyle(
                                          fontFamily: 'exar',
                                          color:AppColors.primaryColor,
                                        ),),
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width/2-20,
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 5),
                                child:         Row(
                                  children: [
                                    Container(

                                      child:  Text(" الموقع " ,
                                        style: TextStyle(
                                          fontFamily: 'exar',
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                      alignment: Alignment.centerRight,
                                      width: MediaQuery.of(context).size.width/2-50,
                                      margin: EdgeInsets.only(right: 5),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 5),
                                      child: Text(status.patientlocation,
                                        style: TextStyle(
                                          fontFamily: 'exar',
                                          color:AppColors.primaryColor,
                                        ),),
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width/2-20,
                                    ),

                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child:         Row(
                                  children: [
                                    Container(

                                      child:  Text(" رقم الهاتف " ,
                                        style: TextStyle(
                                          fontFamily: 'exar',
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                      alignment: Alignment.centerRight,
                                      width: MediaQuery.of(context).size.width/2-50,
                                      margin: EdgeInsets.only(right: 5),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child:      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          padding: EdgeInsets.zero ,
                                          shadowColor: Colors.transparent,
                                          primary: Colors.transparent,
                                          // onPrimary: Color(0xFF9267DD),
                                        ),
                                        onPressed: () => launch("tel://"+status.patientphone),
                                         child:  Row(
                                           mainAxisAlignment: MainAxisAlignment.end,
                                           children: [
                                             Icon(Icons.phone,
                                             color:Color(0xFF591DC1)),
                                             Text(status.patientphone,
                                              style: TextStyle(
                                                fontFamily: 'exar',
                                                color:AppColors.primaryColor,
                                              ),),
                                           ],
                                         ),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width/2-20,
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
                                        style: TextStyle(
                                          fontFamily: 'exar',
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width-50,
                                      margin: EdgeInsets.only(right: 5),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(status.patientother,
                                        style: TextStyle(
                                          fontFamily: 'exar',
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


                      ])
                  )),

            ]),
        bottomNavigationBar:
        reservstat? TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
                horizontal: 40.0, vertical: 15.0),
            primary: Colors.white,
            backgroundColor:  AppColors.primaryColor,
          ),
          onPressed: () {
            showbookingdialog(context) ;
          },
          child: Text('  إضافة الحالة للمعرض الشخصي',
          style:TextStyle(
            fontFamily: 'exar',
          )),
        ):Container(
          width: screenWidth,
          height: 0,
        )
    ); }

  Future<void> getdata() async {

    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";
    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
      });
      print("account id" + accountid.toString());
      print("stat id" + status.id.toString());
      Map datatype = data[0];



      // print("statuseslist"+_laststatus.length.toString());
      setState((){
        if(status.type=="general"){

          statustype="عامة";

        }else{
          statustype="خاصة";
        }
        if(status.status=="waiting"){

          statte="عامة";

        }
        if(status.status=="end"){
          statte="مكتملة";

        }
        if(status.status=="cancel"){
          statte="ملغية";
        }
        if(status.status=='accept'){
          statte='جاري التواصل';
        }
        if(status.status=='accepttreat'){
          statte=' تحت العلاج';
        }
        if(status.patientgender=="f"){
          gender="انثى";
        }else{
          gender="ذكر";
        }

      });
      List<dynamic> typetreatments = datatype['Typetreatment'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        typetreatments.forEach((element) {
          print("add to areas " + element.toString());

          _Typetreatments.add(
              Typetreatment(element['id'], element['name'] ?? "",
                  element['image'] ?? ""));
          if(int.parse(status.typetreatment)==element['id']){
            typetreatment.id=element['id'];
            typetreatment.name=  element['name'] ?? "";
            typetreatment.image=    element['image'] ?? "";
          }

        });
      });




      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        cities.forEach((element) {
          print("add to areas " + element.toString());

          if(int.parse(status.patientcity)==element['id']){
            city.id=element['id'];
            city.name=  element['name'] ?? "";
          }

        });
      });

      setState(() {

        progressstatus=false;
      });


      var response=await CallApi().getallData("getstatus/tooth_image/"+status.id.toString());
      var body = json.decode(utf8.decode(response.bodyBytes));

      prefsssss.setString('tooth_image', utf8.decode(response.bodyBytes).toString());
    }
  }

  void showbookingdialog(BuildContext context) {

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
                              child: Text('هل ترغب إضافة هذه الحالة لمعرض اعمالك؟ ',
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
                            onTap: ()  async {

          Navigator.of(dialogContext).pop();

          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Addtoprotifolio()));


          }

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
                              child: Text('فشل العملية',
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
                                  'تمت العملية بنجاح بامكانك استعراض معرض اعمالك ',
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
                            onTap: () {
                               Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) => DataAccount()));

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

}
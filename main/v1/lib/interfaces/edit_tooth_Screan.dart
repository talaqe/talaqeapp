import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/toothes.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/fail.dart';
import 'package:talaqe/utils/constants/app_colors.dart';

import '../CallApi.dart';
import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Edit_ToothScrean extends StatefulWidget{

  final Object? argument;
  Edit_ToothScrean({Key? key, this.argument}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Edit_Toothinterf();
  }


}
class _Edit_Toothinterf extends State<Edit_ToothScrean>{

  int totaltooth=0;
  allStatus status=allStatus(0, "", "", "","","","","","","","","","","","","","","","","","","","","");

  Typetreatment typetreatment=new Typetreatment(0, "", "");
  String _url="https://talaqe.org/storage/app/public/";
  List<Tooth> _toothes =[];
  List<TextEditingController> notes =[];

  int accountid=0;
  List<dynamic> data=[];
  @override
  void initState() {
    // TODO: implement initState
    _setChatScreenParameter(widget.argument);
    getdata();
    super.initState();
  }
  void _setChatScreenParameter(Object? argument) {
    if (argument != null && argument is allStatus) {
      status = argument;
    }
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
      ),
      body:Stack(
          children:[

            Container(
              width: screenWidth,
              height: screenHeight/3,
              margin: EdgeInsets.only(right: 0,left: 0,top: 0,bottom: 5),
              padding: EdgeInsets.only(top: 50,right:50,left: 50 ),
              color: AppColors.primaryColor,
              child:
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Column(
                      children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[

                              Text( status.patientname,
                                  style:TextStyle(
                                      fontFamily: 'exar',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 17.0)),
                            ]
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[

                              Text( status.nametreat,
                                  style:TextStyle(
                                      fontFamily: 'exar',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 14.0)),
                            ]
                        ),
                      ],
                    ),

                  ]
              ),

            ),

            Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 120,bottom: 5,left:0 ,right: 0),
                padding: EdgeInsets.all(10),
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                ),
                child:   SingleChildScrollView(

                    child: Container(
                      child: Column(children:[
                        Text("تفاصيل الاسنان",
                          style: TextStyle(
                              fontFamily: 'exar',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,

                              color: AppColors.primaryColor
                          ),
                        ),
                        getlaststatuslist(),


                      ]),
                    )
                )
            ),

          ]),
  bottomNavigationBar: TextButton(
    style: TextButton.styleFrom(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.zero)),
      padding: EdgeInsets.symmetric(
          horizontal: 40.0, vertical: 15.0),
      primary:Colors.white  ,
      backgroundColor:  AppColors.primaryColor,
    ),
    onPressed: () {
saveddata();
    },
    child: Text(' حفظ تغيرات الاسنان',style: TextStyle(
      fontFamily: 'exar',
    ),),
  ),
    ); }

  Future<void> saveddata() async {
    var body;
    int id=0;
    try{
      List listtooth=[];
      for(int i=0;i<totaltooth;i++){
        listtooth.add({
          'id':_toothes[i].id,
          'notes':notes[i].text,
        });
      }
      print('listtooth'+listtooth.length.toString());
      var data={'api_key': 'fYqUL6SU6bMJ_K4z9Nbb1TACyz1GZ7jbPgG',

        'id':status.id.toString(),
        'listtooth':listtooth,

      };
      var response=await CallApi().postData(data,'save/tooth');
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



      if (body['success'] ==true) {



        showsuccessdialog(context);


      } else {
        showfaildialog(context);
      }

    }


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
                              child: Text('تمت العملية بنجاح',style: TextStyle(
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
                                style: TextStyle( fontFamily: 'exar',
                                    color: AppColors.primaryColor, fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(dialogContext).pop();

                              _refreshData();

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
  Future<void> _refreshData() async {
    try {
      var response=await CallApi().getallData("getstatus/tooth_image/"+status.id.toString());
      var body = json.decode(utf8.decode(response.bodyBytes));


      print('respone tooth_image  ' + response.body.toString());
      SharedPreferences shpref= await SharedPreferences.getInstance();
      shpref.setString('tooth_image', utf8.decode(response.bodyBytes).toString());

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

    getdata();
  }

  Future<void> getdata() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('tooth_image') ?? "";
    if (datastring != "") {

      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
      });
      print("account id" + accountid.toString());

      List<dynamic> datatype = json.decode(datastring);
      var data1 = datatype[0];
      print("data" + data1.toString());
      List<dynamic> toothes = data1['tooths'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        int i=0;
        _toothes=[];
        toothes.forEach((element) {

              notes.add(new TextEditingController());

              print("add to areas " + element.toString());
              String tothplace="";
              tothplace=element['tothplace'];

              _toothes.add(
                  Tooth(
                      element['id'],
                      element['patientid'] ?? "",
                      element['statusid'] ?? "",
                      element['type'] ?? "",
                      tothplace,
                      element['toothnumber'] ?? "",
                      element['notes'] ?? "",
                      element['created_at'] ?? ""
                  ));
              notes[i].text = element['notes'] ?? "";
              i=i+1;

        });
      });

    }
  }
  Widget getlaststatuslist() {
    List<Widget> list = [];
    int i=0;
    _toothes.forEach((element) {


      list.add(
          Container(
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
                                    padding:EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF9267DD),
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Image.asset("asset/tooth.jpg",
                                      width:50,)
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [   Text(" مكان السن: ",
                                        style: TextStyle(
                                          fontFamily: 'exar',
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                        Text(element.tothplace,
                                          style: TextStyle(
                                            fontFamily: 'exar',
                                            color:AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      children: [
                                        Container(
                                          child:  Text("رقم السن: ",
                                            style: TextStyle(
                                              fontFamily: 'exar',
                                              color: Color(0xFF000000),
                                            ),),
                                        ),
                                        Container(
                                          child: Text(element.toothnumber,
                                            style: TextStyle(
                                              fontFamily: 'exar',
                                              color:AppColors.primaryColor,
                                            ),),
                                        ),
                                      ],
                                    ),
                                  ],
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
                        alignment: Alignment.center,

                      ),
                      Container(

                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          minLines: 1,
                          maxLines: 5,
                          controller: notes[i],
                          textAlign: TextAlign.right,

                          decoration: InputDecoration(
                            filled: true,
                            focusColor: Color(0xFF000000),
                            hoverColor: Color(0xFF000000),
                            fillColor: Color(0xFFFFFF),
                            hintStyle: TextStyle(
                                fontSize: 15.0, color: Color(0xFF000000)),

                            border: UnderlineInputBorder(),
                            hintText: "ادخل ملاحظات",
                          ),

                        ),
                        alignment: Alignment.center,
                      ),

                    ],
                  ),
                ),

              ],
            ),
          )
      );
      i=i+1;
    });
setState((){
  totaltooth=i;
});
    if(!list.isEmpty) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(bottom:0, right: 0, left: 0),

        child: Column(
            children: list
        ),
      );
    }else{
      return Center(
        child: Text('لاتتوفر معلومات عن الاسنان',
        style: TextStyle(
          fontFamily: 'exar',
        ),),
      );
    }
  }
}
import 'dart:convert';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/addimagetoprotiflio.dart';

import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:http/http.dart' as http;

import '../CallApi.dart';

class Addtoprotifolio extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Addtoprotifolio();
  }

}



class _Addtoprotifolio extends State<Addtoprotifolio> {
  List<Typetreatment> _Typetreatments =[];
  TextEditingController name=new TextEditingController();
  TextEditingController massege=new TextEditingController();
  Typetreatment _selecttypetreatment=Typetreatment(0,"اختر نوع العلاج","");

  int accountid=0;
  List<dynamic> data=[];
  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }
  Future<void> senddata(BuildContext context) async {
    var data={'api_key': 'fYqUL6SU6bMJ_K4z9Nbb1TACyz1GZ7jbPgG',
      'id':accountid.toString(),
      "treatment": _selecttypetreatment.id,
      "title": name.text,
      "text":massege.text,};

    var response=await CallApi().postData(data,'protifolio/add');

    // var body=json.decode(response.body);
    var body = json.decode(utf8.decode(response.bodyBytes));
    print('respone getallldatttasaalllslk  '+response.body.toString());

    if(body.toString()==""){
      print('respone ssssssssssss ');

      showdialogfail(context);
    }else {
      if (body['success'] == true) {


        print('respone ' + response.body.toString());
        showdialogsuccess(context,body['id']);
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

            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop() ,
              ),
              // backgroundColor: AppColors.primaryColor,
              backgroundColor:Colors.transparent ,
              elevation: 0,
              iconTheme: IconThemeData(
                color: Color(0xFFFFFFFF), //change your color here
              ),
              title: Row(
                children: <Widget>[
                  Text(" إضافة لمعرض الأعمال ",style: TextStyle(  color: Color(0xFFFFFFFF),
                      fontFamily: 'majallab'),),
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
                      child: Container(
                        height: 1000.0,
                        margin: EdgeInsets.only(top: 70.0,left: 0.0,right: 0.0,bottom: 0.0),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children:<Widget> [
                                    SizedBox(height: 20.0,),

                                    Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(width: 2,
                                                    color: Colors.grey)
                                            )

                                        ),
                                        // margin:EdgeInsets.only(right:20),
                                        // width: screenWidth- 15,
                                        child:  ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              shadowColor: Colors.transparent,
                                              primary: Colors.transparent
                                          ),
                                          child: Row(
                                            children: [

                                              SizedBox(height:2),
                                              Text(_selecttypetreatment.name,
                                                style: TextStyle(fontSize: 14,
                                                    color: Color(0xFF3B3B3B)),)],
                                          ),


                                          onPressed: (){
                                            showModalBottomSheet(context: context,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.vertical(
                                                        top: Radius.circular(20)
                                                    )
                                                ),
                                                builder: (context){
                                                  return   gettreatmentlist();
                                                });

                                          },
                                        )

                                    ),

                                    SizedBox(height: 10.0,),
                                    Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(width: 2,
                                                  color: Colors.grey),
                                          ),
                                      ),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'الرجاء ادخال العنوان';
                                          }
                                          return null;
                                        },
                                        controller: name,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            hintText: "العنوان",
                                            labelStyle:  TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'majallab'
                                            ),
                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'majallab'
                                            )
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5.0,),

                                    Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 2,
                                              color: Colors.grey),
                                        ),
                                      ),
                                      child: TextFormField(

                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'لرجاء ادخال  الوصف ';
                                          }
                                          return null;
                                        },
                                        controller: massege,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            hintText: "الوصف",

                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'majallab'
                                            )
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5.0,),

                                    MaterialButton(onPressed: (){

                                        if(name.text==null || massege.text=='' || _selecttypetreatment.id==0){
                                          showdialog(context);
                                        }else{

                                          senddata(context);
                                        }



                                    },
                                      height: 50.0,
                                      minWidth: double.infinity,
                                      color:   Color(0xFF6F1CE6),
                                      child: Text('الانتقال لإضافة الصور',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontFamily: 'majallab'
                                        ),),)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                  ),
                ]
            )
        )
    );
  }
  Widget gettreatmentlist() {
    List<Widget> list = [];
    _Typetreatments.forEach((element) {
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
           
            Text(element.name),
          ],
        ),

        onPressed: (){setState(() {
          _selecttypetreatment=element;

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
                                  fontFamily: 'majallab',
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
                                    fontFamily: 'majallab',
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

  void showdialogsuccess(BuildContext context,int id) {
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
                              child: Text(' تم حفط المعلومات',
                                style: TextStyle(
                                    fontFamily: 'majallab'
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
                                style: TextStyle(
                                    color:  Color(0xFF6F1CE6), fontSize: 20.0,
                                    fontFamily: 'majallab'),
                                textAlign: TextAlign.center,

                              ),
                            ),
                            onTap: () {
                              //AddImageprotiflio
                              Navigator.of(dialogContext).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddImageprotiflio(protifloid:id)));




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
                                    fontFamily: 'majallab'
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
                                    color:   Color(0xFF6F1CE6), fontSize: 25.0,
                                    fontFamily: 'majallab'),
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
                        child: Align(
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
  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";

    setState(() {
      accountid = prefsssss.getInt('accountid') ?? 0;
    });
    data = json.decode(datastring);
    Map datatype=data[0];
    List<dynamic> typetreatments = datatype['Typetreatment'];
    // print('respone areas  ' + data['areas'].toString());

    setState(() {
      typetreatments.forEach((element) {
        print("add to areas " + element.toString());

        _Typetreatments.add(
            Typetreatment(element['id'], element['name'] ?? "",
                element['image'] ?? ""));
      });
    });

  }

}
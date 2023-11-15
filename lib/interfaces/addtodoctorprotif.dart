import 'dart:convert';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/data/Gallorywork.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/addimagetoprotiflio.dart';
import 'package:talaqe/interfaces/showprotifolio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import '../CallApi.dart';

class Addtodoctorprotif extends StatefulWidget {
  const Addtodoctorprotif({super.key});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Addtodoctorprotif();
  }

}



class _Addtodoctorprotif extends State<Addtodoctorprotif> {
  final List<Typetreatment> _Typetreatments =[];
  final List<Gallorywork> _Gallorywork =[];
  bool selectstatus=false;
  TextEditingController name=TextEditingController();
  TextEditingController massege=TextEditingController();
  Typetreatment _selecttypetreatment=Typetreatment(0,"اختر نوع العلاج","");
  Gallorywork _selectGallorywork=Gallorywork(0, "", "", "", "", "", "اختر حالة سابقة", "", "","","");
  Gallorywork firststatus=Gallorywork(0, "", "", "", "", "", "اختر حالة سابقة", "", "","","");

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
      "gallorywork": _selectGallorywork.id,
         };

    var response=await CallApi().postData(data,'gallorywork/addtodentist');

    // var body=json.decode(response.body);
    var body = json.decode(utf8.decode(response.bodyBytes));
    print('respone getallldatttasaalllslk  ${response.body}');

    if(body.toString()==""){
      print('respone ssssssssssss ');

      showdialogfail(context);
    }else {
      if (body['success'] == true) {


        print('respone ${response.body}');
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

            extendBodyBehindAppBar: true,
            appBar: AppBar(
              leading: BackButton(
                color: Colors.white,
                onPressed: () => Navigator.of(context).pop() ,
              ),
              // backgroundColor: AppColors.primaryColor,
              backgroundColor:Colors.transparent ,
              elevation: 0,
              iconTheme: const IconThemeData(
                color: Color(0xFFFFFFFF), //change your color here
              ),
              title: const Row(
                children: <Widget>[
                  Text(" إضافة لمعرض الأعمال ",style: TextStyle(  color: Color(0xFFFFFFFF),
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
                      child: Container(
                        height: 1000.0,
                        margin: const EdgeInsets.only(top: 70.0,left: 0.0,right: 0.0,bottom: 0.0),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                margin: const EdgeInsets.symmetric(horizontal: 30.0),
                                height: 50,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(width: 2,
                                            color: Colors.grey)
                                    )

                                ),
                                // margin:EdgeInsets.only(right:20),
                                // width: screenWidth- 15,
                                child:  ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0, backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent
                                  ),
                                  child: Row(
                                    children: [

                                      const SizedBox(height:2),
                                      Text(_selectGallorywork.title,
                                        style: const TextStyle(fontSize: 14,
                                            fontFamily: 'exar',
                                            color: Color(0xFF3B3B3B)),)],
                                  ),


                                  onPressed: (){
                                    showModalBottomSheet(context: context,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)
                                            )
                                        ),
                                        builder: (context){
                                          return   getgallorylistwork();
                                        });

                                  },
                                )

                            ),
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                              margin: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius:  BorderRadius.all(Radius.circular(100)),
                              ),
                              child: const Text("أو",
                              style: TextStyle( fontFamily: 'exar',
                                  color: Colors.white),),
                            ),
                        !selectstatus?Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children:<Widget> [
                                    const SizedBox(height: 20.0,),

                                    Container(
                                        height: 50,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(width: 2,
                                                    color: Colors.grey)
                                            )

                                        ),
                                        // margin:EdgeInsets.only(right:20),
                                        // width: screenWidth- 15,
                                        child:  ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 0, backgroundColor: Colors.transparent,
                                              shadowColor: Colors.transparent
                                          ),
                                          child: Row(
                                            children: [

                                              const SizedBox(height:2),
                                              Text(_selecttypetreatment.name,
                                                style: const TextStyle(fontSize: 14,
                                                    fontFamily: 'exar',
                                                    color: Color(0xFF3B3B3B)),)],
                                          ),


                                          onPressed: (){
                                            showModalBottomSheet(context: context,
                                                shape: const RoundedRectangleBorder(
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

                                    const SizedBox(height: 10.0,),
                                    Container(
                                      height: 50,
                                      decoration: const BoxDecoration(
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
                                        decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            hintText: "العنوان",
                                            labelStyle:  TextStyle(
                                                fontSize: 16,
                                              fontFamily: 'exar',
                                            ),
                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'majallab'
                                            )
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0,),

                                    Container(
                                      height: 150,
                                      decoration: const BoxDecoration(
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
                                        decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            border: InputBorder.none,
                                            hintText: "الوصف",

                                            hintStyle: TextStyle(
                                                fontSize: 16,
                                              fontFamily: 'exar',
                                            )
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5.0,),

                                    MaterialButton(onPressed: (){

                                      if(massege.text=='' || _selecttypetreatment.id==0){
                                        showdialog(context);
                                      }else{
                                        backtooctor();

                                      }



                                    },
                                      height: 50.0,
                                      minWidth: double.infinity,
                                      color:   const Color(0xFF6F1CE6),
                                      child: const Text('الانتقال لإضافة الصور',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          fontFamily: 'exar',
                                        ),),)
                                  ],
                                ),
                              ),
                            ):
                            Container(
                              margin: const EdgeInsets.all(30),
                              child:  Column(
                                children: [
                                  MaterialButton(onPressed: (){

                                    if(_selectGallorywork.id==0 ){
                                      showdialog(context);
                                    }else{

                                      senddata(context);
                                    }



                                  },
                                    height: 50.0,
                                    minWidth: double.infinity,
                                    color:   const Color(0xFF6F1CE6),
                                    child: const Text('إضافة لمعرض الاطباء',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        fontFamily: 'exar',
                                      ),),) ,
                                  const SizedBox(height: 10,),
                                  MaterialButton(onPressed: (){

                                    backtoadd();


                                  },
                                    height: 50.0,
                                    minWidth: double.infinity,
                                    color:   const Color(0xFF6F1CE6),
                                    child: const Text('إضافة حالة جديدة',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        fontFamily: 'exar',
                                      ),),) ,
                                ],
                              )
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
    for (var element in _Typetreatments) {
      print('ffff${element.name}');
      list.add( ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          children: [
           
            Text(element.name,
            style:const TextStyle( fontFamily: 'exar',)),
          ],
        ),

        onPressed: (){setState(() {
          _selecttypetreatment=element;

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
  Widget getgallorylistwork() {
    List<Widget> list = [];
    for (var element in _Gallorywork) {
      // print('ffff'+element.name);
      list.add( ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          children: [
           
            Text(element.title,
            style:const TextStyle(
              fontFamily: 'exar',
            )),
          ],
        ),

        onPressed: (){setState(() {
          _selectGallorywork=element;
          selectstatus=true;
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
                              child: Text(' تم حفط المعلومات',
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
                                style: TextStyle(
                                    color:  Color(0xFF6F1CE6), fontSize: 20.0,
                                  fontFamily: 'exar',),
                                textAlign: TextAlign.center,

                            ),
                            ),
                            onTap: () {
                              //AddImageprotiflio
                              Navigator.of(dialogContext).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ShowProtifolio()));




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
                                    color:   Color(0xFF6F1CE6), fontSize: 25.0,
                                  fontFamily: 'exar',),
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
                        child: const Align(
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
      for (var element in typetreatments) {
        print("add to areas $element");

        _Typetreatments.add(
            Typetreatment(element['id'], element['name'] ?? "",
                element['image'] ?? ""));
      }
    });
    List<dynamic> imagegallory = datatype['Imagegallory'];
    // print('respone areas  ' + data['areas'].toString());

    setState(() {
      for (var element in typetreatments) {
        print("add to areas $element");

        _Typetreatments.add(
            Typetreatment(element['id'], element['name'] ?? "",
                element['image'] ?? ""));
      }
    });
    List<dynamic> Galloryworklist = datatype['Gallorywork'];
    // print('respone areas  ' + data['areas'].toString());

    setState(() {
      for (var element in Galloryworklist) {
        print("add to areas $element");
        if(int.parse( element['dentistid'])==accountid) {
          if (int.parse(element['addtodoctorlist']) ==0) {
            _Gallorywork.add(
                Gallorywork(
                    element['id'],
                    element['code'] ?? "",
                    element['dentistid'] ?? "",
                    element['stateid'] ?? "",
                    element['patientid'] ?? "",
                    element['treatid'] ?? "",
                    element['title'] ?? "",
                    element['text'] ?? "",
                    element['created_at'] ?? "",
                    element['likes'] ?? "",
                    element['views'] ?? ""));
          }
        }
      }
    });
  }
  void backtoadd() {
    setState((){
      selectstatus=false;
      _selectGallorywork=firststatus;
    });
  }

  Future<void> backtooctor() async {
    var data={'api_key': 'fYqUL6SU6bMJ_K4z9Nbb1TACyz1GZ7jbPgG',
      'id':accountid.toString(),
      "treatment": _selecttypetreatment.id,
      "title": name.text,
      "text":massege.text,};

    var response=await CallApi().postData(data,'protifolio/add');

    // var body=json.decode(response.body);
    var body = json.decode(utf8.decode(response.bodyBytes));
    print('respone getallldatttasaalllslk  ${response.body}');

    if(body.toString()==""){
      print('respone ssssssssssss ');

      showdialogfail(context);
    }else {
      if (body['success'] == true) {


        print('respone ${response.body}');
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddImageprotiflio(protifloid:body['id'])));


      }else{
        showdialogfail(context);

      }
    }

  }
}


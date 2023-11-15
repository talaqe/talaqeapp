import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:talaqe/data/account.dart';
import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/interfaces/edit_tooth_Screan.dart';
import 'package:talaqe/interfaces/images.dart';
import 'package:talaqe/interfaces/index.dart';
import 'package:talaqe/interfaces/tooth.dart';
import 'package:talaqe/main.dart';
import 'package:talaqe/utils/constants/app_colors.dart';

import '../CallApi.dart';
import '../data/typetreatments.dart';
import '../fail.dart';
import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Detail_Mystatus extends StatefulWidget{
allStatus status;
Detail_Mystatus({super.key, required this.status});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Detail_Mystatus();
  }


}
class _Detail_Mystatus extends State<Detail_Mystatus>{
  int numstat=1;
  String gender="";
  bool edit=false;
  bool reservstat=true;
  allStatus status=allStatus(0, "", "", "","","","","","","","","","","","","","","","","","","","","");

  City city=City(0, "");
  Typetreatment typetreatment=Typetreatment(0, "", "");
  final List<Typetreatment> _Typetreatments =[];
  final List<Status> _laststatus =[];
  List<dynamic> data=[];
  String statte="";
  String statustype="";
  bool progressstatus=true;
  TextEditingController  notes=TextEditingController();
  TextEditingController  treatment=TextEditingController();
  TextEditingController  reson=TextEditingController();
  TextEditingController  others=TextEditingController();
  final dateController = TextEditingController();
  bool emptyfild=false;
  final String _url="https://talaqe.org/storage/app/public/";
  int accountid=0;
  int  allowedyear=0;
   DateTime date=DateTime.now();
  Account account =Account(0,"","");
  @override
  void initState() {
    status=widget.status;
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
    print("fffffffffffff${screenHeight+(numstat*150)}");

    // TODO: implement build
    return  Scaffold(
        key: const ValueKey(6),
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xFFE5E5E5),
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: () => Navigator.of(context).pop() ,
          ),
          backgroundColor:Colors.transparent ,
          elevation: 0,
          title:    Container(
            margin: const EdgeInsets.only(top: 15),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Column(
                    children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[

                            Text( status.patientname,
                                style:const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'exar',
                                    fontSize: 17.0)),
                          ]
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:[

                            Text( typetreatment.name,
                                style:const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'exar',
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
                              foregroundColor: const Color(0xFF6A21EA), padding: EdgeInsets.zero, backgroundColor: Colors.transparent,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {

                            },
                            child: Container(

                                padding:const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF9267DD),
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child: Image.asset("asset/tooth.jpg",
                                  width:30,)
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: const Color(0xFF6A21EA), elevation: 0, backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () {

                            },
                            child: Container(
                                padding:const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF9267DD),
                                    borderRadius: BorderRadius.circular(12)
                                ),
                                child:const Icon(Icons.image,
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
        body:     progressstatus?Container(
          child: const Center(
              child:  CircularProgressIndicator(

                valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                ,)

          ),
        ):Stack(
            children:[

              Container(
                width: screenWidth,
                height: screenHeight/3,
                margin: const EdgeInsets.only(right: 0,left: 0,top: 0,bottom: 5),
                padding: const EdgeInsets.only(top: 50,right:50,left: 50 ),
                color: AppColors.primaryColor,


              ),

              Container(
                width: MediaQuery.of(context).size.width,
                 // height:  MediaQuery.of(context).size.height-200,
                margin: const EdgeInsets.only(top: 130,bottom: 5,left:0 ,right: 0),
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                ),
                child: SingleChildScrollView(

                    child: Stack(children:[
                      Container(
                        margin: const EdgeInsets.only(top: 0),
                        width: screenWidth,
                        alignment: Alignment.center,
                        child: const Text("تفاصيل الحالة",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'exar',
                              fontWeight: FontWeight.bold,

                              color:AppColors.primaryColor
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 270,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(bottom: 10,right: 5,left: 5,top: 30),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EAF9),
                          borderRadius:  const BorderRadius.all( Radius.circular(15)),
                          boxShadow:[
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

                              child:         Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(

                                    alignment: Alignment.centerRight,
                                    margin: const EdgeInsets.only(right: 5),

                                    child: Row(
                                      children: [
                                        const Text(" النوع : ",
                                          style: TextStyle( fontFamily: 'exar',
                                            color: Color(0xFF000000),
                                          ),
                                        ),
                                        Text(statustype ,
                                          style: const TextStyle(
                                            color:AppColors.primaryColor, fontFamily: 'exar',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    child:Row(
                                      children: [
                                        const Text("الحالة : ",
                                          style: TextStyle(
                                            color: Color(0xFF000000), fontFamily: 'exar',
                                          ),),
                                        Text(statte,
                                          style: const TextStyle(
                                            color:AppColors.primaryColor, fontFamily: 'exar',
                                          ),),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            Container(

                              child: Column(
                                children: [
                                  Container(

                                    alignment: Alignment.center,

                                    child: const Text(" ملاحظات ",
                                      style: TextStyle(
                                        color: Color(0xff0000000), fontFamily: 'exar',
                                      ),
                                    ),

                                  ),
                                  Container(

                                    alignment: Alignment.center,

                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.newline,

                                      controller: notes,
                                      textAlign: TextAlign.right,

                                      decoration: const InputDecoration(
                                        filled: true,
                                        focusColor: Color(0xFF000000),
                                        hoverColor: Color(0xFF000000),
                                        fillColor: Color(0x00ffffff),
                                        hintStyle: TextStyle( fontFamily: 'exar',
                                            fontSize: 15.0, color: Color(0xFF000000)),

                                        border: UnderlineInputBorder(),
                                        hintText: "ادخل ملاحظات",
                                      ),

                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Container(

                                    alignment: Alignment.center,

                                    child: const Text(" وصف العلاج المطبق ",
                                      style: TextStyle(
                                        color: Color(0xff0000000), fontFamily: 'exar',
                                      ),
                                    ),

                                  ),
                                  Container(

                                    alignment: Alignment.center,

                                    child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.newline,

                                      controller: treatment,
                                      textAlign: TextAlign.right,

                                      decoration: const InputDecoration(
                                        filled: true,
                                        focusColor: Color(0xFF000000),
                                        hoverColor: Color(0xFF000000),
                                        fillColor: Color(0x00ffffff),
                                        hintStyle: TextStyle( fontFamily: 'exar',
                                            fontSize: 15.0, color: Color(0xFF000000)),

                                        border: UnderlineInputBorder(),
                                        hintText: "ادخل الوصف",
                                      ),

                                    ),
                                  ),

                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child:   TextFormField(

                                textAlign: TextAlign.right,
                                decoration: const InputDecoration(
                                  filled: true,
                                  focusColor:  Color(0xFF020202),
                                  hoverColor: Color(0xFF000000) ,
                                  fillColor: Color(0x00ffffff),
                                  hintStyle: TextStyle( fontFamily: 'exar',fontSize: 15.0, color: Color(0xFF000000)),

                                  border: UnderlineInputBorder(),
                                  hintText: "اختر تاريخ",
                                ),
                                focusNode: AlwaysDisabledFocusNode(),
                                controller: dateController,
                                onTap: () {
                                  _selectDate(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 310),
                        width: screenWidth,
                        alignment: Alignment.center,
                        child: const Text(" معلومات المريض",
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'exar',
                              fontWeight: FontWeight.bold,
                              color:AppColors.primaryColor
                          ),
                        ),
                      ),
                      Container(

                        width: MediaQuery.of(context).size.width,
                        height: 215,
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.only(bottom: 10,right: 5,left: 5,top: 350),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9DEF9),
                          borderRadius:  const BorderRadius.all( Radius.circular(15)),
                          boxShadow:[
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
                              margin: const EdgeInsets.only(right: 0),
                              child:         Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(

                                    alignment: Alignment.centerRight,
                                    margin: const EdgeInsets.only(right: 5),

                                    child: Row(
                                      children: [
                                        const Text("  العمر: " ,
                                          style: TextStyle( fontFamily: 'exar',
                                            color: Color(0xFF000000),
                                          ),
                                        ),
                                        Text( status.patientage,
                                          style: const TextStyle( fontFamily: 'exar',
                                            color:AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 5),
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        const Text("الجنس: ",
                                          style: TextStyle( fontFamily: 'exar',
                                            color: Color(0xFF000000),
                                          ),),
                                        Text(gender,
                                          style: const TextStyle( fontFamily: 'exar',
                                            color:AppColors.primaryColor,
                                          ),),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              child:         Row(
                                children: [
                                  Container(

                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width/2-50,
                                    margin: const EdgeInsets.only(right: 5),

                                    child:  const Text(" المدينة: " ,
                                      style: TextStyle( fontFamily: 'exar',
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width/2-20,
                                    child: Text(city.name,
                                      style: const TextStyle( fontFamily: 'exar',
                                        color:AppColors.primaryColor,
                                      ),),
                                  ),

                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              child:         Row(
                                children: [
                                  Container(

                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width/2-50,
                                    margin: const EdgeInsets.only(right: 5),

                                    child:  const Text(" الموقع " ,
                                      style: TextStyle( fontFamily: 'exar',
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width/2-20,
                                    child: Text(status.patientlocation,
                                      style: const TextStyle( fontFamily: 'exar',
                                        color:AppColors.primaryColor,
                                      ),),
                                  ),


                                ],
                              ),
                            ),

                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              child:         Row(
                                children: [
                                  Container(

                                    alignment: Alignment.centerRight,
                                    width: MediaQuery.of(context).size.width/2-50,
                                    margin: const EdgeInsets.only(right: 5),

                                    child:  const Text(" الهاتف " ,
                                      style: TextStyle(
                                        color: Color(0xFF000000), fontFamily: 'exar',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    alignment: Alignment.centerLeft,
                                    width: MediaQuery.of(context).size.width/2-20,
                                    child:     ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0, backgroundColor: Colors.transparent,
                                        padding: EdgeInsets.zero ,
                                        shadowColor: Colors.transparent,
                                        // onPrimary: Color(0xFF9267DD),
                                      ),
                                      onPressed: () => launch("tel://${status.patientphone}"),
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          const Icon(Icons.phone,
                                          color:AppColors.primaryColor,),
                                          Text(status.patientphone,
                                            style: const TextStyle( fontFamily: 'exar',
                                              color:AppColors.primaryColor,
                                            ),),
                                        ],
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                            ),
                            Container(

                              child: Column(
                                children: [
                                  Container(

                                    alignment: Alignment.center,

                                    child: const Text(" مشاكل صحية اخرى ",
                                      style: TextStyle(
                                        color: Color(0xff0000000), fontFamily: 'exar',
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
                                      controller: others,
                                      textAlign: TextAlign.right,

                                      decoration: const InputDecoration(
                                        filled: true,
                                        focusColor: Color(0xFF000000),
                                        hoverColor: Color(0xFF000000),
                                        fillColor: Color(0x00ffffff),
                                        hintStyle: TextStyle( fontFamily: 'exar',
                                            fontSize: 15.0, color: Color(0xFF000000)),

                                        border: UnderlineInputBorder(),
                                        hintText: "ادخل معلومات عن مشاكل عامة ",
                                      ),

                                    ),
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
       Row(
         children: [
           SizedBox(
             width: screenWidth/3-10,
             height: 60,
             child: TextButton(
               style: TextButton.styleFrom(
               foregroundColor: AppColors.primaryColor, shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.zero)),
                 padding: const EdgeInsets.symmetric(
                     horizontal: 40.0, vertical: 20.0),
                 backgroundColor:  Colors.white,
               ),
               onPressed: () {
                 saveddata();
               },
               child: const Text(' حفظ',
               style: TextStyle(
                 fontFamily: 'exar',
               ),),
             ),
           ),
           SizedBox(
             width: screenWidth/3+20,
             height: 60,
             child: TextButton(
               style: TextButton.styleFrom(
                 // maximumSize: Size(screenWidth, 70),
                 foregroundColor: Colors.white, shape: const RoundedRectangleBorder(
                     borderRadius: BorderRadius.all(Radius.zero)),
                 padding: const EdgeInsets.symmetric(
                     horizontal: 5.0, vertical: 20.0),
                 backgroundColor:  AppColors.primaryColor,
               ),
               onPressed: () {
                 endbookingdialog(context);
               },
               child: const Text('تغيير الحالة',style: TextStyle(
                 fontFamily: 'exar',
               ),),
             ),
           ),
           SizedBox(
             width: screenWidth/3-10,
             height: 60,
             child: TextButton(
               style: TextButton.styleFrom(
                 // maximumSize: Size(screenWidth, 70),
                 foregroundColor: AppColors.primaryColor, shape: const RoundedRectangleBorder(
                     borderRadius: BorderRadius.all(Radius.zero)),
                 padding: const EdgeInsets.symmetric(
                     horizontal: 40.0, vertical: 20.0),
                 backgroundColor:  Colors.white,
               ),
               onPressed: () {
                 cancelbookingdialog(context);
               },
               child: const Text('الغاء',style: TextStyle( fontFamily: 'exar',),),
             ),
           )
         ],
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
      print("account id$accountid");
      Map datatype = data[0];
      List<dynamic> dintistlist = datatype['Dentist'];
      setState(() {
        for (var element in dintistlist) {
          print("add to areas $element");

          if (element["id"] == accountid) {
            if( element["years"] =='primary'){
              reservstat=false;
            }
          }

        }
        notes.text=status.notes;
        treatment.text=status.treatment;
        dateController.text=status.datetreatment;
        others.text=status.patientother;
      });



      // print("statuseslist"+_laststatus.length.toString());


      if(status.patientgender=="f"){
        gender="انثى";
      }else{
        gender="ذكر";
      }
      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in cities) {
          print("add to areas $element");

          if(int.parse(status.patientcity)==element['id']){
            city.id=element['id'];
            city.name=  element['name'] ?? "";
          }

        }
      });
      print("add to patient ${status.patientname}");
      setState((){
        if(status.type=="general"){

          statustype="عامة";

        }else{
          statustype="خاصة";
        }
        if(status.status=="waiting"){

          statte="عامة";

        }
        if(status.status=='accept'){
          statte='جاري التواصل';
        }
        if(status.status=='accepttreat'){
          statte=' تحت العلاج';
        }
        if(status.status=="cancel"){
          statte="ملغية";
        }
        if(status.status=="end"){
          statte="مكتملة";
        }
      });
      setState(() {

        progressstatus=false;
      });
      var response=await CallApi().getallData("getstatus/tooth_image/${status.id}");
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
                              child: Text('هل ترغب بحجز هذه الحالة؟ ',
                              style: TextStyle( fontFamily: 'exar',),),
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
                            onTap: ()  async {

                              var data={
                                'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
                                'dentist':accountid,
                                'status':status.id,


                              };
                              var response=await CallApi().postData(data,'booking/status');
                              print('respone :  ${response.body}');
                              var body=json.decode(response.body);

                              if(body.toString()==""){
                                print('respone ssssssssssss ');
                                showfaildialog(context);
                              }
                              else {
                                int bookingstatnum= 0;

                                if (body['success'] == true) {
                                  setState(() {
                                    bookingstatnum = body['statusreserv'] ?? "0";

                                  });
                                  SharedPreferences prefsssss = await SharedPreferences
                                      .getInstance();
                                  prefsssss.setInt("totalsavestat", bookingstatnum);
                                  showsuccessdialog(context);
                                }else{
                                  showfaildialog(context);
                                }
                              }
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
  void endbookingdialog(BuildContext context) {

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
                              child: Text('يمكنك تغيير الحالة الى '),
                            ),

                          ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 15.0, bottom: 15.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,

                                ),
                                child: const Text(
                                  "مكتملة",
                                  style: TextStyle(
                                      color: AppColors.primaryColor, fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onTap: ()  async {

                                var data={
                                  'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
                                  'dentist':accountid,
                                  'type':'end',
                                  'status':status.id,


                                };
                                var response=await CallApi().postData(data,'edit/status');
                                print('respone dddddddd:  ${response.body}');
                                var body=json.decode(response.body);

                                if(body.toString()==""){
                                  print('respone ssssssssssss ');
                                  Navigator.of(dialogContext).pop();
                                  showfaildialog(context);
                                }
                                else {
                                  setState((){
                                    edit=true;
                                  });
                                  if (body['success'] == true) {
                                    Navigator.of(dialogContext).pop();
                                   endshowsuccessdialog(context);
                                  }else{
                                    Navigator.of(dialogContext).pop();
                                    showfaildialog(context);
                                  }

                                }


                              },
                            ),
                            InkWell(
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 15.0, bottom: 15.0),
                                decoration: const BoxDecoration(
                                  color: Colors.white,

                                ),
                                child: const Text(
                                  "تحت العلاج",
                                  style: TextStyle(
                                      color: AppColors.primaryColor, fontSize: 20.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              onTap: ()  async {
                                var data={
                                  'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
                                  'dentist':accountid,
                                  'type':'accepttreat',
                                  'status':status.id,


                                };
                                var response=await CallApi().postData(data,'edit/status');
                                print('respone dddddddd:  ${response.body}');
                                var body=json.decode(response.body);

                                if(body.toString()==""){
                                  print('respone ssssssssssss ');
                                  Navigator.of(dialogContext).pop();
                                  showfaildialog(context);
                                }
                                else {
                                  setState((){
                                    edit=true;
                                  });
                                  if (body['success'] == true) {
                                    Navigator.of(dialogContext).pop();
                                    showsuccessdialog(context);
                                  }else{
                                    Navigator.of(dialogContext).pop();
                                    showfaildialog(context);
                                  }

                                }
                              },
                            ),

                          ],
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

  Future<void> bookstate() async {
    SharedPreferences shpref= await SharedPreferences.getInstance();
    int totalsavestat = shpref.getInt('totalsavestat') ?? 0;
    int accountid = shpref.getInt('accountid') ?? 0;
    String datastring = shpref.getString('data') ?? "";
    print('datastring$datastring');

    data = json.decode(datastring);
    Map datatype=data[0];
    List<dynamic> dentists = datatype['Dentist'];
    bool allowbooking=false;
    setState(() {
      for (var element in dentists) {
        print("add to areas $element");
        if(element['id']==accountid){
          if(element['type']=='normal')
            if(int.parse(element['statusreserv'])<3){
              allowbooking=true;
            }
          if(element['type']=='medium')
            if(int.parse(element['statusreserv'])<5){
              allowbooking=true;
            }
          if(element['type']=='advanced') {
            allowbooking=true;
          }

        }
      }
    });
    if(allowbooking){
      showbookingdialog(context);
    }else{
      showfaildialog(context);
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
                              child: Text('فشل حفظ التعديلات',style: TextStyle(
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
  void endshowsuccessdialog(BuildContext context) {

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
                              child: Text('تم حفظ المعلومات ',
                              style: TextStyle( fontFamily: 'exar',),),
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
                                    color: AppColors.primaryColor,   fontFamily: 'exar', fontSize: 20.0),
                                textAlign: TextAlign.center,

                              ),
                            ),
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyApp()));



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
                              child: Text('تم حفظ المعلومات ',
                              style: TextStyle( fontFamily: 'exar',),),
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
  Future<void> _refreshData() async {
    try {
      var response = await CallApi().getallData('getsinglestatus/${status.id}');
      // var body=json.decode(response.body);
      var body = json.decode(utf8.decode(response.bodyBytes));
      print('respone body  ${response.body}');

      Map datatype=body[0];
      var statusnew=datatype['status'];
      var stnew=statusnew[0];
      status.notes=stnew["notes"];
      status.treatment=stnew["treatment"];
      status.datetreatment=stnew["datetreatment"];
      status.patientother=stnew["other"];
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
   getdata();
  }

  Future<void> saveddata() async {
    var body;
    int id=0;
    try{
      var data={'api_key': 'fYqUL6SU6bMJ_K4z9Nbb1TACyz1GZ7jbPgG',

        'id':status.id,
        'notes':notes.text,
        'treatment':treatment.text,
        'datetreatment':date.toString(),
        'others':others.text,

      };
      var response=await CallApi().postData(data,'save/status');
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



        showsuccessdialog(context);


      } else {
        showfaildialog(context);
      }

    }


}
  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        confirmText: "ادخال",
        cancelText: "الغاء",
        helpText: " ",
        context: context,
        initialDate: date ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary:  Color(0xFFBB7ADE),
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface:  Color(0xFFBB7ADE),
              ),
              dialogBackgroundColor: AppColors.primaryColor,
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      date = newSelectedDate;
      dateController
        ..text = DateFormat.yMMMd().format(date)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  void cancelbookingdialog(BuildContext context) {

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
                              child: Text('هل ترغب بالغاء الحالة ',
                              style:TextStyle( fontFamily: 'exar',)),
                            ),

                          ),
                          TextFormField(
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            minLines: 1,
                            maxLines: 2,
                            controller: reson,
                            textAlign: TextAlign.right,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'الرجاء ادخال الاسباب';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              filled: true,
                              focusColor:  Color(0xFF000000),
                              hoverColor: Color(0xFF000000) ,
                              fillColor: Color(0x00ffffff),
                              hintStyle: TextStyle(fontSize: 15.0, color: Color(0xFF000000)),

                              border: UnderlineInputBorder(),
                              hintText: "ادخل اسباب الالغاء",
                            ),
                          ),
                          emptyfild?Container(
                            child: const Text(
                                'الرجاء التحقق من ادخال الاسباب قبل الموافقة',
                            style:TextStyle( fontFamily: 'exar',)),
                          ):Container(
                            height: 0,
                          ),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [ InkWell(
                             child: Container(
                               padding: const EdgeInsets.only(
                                   top: 15.0, bottom: 15.0),
                               decoration: const BoxDecoration(
                                 color: Colors.white,

                               ),
                               child: const Text(
                                 "نعم",
                                 style: TextStyle(
                                     fontFamily: 'exar',
                                     color: AppColors.primaryColor, fontSize: 20.0),
                                 textAlign: TextAlign.center,
                               ),
                             ),
                             onTap: () {
                               if(reson.text!=""){
                                 Navigator.of(dialogContext).pop();
                                 _cancelData();

                               }else{
                                 setState(
                                     (){
                                       emptyfild=true;
                                     }
                                 );
                               }



                             },
                           ),
                             InkWell(
                               child: Container(
                                 padding: const EdgeInsets.only(
                                     top: 15.0, bottom: 15.0),
                                 decoration: const BoxDecoration(
                                   color: Colors.white,

                                 ),
                                 child: const Text(
                                   "لا",
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

  Future<void> _cancelData() async {
    var data={
      'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
      'dentist':accountid,
      'type':'cancel',
      'reson':reson.text,
      'status':status.id,


    };
    var response=await CallApi().postData(data,'edit/status');
    print('respone :  ${response.body}');
    var body=json.decode(response.body);
    Navigator.pop(context);
    if(body.toString()==""){
      print('respone ssssssssssss ');
      showfaildialog(context);
    }
    else {

      if (body['success'] == true) {
        setState((){
          edit=true;
        });
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()));
      }else{
        showfaildialog(context);
      }
    }

  }

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
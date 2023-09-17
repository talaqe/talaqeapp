import 'dart:convert';

import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/toothes.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/images.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_components.dart';
import 'package:talaqe/widgets/core_widgets.dart';

import '../CallApi.dart';
import '../data/alldatastatus.dart';
import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Toothinterf extends StatefulWidget{
  final Object? argument;
  Toothinterf({Key? key, this.argument}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Toothinterf();
  }


}
class _Toothinterf extends State<Toothinterf>{
  int _statid=0;
  allStatus status=allStatus(0, "", "", "","","","","","","","","","","","","","","","","","","","","");

  Typetreatment typetreatment=new Typetreatment(0, "", "");
  String _url="https://talaqe.org/storage/app/public/";
  List<Tooth> _toothes =[];

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
          leading: Center(
            child: CustomIconButtonWidget(
                hasBorder: true,
                backgroundColor: Colors.transparent,
                onTap: () {
                  Navigator.pop(context);
                },
                borderRadiusRadiusValue: AppComponents.defaultBorderRadius,
                child:   Icon(Icons.chevron_left,
                    color: Colors.white)),
          ),
        title: Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
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
                  children: [      ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      primary: Colors.transparent,
                      onPrimary: AppColors.primaryColor,
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
              ]
          ),
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
              color:  AppColors.primaryColor,


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
                child:    SingleChildScrollView(

                    child: Container(

                      child: Column(children:[
                        Text("تفاصيل الاسنان",
                          style: TextStyle( fontFamily: 'exar',
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

    ); }


  Future<void> getdata() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('tooth_image') ?? "";
    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
      });
      print("account id" + accountid.toString());
      print("stat id" + data.toString());
      Map datatype = data[0];
      print("stat id" + datatype.toString());





      List<dynamic> toothes = datatype['tooths'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        toothes.forEach((element) {

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

        });
      });

    }
      }
  Widget getlaststatuslist() {
    List<Widget> list = [];

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
                                 children: [
                                   Container(
                                     margin: EdgeInsets.only(right: 5),

                                     child: Text(" مكان السن: ",
                                     style: TextStyle( fontFamily: 'exar',
                                       color: Color(0xFF000000),
                                     ),
                                 ),
                                   ),
                                   Container(
                                     child: Text(element.tothplace,
                                       style: TextStyle( fontFamily: 'exar',
                                         color:AppColors.primaryColor,
                                       ),
                                     ),
                                   ),
                                 ],
                              ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                     Container(
                                       margin: EdgeInsets.only(right: 0),

                                       child:  Text("رقم السن: ",
                                         style: TextStyle( fontFamily: 'exar',
                                           color: Color(0xFF000000),
                                         ),),
                                     ),
                                      Container(
                                        child: Text(element.toothnumber,
                                          style: TextStyle( fontFamily: 'exar',
                                            color: AppColors.primaryColor,
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

                      child:         Column(
                        children: [
                          Container(

                            child:  Text(" ملاحظات " ,
                              style: TextStyle( fontFamily: 'exar',
                                color: Color(0xFF0000000),
                              ),
                            ),
                            alignment: Alignment.centerRight,

                          ),
                          Container(

                            child: Text(element.notes ,
                              style: TextStyle( fontFamily: 'exar',
                              color: AppColors.primaryColor,
                            ),),
                            alignment: Alignment.center,
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
              )
          );

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
        style:TextStyle( fontFamily: 'exar',)),
      );
    }
  }
      }
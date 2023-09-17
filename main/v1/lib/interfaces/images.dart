import 'dart:convert';

import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/scans.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/toothes.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_components.dart';
import 'package:talaqe/widgets/core_widgets.dart';

import '../CallApi.dart';
import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Imageinterfac extends StatefulWidget{

  final Object? argument;
  Imageinterfac({Key? key, this.argument}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _Imageinterfac();
  }


}
class _Imageinterfac extends State<Imageinterfac>{
  allStatus status=allStatus(0, "", "","", "","","","","","","","","","","","","","","","","","","","");

  String _url="https://talaqe.org/storage/app/public/";
  List<Scans> _scans =[];
  int numimage=-1;
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
        title:     Container(
          margin: EdgeInsets.only(top: 15),
          color: AppColors.primaryColor,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          SizedBox(height:25),
                          Text(' المريض:',
                              style:TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, fontFamily: 'exar',
                                  fontSize: 17.0)),
                          SizedBox(width:10),
                          Text( status.patientname,
                              style:TextStyle( fontFamily: 'exar',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17.0)),
                        ]
                    ),

                  ],
                ),

              ]
          ),
        ),
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
                child:  SingleChildScrollView(

                    child: Stack(children:[
                     Container(
                       margin:EdgeInsets.only(top: 0),
                       alignment: Alignment.center,
                       child:  Text("صور الاشعة",
                         style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                             fontFamily: 'exar',
                             color:AppColors.primaryColor
                         ),
                       ),
                     ),
                      Container(
                          margin:EdgeInsets.only(top: 30),
                          child:         getlaststatuslist(context),
                      ),


                    ])
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

      List<dynamic> datatype = json.decode(datastring);
      var data1 = datatype[0];
      print("data" + data1.toString());



      List<dynamic> scans = data1['scans'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        scans.forEach((element) {

              _scans.add(
                  Scans(
                      element['id'],
                      element['patientid'] ?? "",
                      element['image'] ?? "",
                      element['created_at'] ?? ""

                  ));


        });
      });


    }
  }
  Widget getlaststatuslist(BuildContext context) {
    List<Widget> list = [];

    _scans.forEach((element) {

      String result = element.created_at.substring(
          0, element.created_at.indexOf('T'));
      numimage=numimage+1;
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
            child:  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(" تاريخ الإضافة : ",
                    style: TextStyle( fontFamily: 'exar',
                      color: Color(0xFF000000),
                    ),
                  ),
                    Text(result,
                      style: TextStyle( fontFamily: 'exar',
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white
                      ),
                      alignment: Alignment.center,
                      child: FadeInImage(
                        image: NetworkImage(_url + element.image),
                        // height: 200,
                        fit: BoxFit.cover,
                         width: MediaQuery
                             .of(context)
                             .size
                             .width-70 ,
                        height: 250,
                        placeholder: AssetImage('asset/im.png'),
                      ),


                    ),

                  ],
                ),
              ],
            ),
                ),


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
        child: Text('لاتتوفر صور حاليا',
          style:TextStyle( fontFamily: 'exar',)
            ),
      );
    }
  }
}
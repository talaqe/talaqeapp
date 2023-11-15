import 'dart:convert';

import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/scans.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_components.dart';
import 'package:talaqe/widgets/core_widgets.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Imageinterfac extends StatefulWidget{

  final Object? argument;
  const Imageinterfac({Key? key, this.argument}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _Imageinterfac();
  }


}
class _Imageinterfac extends State<Imageinterfac>{
  allStatus status=allStatus(0, "", "","", "","","","","","","","","","","","","","","","","","","","");

  final String _url="https://talaqe.org/storage/app/public/";
  final List<Scans> _scans =[];
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
      key: const ValueKey(6),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: AppBar(
        title:     Container(
          margin: const EdgeInsets.only(top: 15),
          color: AppColors.primaryColor,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          const SizedBox(height:25),
                          const Text(' المريض:',
                              style:TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, fontFamily: 'exar',
                                  fontSize: 17.0)),
                          const SizedBox(width:10),
                          Text( status.patientname,
                              style:const TextStyle( fontFamily: 'exar',
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
          child:   const Icon(Icons.chevron_left,
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
              margin: const EdgeInsets.only(right: 0,left: 0,top: 0,bottom: 5),
              padding: const EdgeInsets.only(top: 50,right:50,left: 50 ),
              color:  AppColors.primaryColor,


            ),


            Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 120,bottom: 5,left:0 ,right: 0),
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                ),
                child:  SingleChildScrollView(

                    child: Stack(children:[
                     Container(
                       margin:const EdgeInsets.only(top: 0),
                       alignment: Alignment.center,
                       child:  const Text("صور الاشعة",
                         style: TextStyle(
                             fontSize: 20,
                             fontWeight: FontWeight.bold,
                             fontFamily: 'exar',
                             color:AppColors.primaryColor
                         ),
                       ),
                     ),
                      Container(
                          margin:const EdgeInsets.only(top: 30),
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
      print("account id$accountid");

      List<dynamic> datatype = json.decode(datastring);
      var data1 = datatype[0];
      print("data$data1");



      List<dynamic> scans = data1['scans'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in scans) {

              _scans.add(
                  Scans(
                      element['id'],
                      element['patientid'] ?? "",
                      element['image'] ?? "",
                      element['created_at'] ?? ""

                  ));


        }
      });


    }
  }
  Widget getlaststatuslist(BuildContext context) {
    List<Widget> list = [];

    for (var element in _scans) {

      String result = element.created_at.substring(
          0, element.created_at.indexOf('T'));
      numimage=numimage+1;
      list.add(
          Container(
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
            child:  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(" تاريخ الإضافة : ",
                    style: TextStyle( fontFamily: 'exar',
                      color: Color(0xFF000000),
                    ),
                  ),
                    Text(result,
                      style: const TextStyle( fontFamily: 'exar',
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Container(
                      decoration: const BoxDecoration(
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
                        placeholder: const AssetImage('asset/im.png'),
                      ),


                    ),

                  ],
                ),
              ],
            ),
                ),


      );

    }

    if(list.isNotEmpty) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom:0, right: 0, left: 0),

        child: Column(
            children: list
        ),
      );
    }else{
      return const Center(
        child: Text('لاتتوفر صور حاليا',
          style:TextStyle( fontFamily: 'exar',)
            ),
      );
    }
  }
}
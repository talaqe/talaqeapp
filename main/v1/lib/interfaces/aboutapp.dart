import 'dart:convert';

import 'package:talaqe/data/Policies.dart';
import 'package:talaqe/utils/constants/app_colors.dart';

import '../CallApi.dart';
import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _About();
  }


}
class _About extends State<AboutApp>{
  List<dynamic> data=[];
  List<Policy> _plicies=[] ;
  @override
  void initState() {
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
        backgroundColor: Colors.white,
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
            Text("حول التطبيق",style: TextStyle(  color: Color(0xFFFFFFFF),
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
                  child: Container(
                    margin: EdgeInsets.only(top: 60.0,left: 0.0,right: 0.0,bottom: 0.0),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Image.asset('asset/logo.png',height: 150,),

                        getpolices()
                        ],
                      ),
                    ),))
      )
            ],
          ),


          //Text(widget.title)
        );
      }

  Future<void> getdata() async {
    //Policy
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";
    if (datastring != "") {
      data = json.decode(datastring);
      Map datatype=data[0];
      var about=datatype['About'];
      Map datatypeabout=about[0];
      List<dynamic> policess = datatype['Policiesapp'];
      print('respone about  ' + datatypeabout['textappcheck'].toString());

      setState(() {
        policess.forEach((element) {
          print("add to areas " + element.toString());

          _plicies.add(
              Policy(element['id'], element['title'] ?? "",
                  element['text'] ?? ""));
        });
      });
    }
  }

  getpolices() {
    List <Widget> list=[];
    setState(() {
     _plicies.forEach((element) {
       list.add(ListTile(
         leading: Icon(Icons.text_snippet_rounded),
         title: Text(element.title, style: TextStyle(
           fontFamily: 'exar',
         ),),
         subtitle: Text(element.text,
           style: TextStyle(
             fontFamily: 'exar',
           ),),));
     });
    });
    return
      SingleChildScrollView(
        child: Column(
          children:list,
        ),
      );
  }
}
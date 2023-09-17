import 'dart:convert';

import 'package:talaqe/interfaces/login.dart';
import 'package:talaqe/interfaces/showprotifolio.dart';
import 'package:talaqe/main.dart';
import 'dart:io' show Platform;

import 'interfaces/index.dart';
import 'interfaces/aboutapp.dart';
import 'interfaces/addstatus_screan.dart';
import 'interfaces/contact_screen.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class NavDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return _NavDrawer();
  }

}
class _NavDrawer extends State<NavDrawer>{

  String sharelink="";

  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.white,
      width:  MediaQuery.of(context).size.width * 0.6,
      child: Drawer(
backgroundColor: Colors.white,
        child: ListView(

          padding: EdgeInsets.zero,
          children: <Widget>[
           Container(
             margin: EdgeInsets.only(top: 40,left: 10,right: 10),
               height: 100.0,

              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('asset/logo.png'))
              ),
           ),

            ListTile(
              leading: Icon(Icons.input,color: Color(0xFF2A0E56),),
              title: Text('الرئيسية',style: TextStyle(
                color: Color(0xFF2A0E56),
                fontFamily: 'exar',

              ),),
                onTap: () {
                  Route route = MaterialPageRoute(builder: (context) => Index());
                  Navigator.pushReplacement(context, route);
                }
            ),
            ListTile(
                leading: Icon(Icons.supervised_user_circle,color: Color(0xFF2A0E56),),
                title: Text('شروط الإستخدام',style: TextStyle(
                    fontFamily: 'exar',
                    color: Color(0xFF2A0E56)),),
                onTap: () => {

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutApp()) )
                }
            ),




            ListTile(
                leading: Icon(Icons.work,color: Color(0xFF2A0E56),),
                title: Text('معرض الأعمال',style: TextStyle(
                    fontFamily: 'exar',
                    color: Color(0xFF2A0E56)),),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShowProtifolio()) ) }
            ),
            ListTile(
              leading: Icon(Icons.share,color: Color(0xFF2A0E56),),
              title: Text('مشاركة التطبيق',style: TextStyle(
                  fontFamily: 'exar',
                  color: Color(0xFF2A0E56)),),
              onTap: ()  {
              // Navigator.of(context).pop();
                startshare();
              },
            ),
            ListTile(
              leading: Icon(Icons.logout,color: Color(0xFF2A0E56),),
              title: Text('تسجيل الخروج',style: TextStyle(
                  fontFamily: 'exar',
                  color: Color(0xFF2A0E56)),),
              onTap: ()  {
                // Navigator.of(context).pop();
                logout();
              },
            ),


            Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.center,
             children:  <Widget>[
               // IconButton(icon: FaIcon(FontAwesomeIcons.facebook,color: AppColors.primaryColor,), onPressed: (){
               //   _launchURLfacbook();
               // }),
               // SizedBox(width: 20.0,),
               // IconButton(icon: FaIcon(FontAwesomeIcons.instagram,color: AppColors.primaryColor,), onPressed: (){
               //   _launchURLinstagram();
               // }),
             ],
           )
          ],
        ),
      ),
    );
  }
  Future<void> startshare () async {
    // Share.share('بامكانك تحميل تطبيق تلاقي من المتاجر الالكترونية  $sharelink', subject: '!');
  }




  Future<void> getdata() async {
//     SharedPreferences prefsssss = await SharedPreferences.getInstance();
//
//     String data_ads= prefsssss.getString('data');
//     Map ads_data=json.decode(data_ads);
//     List<dynamic> applink=ads_data['applink'];
//     // print('adss '+sub_parts.toString());
//     applink.forEach((element) {
//
// if(Platform.isAndroid){
//   setState(() {
//     sharelink=element['googleplay'];
//   });
// }else{
//   setState(() {
//     sharelink=element['applestore'];
//   });
// }


    // });
  }


  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Route route = MaterialPageRoute(builder: (context) => MyApp());
    Navigator.pushReplacement(context, route);
  }



}
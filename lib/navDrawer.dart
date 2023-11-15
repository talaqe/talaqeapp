
import 'package:talaqe/interfaces/showprotifolio.dart';
import 'package:talaqe/main.dart';

import 'interfaces/index.dart';
import 'interfaces/aboutapp.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

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
             margin: const EdgeInsets.only(top: 40,left: 10,right: 10),
               height: 100.0,

              decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('asset/logo.png'))
              ),
           ),

            ListTile(
              leading: const Icon(Icons.input,color: Color(0xFF2A0E56),),
              title: const Text('الرئيسية',style: TextStyle(
                color: Color(0xFF2A0E56),
                fontFamily: 'exar',

              ),),
                onTap: () {
                  Route route = MaterialPageRoute(builder: (context) => const Index());
                  Navigator.pushReplacement(context, route);
                }
            ),
            ListTile(
                leading: const Icon(Icons.supervised_user_circle,color: Color(0xFF2A0E56),),
                title: const Text('شروط الإستخدام',style: TextStyle(
                    fontFamily: 'exar',
                    color: Color(0xFF2A0E56)),),
                onTap: () => {

                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutApp()) )
                }
            ),




            ListTile(
                leading: const Icon(Icons.work,color: Color(0xFF2A0E56),),
                title: const Text('معرض الأعمال',style: TextStyle(
                    fontFamily: 'exar',
                    color: Color(0xFF2A0E56)),),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShowProtifolio()) ) }
            ),
            ListTile(
              leading: const Icon(Icons.share,color: Color(0xFF2A0E56),),
              title: const Text('مشاركة التطبيق',style: TextStyle(
                  fontFamily: 'exar',
                  color: Color(0xFF2A0E56)),),
              onTap: ()  {
              // Navigator.of(context).pop();
                startshare();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout,color: Color(0xFF2A0E56),),
              title: const Text('تسجيل الخروج',style: TextStyle(
                  fontFamily: 'exar',
                  color: Color(0xFF2A0E56)),),
              onTap: ()  {
                // Navigator.of(context).pop();
                logout();
              },
            ),


            const Row(
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
    Route route = MaterialPageRoute(builder: (context) => const MyApp());
    Navigator.pushReplacement(context, route);
  }



}
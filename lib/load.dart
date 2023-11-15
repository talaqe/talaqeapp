import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/CallApi.dart';
import 'dart:convert';

import 'package:talaqe/utils/constants/app_images.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
// import 'CallApi.dart';
class Load extends StatefulWidget{
  const Load({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Load();
  }

}
class _Load extends State<Load>{






  @override
  void initState() {
    _delayAndGotoNextScreen();

    // TODO: implement initState
    super.initState();
  }


  Future<void> _delayAndGotoNextScreen() async {

    SharedPreferences shpref;
    try {
      shpref = await SharedPreferences.getInstance();
    }catch(e){
      SharedPreferences.setMockInitialValues({});
      shpref = await SharedPreferences.getInstance();

    }
    var response=await CallApi().getallData('alldata');
    // var body=json.decode(response.body);
    var  body = json.decode(utf8.decode(response.bodyBytes));
    print('respone alldata  $body');
    shpref.setString('data', utf8.decode(response.bodyBytes).toString());
    shpref.setString('search', "");


    await Future.delayed(const Duration(seconds: 2));
    // In case, the screen is not shown after 2 seconds, Do nothing.
    if (!mounted) return;
    // Go to intro screen
    Navigator.pushNamedAndRemoveUntil(
        context, AppPageNames.introScreen, (_) => false);
  }

  @override
  void dispose() {
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* <-------- Content --------> */
      // backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /* <----- App logo -----> */
            Image.asset(AppAssetImages.logo, height: 120, width: 120),

            /* <---- App name text ----> */
            Image.asset(AppAssetImages.talaqeText, width: 200),

          ],
        ),
      ),
    );
  }



}
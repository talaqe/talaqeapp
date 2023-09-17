import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/interfaces/signup.dart';

import '../fail.dart';
import '../CallApi.dart';
import 'index.dart';

class Active extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ActiveWidgetState();
  }

}



class _ActiveWidgetState extends State<Active> {
  String link = "https://talaqe.org/api";

  bool showProgress = false;


  @override
  initState() {
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
    print('width/height $screenWidth / $screenHeight');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        body: Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
          ),
          child: Center(
            child: SingleChildScrollView(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.only(bottom: 80),
                    decoration: BoxDecoration(
                      color: Color(0xFAFAFA),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset("asset/logo.png",
                      fit: BoxFit.fill,
                      width: 250,
                    ),
                  ),
                 Container(
                   padding: EdgeInsets.all(40),
                   child: Text(
                     " الرجاء الانتظار حتى تقوم الادارة بالموافقة على تفعيل الحساب الخاص بك",
                   textAlign: TextAlign.center,
                   style: TextStyle( fontFamily: 'exar',),),
                 )
                ],
              ),


            ),
          ),
        ),
      ),
    );
  }
}
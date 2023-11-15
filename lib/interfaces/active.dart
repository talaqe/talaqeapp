
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class Active extends StatefulWidget {
  const Active({super.key});


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
        body: Container(
          decoration: const BoxDecoration(
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
                    padding: const EdgeInsets.only(bottom: 80),
                    decoration: const BoxDecoration(
                      color: Color(0x00fafafa),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset("asset/logo.png",
                      fit: BoxFit.fill,
                      width: 250,
                    ),
                  ),
                 Container(
                   padding: const EdgeInsets.all(40),
                   child: const Text(
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
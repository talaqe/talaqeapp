
import 'package:talaqe/utils/constants/app_components.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';

import 'package:flutter/material.dart';

class NeedloginScrean extends StatefulWidget{
  const NeedloginScrean({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NeedloginScrean();
  }


}
class _NeedloginScrean extends State<NeedloginScrean>{

  @override
  void initState() {
    // TODO: implement initState

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
      key: const ValueKey(6),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: AppBar(
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
        title: Container(
          margin: const EdgeInsets.only(top: 10),

        ),
        backgroundColor:Colors.transparent ,
        elevation: 0,
      ),
      body:Container(

        margin: const EdgeInsets.only(top: 100),
        child: Column(
          children: <Widget>[
            Image.asset('asset/logo.png',height: 150,),

            const Text("قم بانشاء حساب لتتمكن من الاستفادة من باقي خدماتنا"),
            CustomStretchedTextButtonWidget(
                buttonText: 'انشاء حساب',
                onTap: () {
                  Navigator.pushNamed(
                      context, AppPageNames.signInOrSignUpScreen);
                }),
          ],
        ),
      ),
    );



      }



}
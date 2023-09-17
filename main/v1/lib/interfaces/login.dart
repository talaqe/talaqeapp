import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/interfaces/signup.dart';
import 'package:talaqe/main.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_gaps.dart';
import 'package:talaqe/utils/constants/app_images.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';

import '../fail.dart';
import '../CallApi.dart';
import 'active.dart';
import 'index.dart';

class Loginapp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginWidgetState();
  }

}



class _LoginWidgetState extends State<Loginapp> {
  String link = "https://talaqe.org/api";

  bool showProgress = false;

  bool hidePassword = true;

  TextEditingController phone = new TextEditingController();
  TextEditingController password = new TextEditingController();


  @override
  initState() {
    super.initState();
  }
  Future<void> senddata(BuildContext context) async {
    setState(() {
      showProgress=true;
    });
    var data={
      'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
      'phone':phone.text,
      'password':password.text,


    };
    var response=await CallApi().postData(data,'login/dentist');
    print('respone ssssssssssss :  '+response.body.toString());

    var body=json.decode(response.body);

    if(body.toString()==""){
      print('respone ssssssssssss ');
      showfaildialog(context);
    }
    else {

      int id=0;
      String active="notactive";
      String yearss="primary";
      String image="primary";
      if (body['success'] ==true) {
        setState(() {
          id = body['id'] ?? "0";
          active = body['active'] ?? "notactive";
          yearss = body['years'] ?? "primary";
          image = body['image'] ?? "";

        });
        SharedPreferences prefsssss = await SharedPreferences.getInstance();
        print("accountidddd"+id.toString());
        prefsssss.setInt("accountid", id);
        prefsssss.setString("yearss", yearss);
        prefsssss.setString("imagedintest", image);

        if(active=="active"){

         prefsssss.setString("active", active);
         Navigator.pushNamedAndRemoveUntil(
             context, AppPageNames.homeNavigatorScreen, (_) => false);

       }else{

          Route route = MaterialPageRoute(builder: (context) => Active());
          Navigator.pushReplacement(context, route);


       }
        setState(() {
          showProgress = false;
        });


      } else {
        showfaildialog(context);

        setState(() {
          showProgress = false;
        });
      }

    }
    setState(() {
      showProgress=false;
    });
  }
  void showfaildialog(BuildContext context) {
    setState(() {
      showProgress = false;
    });
    showDialog<void>(
        context: context,
        // barrierDismissible: barrierDismissible,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: Container(
                margin: EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(top: 0.0, right: 0.0),
                      decoration: BoxDecoration(
                          color: Colors.white,


                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 0.0,
                              offset: Offset(0.0, 0.0),
                            ),
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[


                          Container(
                            margin: EdgeInsets.all(20.0),
                            child: Center(
                              child: Text('فشل تسجيل الدخول . الرجاء التحقق من الرقم واعادة المحاولة',
                              style:TextStyle( fontFamily: 'exar',)),
                            ),

                          ),

                          InkWell(
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,

                              ),
                              child: Text(
                                "متابعة",
                                style: TextStyle( fontFamily: 'exar',
                                    color: Color(0xFF334541), fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(dialogContext).pop();

                            },
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(dialogContext).pop();

                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: Color(0xFF6F1CE6),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* <-------- Content --------> */
      body: CustomScaffoldBodyWidget(
          child: SafeArea(
            top: true,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /* <----- App logo -----> */
                      Image.asset(AppAssetImages.logo, height: 63.49),
                      AppGaps.hGap20,
                      /* <---- App name text ----> */
                      Image.asset(AppAssetImages.talaqeText, width: 200),

                      AppGaps.hGap60,
                      /* <----- Email text field -----> */
                      CustomTextFormField(
                        controller: phone,
                        labelPrefixIcon: SvgPicture.asset(
                            AppAssetImages.phoneCallingIconSVG,
                            color: AppColors.secondaryFontColor),
                        labelText: 'رقم الهاتف',
                         hintText: 'ادخل رقم الهاتف',
                      ),
                      AppGaps.hGap30,
                      /* <----- Password text field -----> */
                      CustomTextFormField(
                        isPasswordTextField: hidePassword,
                        labelPrefixIcon: SvgPicture.asset(
                            AppAssetImages.lockIconSVG,
                            color: AppColors.secondaryFontColor),
                        labelText: 'كلمة السر',
                        hintText: 'ادخل كلمة السر  ',
                        controller: password,

                        suffixIcon: IconButton(
                            padding: const EdgeInsets.only(bottom: 10),
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            // Toggles hide password
                            onPressed: () =>
                                setState(() => hidePassword = !hidePassword),
                            icon: SvgPicture.asset(
                              AppAssetImages.eyeIconSVG,
                              width: 22,
                              color: hidePassword
                                  ? AppColors.secondaryFontColor
                                  : AppColors.primaryColor,
                            )),
                      ),
                      AppGaps.hGap40,
                      CustomStretchedTextButtonWidget(
                          buttonText: ' تسجيل الدخول',
                          onTap: () {
                            senddata(context);
                          }),

                      AppGaps.hGap50,

                   /* <----- Social login button row -----> */

                    ]),
              ),
            ),
          )),
      /* <-------- Bottom bar --------> */
      bottomNavigationBar: CustomScaffoldBottomBarWidget(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('لاتملك حساب ؟ ',
                  style: TextStyle(color: AppColors.secondaryFontColor)),
              AppGaps.wGap3,
              /* <----- 'Create account' text button -----> */
              CustomTightTextButtonWidget(
                  onTap: () {
                    Navigator.pushNamed(context, AppPageNames.signUpScreen);
                  },
                  child: const Text('انشأ حساب الان '))
            ],
          )),
    );
  }

}
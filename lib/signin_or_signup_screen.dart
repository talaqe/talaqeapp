import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';

import 'package:flutter/material.dart';
import 'package:talaqe/widgets/core_widgets.dart';

class SignInOrSignUpScreen extends StatelessWidget {
  const SignInOrSignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* <-------- Content --------> */
      body: CustomScaffoldBodyWidget(
          child: Padding(
        padding: const EdgeInsets.all(30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /* <----- App logo -----> */
                      Image.asset(AppAssetImages.logo, height: 88.92),
                      AppGaps.hGap20,
                      /* <---- App name text ----> */
                      Image.asset(AppAssetImages.talaqeText, width: 200),

                      AppGaps.hGap120,
                      Text(
                        'اضغط للمتابعة',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      AppGaps.hGap50,
                      CustomStretchedTextButtonWidget(
                          buttonText: 'تسجيل الدخول',
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppPageNames.signUpScreen);
                          }),
                      AppGaps.hGap20,
                      CustomStretchedTextButtonWidget(
                          backgroundColor: Colors.white,
                          hasBorder: true,
                          color: AppColors.primaryColor,

                          buttonText: 'انشاء حساب',
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppPageNames.signInScreen);
                          }),
                      TextButton(
                          onPressed: () {
                            getdatawithoutlogin(context);
                          },
                          child: const Text('تخطي',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.secondaryFontColor)))
                    ],
                  ),
                ),
                AppGaps.hGap30,
              ],
            ),
          ),
        ),
      )),
    );
  }

  Future<void> getdatawithoutlogin(BuildContext context) async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    prefsssss.setInt("accountid", 0);
    prefsssss.setInt("citiesss", 2);
    prefsssss.setString("yearss", "primary");
    prefsssss.setString("imagedintest", "");
    Navigator.pushNamedAndRemoveUntil(
        context, AppPageNames.homeNavigatorScreen, (_) => false);
  }
}

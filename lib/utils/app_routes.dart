
import 'package:flutter/material.dart';
import 'package:talaqe/interfaces/active.dart';
import 'package:talaqe/interfaces/add_patient_screan.dart';
import 'package:talaqe/interfaces/addstatus_screan.dart';
import 'package:talaqe/interfaces/contact_screen.dart';
import 'package:talaqe/interfaces/detail_product_screen.dart';
import 'package:talaqe/interfaces/edit_images_products_screan.dart';
import 'package:talaqe/interfaces/edit_images_screan.dart';
import 'package:talaqe/interfaces/edit_product_screen.dart';
import 'package:talaqe/interfaces/edit_tooth_Screan.dart';

import 'package:talaqe/interfaces/editprotifolio_screan.dart';
import 'package:talaqe/interfaces/faqs_screen.dart';
import 'package:talaqe/interfaces/findperson_screan.dart';
import 'package:talaqe/interfaces/generalstatus/detail_patient_screen.dart';
import 'package:talaqe/interfaces/generalstatus/end_my_status_screen.dart';
import 'package:talaqe/interfaces/generalstatus/general_status_screen.dart';
import 'package:talaqe/interfaces/generalstatus/my_status_screen.dart';
import 'package:talaqe/interfaces/home.dart';
import 'package:talaqe/interfaces/home_navigator_screens/end_status_doctors_screen.dart';
import 'package:talaqe/interfaces/home_navigator_screens/home_doctors_screen.dart';
import 'package:talaqe/interfaces/home_navigator_screens/my_product_screen.dart';
import 'package:talaqe/interfaces/images.dart';
import 'package:talaqe/interfaces/login.dart';
import 'package:talaqe/interfaces/add_product_screen.dart';
import 'package:talaqe/interfaces/needloginscrean.dart';
import 'package:talaqe/interfaces/selectcity.dart';
import 'package:talaqe/interfaces/set_up_profile_screen.dart';
import 'package:talaqe/interfaces/signup.dart';
import 'package:talaqe/interfaces/tooth.dart';
import 'package:talaqe/intro_screen.dart';
import 'package:talaqe/signin_or_signup_screen.dart';

import '../load.dart';
import 'constants/app_page_names.dart';

/// This file contains app route generator
class AppRouteGenerator {
  /// This function generate routes corresponding to their pages with parameters
  /// (if used)
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final Object? argument = settings.arguments;
    switch (settings.name) {
      case AppPageNames.rootScreen:
      case AppPageNames.splashScreen:
        return MaterialPageRoute(builder: (_) =>  const Load());
      case AppPageNames.introScreen:
        return MaterialPageRoute(builder: (_) => const IntroScreen());
      case AppPageNames.signInOrSignUpScreen:
        return MaterialPageRoute(builder: (_) => const SignInOrSignUpScreen());
      case AppPageNames.signInScreen:
        return MaterialPageRoute(builder: (_) =>  const Signup());
      case AppPageNames.signUpScreen:
        return MaterialPageRoute(builder: (_) =>  const Loginapp());
      case AppPageNames.notactiveScreen:
        return MaterialPageRoute(builder: (_) =>  const Active());
      case AppPageNames.setUpCityScreen:
        return MaterialPageRoute(builder: (_) =>  const Selectcityapp());
      case AppPageNames.homeNavigatorScreen:
        return MaterialPageRoute(builder: (_) =>  const HomeNavigatorScreen());
      case AppPageNames.setUpProfileScreen:
        return MaterialPageRoute(builder: (_) => const SetUpProfileScreen());
      case AppPageNames.myStatusScreen:
        return MaterialPageRoute(builder: (_) =>  MyStatusScreen(argument: argument));
      case AppPageNames.endmyStatusScreen:
        return MaterialPageRoute(builder: (_) =>  EndMyStatusScreen(argument: argument));
      case AppPageNames.generalStatusScreen:
        return MaterialPageRoute(builder: (_) =>  GeneralStatusScreen(argument: argument));
      case AppPageNames.detailproductScreen:
        return MaterialPageRoute(builder: (_) =>  DetailproductScreen(argument: argument));
      case AppPageNames.addproductScreen:
        return MaterialPageRoute(builder: (_) =>  const AddMyproductScrean());
      case AppPageNames.detailproductScreen:
        return MaterialPageRoute(builder: (_) =>  DetailproductScreen(argument: argument));
      case AppPageNames.editproductScreen:
        return MaterialPageRoute(builder: (_) =>  EditMyproductScrean(argument: argument));
      case AppPageNames.editimagesProductScreen:
        return MaterialPageRoute(builder: (_) =>  Edit_ImageProductsScrean(argument: argument));
      case AppPageNames.toothgeneralStatusScreen:
        return MaterialPageRoute(builder: (_) =>  Toothinterf(argument: argument));
      case AppPageNames.DetailMyproductScrean:
        return MaterialPageRoute(builder: (_) =>  const MyProductScreen());
      case AppPageNames.imagesgeneralStatusScreen:
        return MaterialPageRoute(builder: (_) =>  Imageinterfac(argument: argument));
      case AppPageNames.edittoothmyStatusScreen:
        return MaterialPageRoute(builder: (_) =>  Edit_ToothScrean(argument: argument));
      case AppPageNames.detailPatientScreen:
        return MaterialPageRoute(builder: (_) =>  DetailPatientScreen(argument: argument));
      case AppPageNames.editimagesmyStatusScreen:
        return MaterialPageRoute(builder: (_) =>  Edit_ImageScrean(argument: argument));
      case AppPageNames.searchPatientScreen:
        return MaterialPageRoute(builder: (_) =>  HomeDoctorsScreen(stringfind: argument));
      case AppPageNames.editProfileScreen:
        return MaterialPageRoute(builder: (_) =>  EdittoprotifolioScrean());
      case AppPageNames.faqsScreen:
        return MaterialPageRoute(builder: (_) => const FAQsScreen());
      case AppPageNames.contactScreen:
        return MaterialPageRoute(builder: (_) =>  const ContactScreen());
      case AppPageNames.addStatusScreen:
        return MaterialPageRoute(builder: (_) =>  const AddstatusScrean());
      case AppPageNames.addPatientScreen:
        return MaterialPageRoute(builder: (_) =>  const AddpatientScrean());
      case AppPageNames.searchPersontScreen:
        return MaterialPageRoute(builder: (_) =>  const FindPersonScrean());
      case AppPageNames.endStatusScreen:
        return MaterialPageRoute(builder: (_) =>  const EndStatusDoctorsScreen());
      case AppPageNames.needloginScreen:
        return MaterialPageRoute(builder: (_) =>  const NeedloginScrean());

      default:
        // Open this page if wrong route address used
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                body: SafeArea(child: Center(child: Text('Page not found')))));
    }
  }
}

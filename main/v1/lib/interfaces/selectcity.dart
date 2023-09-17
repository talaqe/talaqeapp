import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/interfaces/signup.dart';
import 'package:talaqe/main.dart';

import '../fail.dart';
import '../CallApi.dart';
import '../utils/constants/app_constants.dart';
import 'active.dart';
import 'index.dart';

class Selectcityapp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Selectcityapp();
  }

}



class _Selectcityapp extends State<Selectcityapp> {
  String link = "https://talaqe.org/api";

  bool showProgress = false;

  List<City> _cities=[] ;

  TextEditingController phone = new TextEditingController();
  TextEditingController password = new TextEditingController();
  City _selectedcities=new City(0,"المدينة");

  List<dynamic> data=[];

  @override
  initState() {
    getData();
    super.initState();
  }
  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";
    if (datastring != "") {
      data = json.decode(datastring);

      Map datatype=data[0];
      List<dynamic> typetreatments = datatype['Typetreatment'];
      // print('respone areas  ' + data['areas'].toString());
      var about=datatype['About'];
      Map datatypeabout=about[0];
      print('respone areas  ' +datatypeabout['textappcheck'].toString());


      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        cities.forEach((element) {

          print("add to areas " + element.toString());

          _cities.add(
              City(element['id'], element['name'] ?? ""));
        });
      });

    }
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
                              child: Text('الرجاء اختيار مدينة',
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

  Future<void> senddata(BuildContext context) async {
    SharedPreferences shpref= await SharedPreferences.getInstance();
    shpref.setInt('citiesss', _selectedcities.id);
    Navigator.pushNamedAndRemoveUntil(
        context, AppPageNames.homeNavigatorScreen, (_) => false);

  }

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


                          AppGaps.hGap50,
                          CustomTextFormField(
                              isReadOnly: true,
                              labelPrefixIcon: SvgPicture.asset(
                                AppAssetImages.locationIconSVG,
                                color: AppColors.secondaryFontColor,
                                width: 12,
                              ),
                              labelText: 'المدينة',
                              hintText: _selectedcities.name,
                              suffixIcon: SizedBox(
                                height: 28,
                                child: PopupMenuButton<int>(
                                  padding: EdgeInsets.zero,
                                  position: PopupMenuPosition.under,
                                  itemBuilder: (context) {
                                    return   getarealist();
                                  },
                                  icon: SvgPicture.asset(AppAssetImages.arrowDownIconSVG,
                                      color: AppColors.secondaryFontColor, width: 12),
                                ),
                              )),
                          AppGaps.hGap20,
                          CustomStretchedTextButtonWidget(


                              buttonText: ' متابعة',
                              onTap: () {
                                if (_selectedcities.id != 0) {
                                  senddata(context);
                                } else {
                                  showfaildialog(context);
                                }
                              }),
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

  List<PopupMenuItem<int>> getarealist() {
    List<PopupMenuItem<int>> list = [];
    _cities.forEach((element) {
      print('ffff'+element.name);
      list.add( PopupMenuItem<int>(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            primary: Colors.transparent,
            onPrimary: Colors.black,
          ),
          child: Row(
            children: [
             
              Text(element.name,style:TextStyle( fontFamily: 'exar',)),
            ],
          ),

          onPressed: (){setState(() {
            _selectedcities=element;

          });
          Navigator.pop(context);
          },

        ),
      ),);
    });
    return list;

  }
}
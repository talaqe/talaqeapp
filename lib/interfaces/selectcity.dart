import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/data/cities.dart';

import '../utils/constants/app_constants.dart';

class Selectcityapp extends StatefulWidget {
  const Selectcityapp({super.key});


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Selectcityapp();
  }

}



class _Selectcityapp extends State<Selectcityapp> {
  String link = "https://talaqe.org/api";

  bool showProgress = false;

  final List<City> _cities=[] ;

  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  City _selectedcities=City(0,"المدينة");

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
      print('respone areas  ${datatypeabout['textappcheck']}');


      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in cities) {

          print("add to areas $element");

          _cities.add(
              City(element['id'], element['name'] ?? ""));
        }
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
                margin: const EdgeInsets.only(left: 0.0, right: 0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      margin: const EdgeInsets.only(top: 0.0, right: 0.0),
                      decoration: const BoxDecoration(
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
                            margin: const EdgeInsets.all(20.0),
                            child: const Center(
                              child: Text('الرجاء اختيار مدينة',
                                  style:TextStyle( fontFamily: 'exar',)),
                            ),

                          ),

                          InkWell(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 15.0, bottom: 15.0),
                              decoration: const BoxDecoration(
                                color: Colors.white,

                              ),
                              child: const Text(
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
                        child: const Align(
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
    for (var element in _cities) {
      print('ffff${element.name}');
      list.add( PopupMenuItem<int>(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Row(
            children: [
             
              Text(element.name,style:const TextStyle( fontFamily: 'exar',)),
            ],
          ),

          onPressed: (){setState(() {
            _selectedcities=element;

          });
          Navigator.pop(context);
          },

        ),
      ),);
    }
    return list;

  }
}
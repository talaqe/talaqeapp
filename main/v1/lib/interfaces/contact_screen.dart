import 'dart:convert';
import 'dart:core';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/data/settings.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:http/http.dart' as http;

import '../CallApi.dart';

  class ContactScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
  // TODO: implement createState
  return _ContactNavState();
  }

  }



  class _ContactNavState extends State<ContactScreen> {
    List<dynamic> data=[];
Setting setting=Setting( "", "");
List<Setting> _settings=[];
 final _formKey = GlobalKey<FormState>();
    @override
    void initState() {
      // TODO: implement initState
      getData();
    }
  @override
  Widget build(BuildContext context){
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return  Scaffold(
      appBar: CoreWidgets.appBarWidget(
          screenContext: context, titleWidget: const Text(' تواصل معنا')),
      body: CustomScaffoldBodyWidget(
          child: SingleChildScrollView(
              child: getsettingslist()
          )),
    );


  }

Future<void> getData() async {
  SharedPreferences prefsssss = await SharedPreferences.getInstance();
  String datastring = prefsssss.getString('data') ?? "";


  print('datastring'+datastring);

  if (datastring != "") {
    data = json.decode(datastring);

   Map datatype=data[0];
    List<dynamic> settings = datatype['Setting'];
    // print('respone areas  ' + data['areas'].toString());

    setState(() {
      settings.forEach((element) {
        print("add to areas " + element.toString());

        _settings.add(
          Setting(element['title']??"", element['link']??"")
        );
      });
    });

  }
}

  getsettingslist() {

    List<Widget> list = [];
    _settings.forEach((element) {
  bool exist=element.link.contains("http");
  if(exist==false){
    print("trueeeeeeeeeee");
    list.add(
      ListTile(

        title: Text(element.title,style: TextStyle(
          fontFamily: 'exar',
        ),),
        subtitle:    Container(
          alignment: Alignment.topLeft,
          child: Text(element.link,
            style: TextStyle(
              fontFamily: 'exar',
              color:AppColors.primaryColor,
            ),),
        ),),
    );
  }else{
    list.add(
      ListTile(

        title: Text(element.title,style: TextStyle(
          fontFamily: 'exar',
        ),),
        subtitle:     ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.zero ,
            shadowColor: Colors.transparent,
            primary: Colors.transparent,
            // onPrimary: Color(0xFF9267DD),
          ),
          onPressed: () => launch(element.link),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Text(element.link,
                style: TextStyle(
                  fontFamily: 'exar',
                  color:AppColors.primaryColor,
                ),),
            ],
          ),
        ),
      ),
    );
  }

});
    if(!list.isEmpty) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(bottom:0, right: 0, left: 0),

        child: Column(
            children: list
        ),
      );
    }else{
      return Center(
        child: Text('لاتتوفر معلومات التواصل',
        style:TextStyle(
          fontFamily: 'exar',
        )),
      );
    }
  }

}
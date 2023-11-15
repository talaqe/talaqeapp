import 'dart:convert';
import 'dart:core';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/data/settings.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';



  class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});


  @override
  State<StatefulWidget> createState() {
  // TODO: implement createState
  return _ContactNavState();
  }

  }



  class _ContactNavState extends State<ContactScreen> {
    List<dynamic> data=[];
Setting setting=Setting( "", "");
final List<Setting> _settings=[];
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


  print('datastring$datastring');

  if (datastring != "") {
    data = json.decode(datastring);

   Map datatype=data[0];
    List<dynamic> settings = datatype['Setting'];
    // print('respone areas  ' + data['areas'].toString());

    setState(() {
      for (var element in settings) {
        print("add to areas $element");

        _settings.add(
          Setting(element['title']??"", element['link']??"")
        );
      }
    });

  }
}

  getsettingslist() {

    List<Widget> list = [];
    for (var element in _settings) {
  bool exist=element.link.contains("http");
  if(exist==false){
    print("trueeeeeeeeeee");
    list.add(
      ListTile(

        title: Text(element.title,style: const TextStyle(
          fontFamily: 'exar',
        ),),
        subtitle:    Container(
          alignment: Alignment.topLeft,
          child: Text(element.link,
            style: const TextStyle(
              fontFamily: 'exar',
              color:AppColors.primaryColor,
            ),),
        ),),
    );
  }else{
    list.add(
      ListTile(

        title: Text(element.title,style: const TextStyle(
          fontFamily: 'exar',
        ),),
        subtitle:     ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: Colors.transparent,
            padding: EdgeInsets.zero ,
            shadowColor: Colors.transparent,
            // onPrimary: Color(0xFF9267DD),
          ),
          onPressed: () => launch(element.link),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Text(element.link,
                style: const TextStyle(
                  fontFamily: 'exar',
                  color:AppColors.primaryColor,
                ),),
            ],
          ),
        ),
      ),
    );
  }

}
    if(list.isNotEmpty) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom:0, right: 0, left: 0),

        child: Column(
            children: list
        ),
      );
    }else{
      return const Center(
        child: Text('لاتتوفر معلومات التواصل',
        style:TextStyle(
          fontFamily: 'exar',
        )),
      );
    }
  }

}
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/data/Policies.dart';
import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:talaqe/widgets/faqs_screen_widgets.dart';

class FAQsScreen extends StatefulWidget {
  const FAQsScreen({Key? key}) : super(key: key);

  @override
  State<FAQsScreen> createState() => _FAQsScreenState();
}

class _FAQsScreenState extends State<FAQsScreen> {
  List<dynamic> data=[];
  final List<Policy> _plicies=[] ;

  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
  }


  Future<void> getdata() async {
    //Policy
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";
    if (datastring != "") {
      data = json.decode(datastring);
      Map datatype=data[0];
      var about=datatype['About'];
      Map datatypeabout=about[0];
      List<dynamic> policess = datatype['Policiesapp'];
      print('respone about  ${datatypeabout['textappcheck']}');

      setState(() {
        for (var element in policess) {
          print("add to areas $element");

          _plicies.add(
              Policy(element['id'], element['title'] ?? "",
                  element['text'] ?? ""));
        }
      });
    }
  }

  getpolices() {
    List <Widget> list=[];
    setState(() {
      for (var element in _plicies) {
        list.add(
            FAQExpansionTile(
                answerContentText : element.text,
                questionTitleText:element.title
            )
   );
        list.add(
          AppGaps.hGap20,
        );
      }
    });
    return  list;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CoreWidgets.appBarWidget(
          screenContext: context, titleWidget: const Text('حول التطبيق')),
      body: CustomScaffoldBodyWidget(
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:   getpolices()
              ))),
    );
  }
}

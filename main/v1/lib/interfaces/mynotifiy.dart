import 'dart:convert';

import '../CallApi.dart';
import '../data/account.dart';
import '../data/patient.dart';
import '../data/statuses.dart';
import '../data/typetreatments.dart';
import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyNotify extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyNotify();
  }


}
class _MyNotify extends State<MyNotify>{
  var items = [
    "الغاء الفلترة"
  ];
  Typetreatment _selecttype=Typetreatment(0, "", "");
  List<Typetreatment> _Typetreatments =[];
  List<Status> _statuseslist =[];
  List<Patient> _patientlist =[];
  Account account =new Account(0,"","");
  List<dynamic> data=[];
  String _url="https://talaqe.org/storage/app/public/";
  int accountid=0;
  @override
  void initState() {
    // TODO: implement initState
    getData();

    super.initState();
  }
  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";
    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
      });
      print("account id"+accountid.toString());
      Map datatype=data[0];
      List<dynamic> typetreatments = datatype['Typetreatment'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        typetreatments.forEach((element) {
          print("add to areas " + element.toString());

          _Typetreatments.add(
              Typetreatment(element['id'], element['name'] ?? "",
                  element['image'] ?? ""));
        });
      });
      List<dynamic> dentists = datatype['Dentist'];
      setState(() {
        dentists.forEach((element) {
          print("add to areas " + element.toString());
          if(element['id']==accountid){
            account.id=accountid;
            account.name=element['name'];
            account.phone=element['phone'];
          }
        });
      });
      //_patientlist
      List<dynamic> patientlist = datatype['Patient'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        patientlist.forEach((element) {
          print("add to areas " + element.toString());

          _patientlist.add(
              Patient(element['id'],
                element['name'] ?? "",
                element['age'] ?? "",
                element['gender'] ?? "",
                element['city'] ?? "",
                element['location'] ?? "",
                element['other'] ?? "",
                element['created_at'] ?? "",
                element['identifynumber'] ?? "",
                element['phone'] ?? "",
                element['email'] ?? "",
              ));
        });
      });
      //_statuseslist
      List<dynamic> statuseslist = datatype['Status'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        statuseslist.forEach((element) {
          print("add to areas " + element.toString());

          _statuseslist.add(
              Status(element['id'], element['dentistid'] ?? "",
                  element['patientid'] ?? "",
                  element['type'] ?? "",
                  element['typetreatment'] ?? "",
                  element['treatment'] ?? "",
                  element['datetreatment'] ?? "",
                  element['status'] ?? "",
                  element['notes'] ?? "",
                  element['created_at'] ?? "",
                  element['updated_at'] ?? ""));
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'اشعاراتي  ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20, fontFamily: 'exar',
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.settings),
              // onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return items.map((String choice) {
                  return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice,
                        style: TextStyle(
                            fontSize: 15,
                          fontFamily: 'exar',
                        ),),
                      onTap: () {
                        setState(() {
                          _selecttype.id = 0;
                        });
                      }
                  );
                }).toList();
              },
            ),

          ],
        ),



      ],
    ) ;  }

}
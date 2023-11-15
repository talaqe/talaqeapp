import 'dart:convert';

import '../data/account.dart';
import '../data/patient.dart';
import '../data/statuses.dart';
import '../data/typetreatments.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyNotify extends StatefulWidget{
  const MyNotify({super.key});

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
  final Typetreatment _selecttype=Typetreatment(0, "", "");
  final List<Typetreatment> _Typetreatments =[];
  final List<Status> _statuseslist =[];
  final List<Patient> _patientlist =[];
  Account account =Account(0,"","");
  List<dynamic> data=[];
  final String _url="https://talaqe.org/storage/app/public/";
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
      print("account id$accountid");
      Map datatype=data[0];
      List<dynamic> typetreatments = datatype['Typetreatment'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in typetreatments) {
          print("add to areas $element");

          _Typetreatments.add(
              Typetreatment(element['id'], element['name'] ?? "",
                  element['image'] ?? ""));
        }
      });
      List<dynamic> dentists = datatype['Dentist'];
      setState(() {
        for (var element in dentists) {
          print("add to areas $element");
          if(element['id']==accountid){
            account.id=accountid;
            account.name=element['name'];
            account.phone=element['phone'];
          }
        }
      });
      //_patientlist
      List<dynamic> patientlist = datatype['Patient'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in patientlist) {
          print("add to areas $element");

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
        }
      });
      //_statuseslist
      List<dynamic> statuseslist = datatype['Status'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in statuseslist) {
          print("add to areas $element");

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
        }
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
            const Text(
              'اشعاراتي  ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20, fontFamily: 'exar',
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.settings),
              // onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return items.map((String choice) {
                  return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice,
                        style: const TextStyle(
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
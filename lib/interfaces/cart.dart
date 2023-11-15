
import 'dart:core';

import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/typetreatments.dart';


import 'package:flutter/material.dart';



class Cart extends StatefulWidget {
Status status;
Patient patient;
Typetreatment typetreatment;
Cart({super.key, required this.status,required this.patient,required this.typetreatment});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartState();
  }

}



class _CartState extends State<Cart> {
  Status _status=Status(0, "", "", "", "", "", "", "", "", "", "");
  Patient _patient=Patient(0, "", "", "", "", "", "", "", "", "", "");
  Typetreatment _typetreatment=Typetreatment(0, "", "");

  @override
  void initState() {
    _status=widget.status;
    _patient=widget.patient;
    _typetreatment=widget.typetreatment;
   super.initState();
  }
  @override
  Widget build(BuildContext context){
    String statuss="";
    if(_status.status=='end'){
      statuss='مكتملة';
    }
    if(_status.status=='accept'){
      statuss='جاري التواصل';
    }
    if(_status.status=='accepttreat'){
      statuss=' تحت العلاج';
    }
    String result = _status.created_at.substring(
        0, _status.created_at.indexOf('T'));

    return  Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: const Color(0xFFE0CDFF),
          borderRadius: BorderRadius.circular(15)
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0, backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          // onPrimary: Color(0xFF6A21EA),
        ),
        child: ListTile(

          title:
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween,
            children: [
              Text(_typetreatment.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'exar',
                    fontSize: 16
                ),),
              Text('تاريخ الإضافة $result',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 8,
                  fontFamily: 'exar',
                ),)
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.person,color: Colors.black),
                Text(_patient.name,

                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'exar',
                      fontSize: 14
                  ),),
              ],),
              Text(" الحالة: $statuss",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'exar',
                    fontSize: 14
                ),)
            ],
          ),
        ),
        onPressed: () {
          setState(() {
    if(_status.status=='waiting'){

    }
            if(_status.status=='end'){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (context) =>
              //         End_Detail_stat(
              //           statid: _status.id,)));

            }
            else {

            }
          });




        },


      ),


    );
  }


}
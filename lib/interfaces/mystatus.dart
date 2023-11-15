import 'dart:convert';

import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/interfaces/detail_mystatus.dart';
import 'package:talaqe/interfaces/end_detail_status.dart';

import '../CallApi.dart';
import '../data/account.dart';
import '../data/patient.dart';
import '../data/typetreatments.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyStatus extends StatefulWidget{
  const MyStatus({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyStatus();
  }


}
class _MyStatus extends State<MyStatus>{
  var items = [
    "الغاء الفلترة"
  ];
  bool statusload=true;
  ScrollController scrollController = ScrollController();
 int lognlist=0;
  final Typetreatment _selecttype=Typetreatment(0, "", "");
  final List<Typetreatment> _Typetreatments =[];
  List<allStatus> _statuseslist =[];
  final List<Patient> _patientlist =[];
  Account account =Account(0,"","");
  List<dynamic> data=[];
  final String _url="https://talaqe.org/storage/app/public/";
  int accountid=0;
  static const _pageSize = 10;
  int offset = 0;
  int pagenumber = 0;
  @override
  void initState() {
    // TODO: implement initState

    getData();
    _fetchPage(0);
    super.initState();
  }
  Future<void> _fetchPage(int pageKey) async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    setState(() {
      accountid = prefsssss.getInt('accountid') ?? 0;
    });
    var data={
      'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
      'offset':offset.toString(),
      'accountid':accountid.toString(),


    };
    var response=await CallApi().postData(data,"getmystatuspages");
    var body = json.decode(utf8.decode(response.bodyBytes));
    Map datatype2 = body[0];
    print('respone datatype2  $body');


    List<dynamic> statuslist = datatype2['statuslast'];
    var dentist=datatype2['dentist'];
    print('respone areas  $dentist');
    var delement=dentist[0];

    setState(() {
      _statuseslist=[];
      for (var element in statuslist) {
        print("iddddddddsss${element['id']}");
        _statuseslist.add(

            allStatus(element['id'], element['dentistid'].toString() ?? "",
                element['patientid'].toString() ?? "",
                element['type'] ?? "",
                element['typetreatment'] ?? "",
                element['treatment'] ?? "",
                element['datetreatment'] ?? "",
                element['status'] ?? "",
                element['notes'] ?? "",
                element['created_at'] ?? "",
                element['updated_at'] ?? "",
                element['nametreat'] ?? "",
                element['imgtreat'] ?? "",
                element['patientname'] ?? "",
                element['patientage'] ?? "",
                element['patientgender'] ?? "",
                element['patientcity'] ?? "",
                element['patientlocation'] ?? "",
                element['patientother'] ?? "",
                element['patientcreated_at'] ?? "",
                element['patientidentifynumber'] ?? "",
                element['patientphone'] ?? "",
                element['patientemail'] ?? "",
                element['notesp'] ?? "")    );
      }
      print('respone alldata  $body');
      lognlist=_statuseslist.length;
    });
    print('respone offset  $offset');
    setState(() {
      statusload=false;
    });

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
      //_patientlist

      //_statuseslist

    }
  }
  @override
  Widget build(BuildContext context) {
    var screanwidth=MediaQuery.of(context).size.width;
    var screanheight=MediaQuery.of(context).size.height;
    // TODO: implement build
    return Stack(
      children: [
        Positioned(
         top: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width:5*screanwidth/6-20,
                child: const Text(
                  'حالاتي  ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'exar',
                  ),
                ),
              ),
              SizedBox(
                width:screanwidth/6-20,
                child: PopupMenuButton<String>(
                  icon: const Icon(Icons.settings),
                  // onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return items.map((String choice) {
                      return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice,
                            style: const TextStyle( fontFamily: 'exar',
                                fontSize: 15
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
              ),

            ],
          ),
        ),
        !statusload?Container():
        Container(
          child: const Center(
              child:  CircularProgressIndicator(

                valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                ,)

          ),
        ),
        Container(
          height: screanheight,
            margin: const EdgeInsets.only(top: 60),
            child:getstatuslist())


      ],
    ) ;  }
  Widget getstatuslist() {
    List<Widget> widgetlist =[];
    setState(() {


        widgetlist = [];
        if(offset>0){
          widgetlist.add(
              Container(
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
                  child:    const Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: [
                      Text("السابق",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'exar',
                        ),),
                      Icon(Icons.arrow_upward_rounded, color: Colors.black,),

                    ],
                  ),
                  onPressed: () {

                    scrollController.animateTo( //go to top of scroll
                        0,  //scroll offset to go
                        duration: const Duration(milliseconds: 500), //duration of scroll
                        curve:Curves.fastOutSlowIn //scroll type
                    );
                    setState(() {
                      offset=offset-10;

                      _fetchPage(offset);
                    });


                  },


                ),


              )
          );
        }
        for (var item in _statuseslist) {
          print("iddddddddddssss${item.id}");


          String statuss="";
          print('item.status${item.status}');

          if(item.status=='end'){
            statuss='مكتملة';
          }
          if(item.status=='accept'){
            statuss='جاري التواصل';
          }
          if(item.status=='accepttreat'){
            statuss=' تحت العلاج';
          }

          String result = item.created_at.substring(
              0, item.created_at.indexOf('T'));

          if (_selecttype.id == 0) {
            String result = item.created_at.substring(
                0, item.created_at.indexOf('T'));

            widgetlist.add(
              Container(
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
                        Text(item.nametreat,
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
                          Text(item.patientname,

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
                      if(item.status=='end'){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                End_Detail_stat(
                                  status: item,)));

                      }
                      else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                Detail_Mystatus(
                                  status: item,)));
                      }
                    });




                  },


                ),


              ),);
          }
          else {
            print("idselectype${_selecttype.id}");
            if (int.parse(item.typetreatment) == _selecttype.id){
              String result = item.created_at.substring(
                  0, item.created_at.indexOf('T'));

              widgetlist.add(
                  Container(
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
                                Text(item.nametreat,
                                  style: const TextStyle( fontFamily: 'exar',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  ),),
                                Text('تاريخ الإضافة $result',
                                  style: const TextStyle( fontFamily: 'exar',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8
                                  ),)
                              ],
                            ),
                            subtitle: Text(" المريض: ${item.patientname}",
                              style: const TextStyle( fontFamily: 'exar',
                                  fontWeight: FontWeight.bold,

                                  fontSize: 14
                              ),),
                          ),
                          onPressed: () {
                            setState(() {
                              if(item.status=='end'){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        End_Detail_stat(
                                          status: item,)));

                              }
                              else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) =>
                                        Detail_Mystatus(
                                          status: item,)));
                              }
                            });
                          }
                      )
                  )
              );
            }
          }
              }
if(widgetlist.length>=10) {
  widgetlist.add(
      Container(
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
          child: const Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween,
            children: [
              Text("المزيد",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'exar',
                ),),
              Icon(Icons.arrow_downward_rounded, color: Colors.black,),

            ],
          ),
          onPressed: () {
            scrollController.animateTo( //go to top of scroll
                0, //scroll offset to go
                duration: const Duration(milliseconds: 500), //duration of scroll
                curve: Curves.fastOutSlowIn //scroll type
            );
            setState(() {
              offset = offset + 10;
              pagenumber = pagenumber + 1;

              _fetchPage(offset);
            });
          },


        ),


      )
  );
}


      });
    if(_statuseslist.isEmpty && !statusload){
      return Container(
        margin: const EdgeInsets.only(top: 20),
        alignment: Alignment.topCenter,
        child: const Text('لا تتوفر حالات  حاليا',
          style: TextStyle(
            fontFamily: 'exar',
          ),),
      );
    }

    return
      SingleChildScrollView(
controller: scrollController,
        child: Column(
          children:widgetlist,
        ),
      );


  }

}
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/Gallorywork.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/fail.dart';
import 'package:talaqe/interfaces/addimagetoprotiflio.dart';
import 'package:talaqe/interfaces/addtoprotifolio.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/account.dart';
class Protifolio extends StatefulWidget{

Dentist dentist;
Protifolio({super.key, required this.dentist});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Protifolio();

  }


}
class _Protifolio extends State<Protifolio> with SingleTickerProviderStateMixin{
  List<dynamic> data=[];
  final List<City> _cities=[] ;
  int offset=0;
  String linkcode="";
  final List<Gallorywork> _galloryworklist=[];
  City _selectedcities=City(0, "المدينة");
  final String _url="https://talaqe.org/storage/app/public/";
  int accountid=0;
  final List<Typetreatment> _Typetreatments =[];
  final List<Status> _statuseslist =[];
  final List<Patient> _patientlist =[];
  Account account =Account(0,"","");
  final Typetreatment _selecttype=Typetreatment(0, "", "");
  int counter = 0;
  TextEditingController searchcontroller = TextEditingController();
  Dentist dentist=Dentist(0, "", "", "", "", "", "", "", "", "","","");

  Container hometab =Container();
  String searchword=" ";
  bool activesearch=false;
  bool progresss=true;
  @override
  void initState() {
    // TODO: implement initState
    dentist=widget.dentist;
    getData();
    super.initState();
  }
  Future<void> _refreshData() async {
    try {
      var response = await CallApi().getallData('alldata');
      // var body=json.decode(response.body);
      var body = json.decode(utf8.decode(response.bodyBytes));
      print('respone getallldatttasaallls  ${response.body}');
      SharedPreferences shpref= await SharedPreferences.getInstance();
      shpref.setString('data', utf8.decode(response.bodyBytes).toString());
    } on TimeoutException catch (_) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Fail()));
    }
    on SocketException catch (_) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Fail()));
    }
    getData();
  }


  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();

    var response=await CallApi().getallData('alldata');

      data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
        account.id=accountid;
        account.name=dentist.name;
        account.phone=dentist.phone;
        linkcode=dentist.gallorywork;
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


      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());
      int? idselectedcities =prefsssss.getInt("_selectedcities");
      setState(() {
        for (var element in cities) {

          print("add to areas $element");

          _cities.add(
              City(element['id'], element['name'] ?? ""));
          if(element['id']==idselectedcities){
            _selectedcities.id=element['id'];
            _selectedcities.name=element['name'] ;
          }
        }
      });
      //_statuseslist

    var response2=await CallApi().getallData("getgallorysingle/$accountid/$offset");
    var body = json.decode(utf8.decode(response2.bodyBytes));
    print('respone Gallorywork  $body');
    var datatypee=body[0];
    List<dynamic> gallorylist = datatypee['Gallorywork'];

    setState(() {
      for (var element in gallorylist) {
        print("add to gallorylist $element");
        _galloryworklist.add(
            Gallorywork(
                element['id'],
                element['code'] ?? "",
                element['dentistid'] ?? "",
                element['stateid'] ?? "",
                element['patientid'] ?? "",
                element['text'] ?? "",
                element['title'] ?? "",
                element['treatid'] ?? "",
                element['created_at'] ?? "",
                element['likes'] ?? "",
                element['views'] ?? ""
            ));
      }
      progresss=false;
    });

  }
  var items = [
    "الغاء الفلترة"
  ];
  @override
  Widget build(BuildContext context) {
    var screanwidth=MediaQuery.of(context).size.width;
    var screanheight=MediaQuery.of(context).size.height;
    return  Scaffold(


        extendBodyBehindAppBar: true,
        appBar: AppBar(
           leading: BackButton(
             color: Colors.white,
             onPressed: () => Navigator.of(context).pop() ,
           ),
          title:  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          SizedBox(height:25),

                          SizedBox(width:10),
                          Text('معرض الأعمال',
                              style:TextStyle( fontFamily: 'exar',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17.0)),

                        ]
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Addtoprotifolio()));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFF9267DD), padding: EdgeInsets.zero, backgroundColor: Colors.transparent ,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Container(
                          margin: EdgeInsets.zero,
                          padding:const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: const Color(0xFF9267DD),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child:  const Icon(Icons.add,
                              color: Colors.white)
                      ),
                    ),
                  ]
              )
          ),
          backgroundColor:Colors.transparent ,
          elevation: 0,
        ),
        backgroundColor:AppColors.primaryColor,

        body:SafeArea(
            child:Column(

                children:[



                  const SizedBox(height: 10),
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius:  BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),

                          ),
                          child:Stack(
                            children: [
                              progresss? Container(
                                child: const Center(
                                    child:  CircularProgressIndicator(

                                      valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                                      ,)

                                ),
                              ):   getstatuslist(context)


                            ],
                          ),

                      )
                  ),
                ]
            )
        ),
      bottomNavigationBar: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white, shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
          padding: const EdgeInsets.symmetric(
              horizontal: 40.0, vertical: 15.0)  ,
          backgroundColor: AppColors.primaryColor,
        ),
        onPressed: () {
          _sharegallory();
        },
        child: const Text('مشاركة معرض الأعمال',
        style:TextStyle(
          fontFamily: 'exar',
        )),
      ),

    );
  }
  Widget getarealist() {
    List<Widget> list = [];
    for (var element in _cities) {
      print('ffff${element.name}');
      list.add( ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black, elevation: 0, backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Row(
          children: [
           
            Text(element.name,style:const TextStyle( fontFamily: 'exar',)),
          ],
        ),

        onPressed: () async {setState(() {
          _selectedcities=element;

        });
        SharedPreferences prefsssss = await SharedPreferences.getInstance();
        prefsssss.setInt("_selectedcities", _selectedcities.id);
     },

      ),);
    }
    return SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(top: 20),
            child:  Column(
              children: list,
            )
        ));

  }
  Widget getTypetreatmentlist() {
    List<Widget> list =[];
    for (var element in _Typetreatments) {
      list.add(
        Container(
          height: 35,
          margin:const EdgeInsets.only(right:5),
          padding:const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color:Colors.white,

          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xFF6A21EA), elevation: 0, backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child:  Row(
                children: [
                  Text(element.name,
                      style:const TextStyle( fontFamily: 'exar',
                          fontSize: 12
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  FadeInImage(
                    image: NetworkImage(_url + element.image),
                    height: 35,
                    width:35,
                    fit: BoxFit.cover,

                    placeholder: const AssetImage('asset/gg.jpg'),
                  ),
                ]
            ),
            onPressed: (){setState(() {
              _selecttype.id=element.id;
              _selecttype.name=element.name;
              _selecttype.image=element.image;
            });

            },


          ),


        ),
      );
    }
    return SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: list,
        )
    );


  }


  Widget getstatuslist(BuildContext context) {
    var screanwidth=MediaQuery.of(context).size.width;
    var screanheight=MediaQuery.of(context).size.height;

    List<Widget> list =[];
    setState(() {
      for (var gallory in _galloryworklist) {

            if (int.parse(gallory.dentistid) == accountid) {
              for (var type in _Typetreatments) {
                if (type.id == int.parse(gallory.treatid)) {

                  String result = gallory.created_at.substring(
                      0, gallory.created_at.indexOf('T'));

                  list.add(
                    Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.only(right: 5),
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
                                leading: const Icon(Icons.dehaze_outlined),
                                title:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(gallory.title,
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
                           subtitle: Column(
                             children: [
                               Text(type.name,style:const TextStyle( fontFamily: 'exar',)),
                               Text(gallory.text,style:const TextStyle( fontFamily: 'exar',),
                              ) ],
                           ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AddImageprotiflio(protifloid:gallory.id)));


                              },


                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                showdialog(context, gallory.id);
                              },
                              child: const Align(
                                alignment: Alignment.topRight,
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.close, color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0.0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () {
                              },
                              child: const Align(
                                alignment: Alignment.topRight,
                                child: CircleAvatar(
                                  radius: 14.0,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.edit, color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]
                    ),);
                }
              }
            }

      }
    });
    if(list.isEmpty){
      return Container(
        width: screanwidth,
        color: Colors.white,

      );
    }
    return
      SingleChildScrollView(
        child: Column(
          children:list,
        ),
      );


  }
  void showdialog(BuildContext context,int id) {
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
                              child: Text('هل ترغب بازالة هذه الحالة من المعرض',
                                style: TextStyle(
                                  fontFamily: 'exar',
                                ),),
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
                                "نعم",
                                style: TextStyle(
                                    color:  Color(0xFF6F1CE6),
                                    fontFamily: 'exar',
                                    fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              _deletestatus(context,id);

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
                            child: Icon(Icons.close, color: AppColors.primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          );
        });
  }

  Future<void> search() async {
    SharedPreferences shpref= await SharedPreferences.getInstance();
    shpref.setString('search', searchcontroller.text);

  }

  Future<void> _deletestatus(BuildContext dialogContext,int id) async {
    var data={
      'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
      'galloryid':id,
  };
    var response=await CallApi().postData(data,'delete/gallorywork');
    print('respone dddddddd:  ${response.body}');
    var body=json.decode(response.body);

    if(body.toString()==""){
      print('respone ssssssssssss ');
      Navigator.of(dialogContext).pop();
      showfaildialog(dialogContext);
    }
    else {

      if (body['success'] == true) {
        Navigator.of(dialogContext).pop();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Protifolio(dentist: dentist,)));
      }else{
        Navigator.of(dialogContext).pop();
        showfaildialog(context);
      }

    }
  }
  void showfaildialog(BuildContext context) {

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
                              child: Text('فشل حفظ التعديلات',
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
                                    color: AppColors.primaryColor, fontSize: 20.0),
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
                            child: Icon(Icons.close, color: AppColors.primaryColor,
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


  Future<void> _sharegallory () async {
    String sharelink="https://talaqe.org/protfolio/dentist/$linkcode";
    String name=account.name;
    // Share.share(' معرض اعمال الطبيب $name على تطبيق تلاقي  $sharelink', subject: '!');
  }

  void changeImage() {

  }
}

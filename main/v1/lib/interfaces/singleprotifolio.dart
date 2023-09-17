import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/Gallorywork.dart';
import 'package:talaqe/data/allDentis.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/data/likes.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/fail.dart';
import 'package:talaqe/interfaces/addimagetoprotiflio.dart';
import 'package:talaqe/interfaces/addtoprotifolio.dart';
import 'package:talaqe/interfaces/dataaccount.dart';
import 'package:talaqe/interfaces/imageprotiflio.dart';
import 'package:talaqe/interfaces/mynotifiy.dart';
import 'package:talaqe/interfaces/mystatus.dart';
import 'package:talaqe/interfaces/showprotifolio.dart';
import 'package:talaqe/navDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/account.dart';
class SingleProtifolio extends StatefulWidget{
  allDentist dentist;
SingleProtifolio({required this.dentist});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SingleProtifolio();

  }


}
class _SingleProtifolio extends State<SingleProtifolio> with SingleTickerProviderStateMixin{
  List<dynamic> data=[];
  allDentist _dentist=allDentist(0, "", "", "", "", "", "", "", "", "", "", "", "", "");
  List<Color> colorslist =[];
  List<City> _cities=[] ;
 int _protifolio=0;
 int offset=0;
  ScrollController scrollController = ScrollController();

  int accountid=0;
  String linkcode="";
  List<Gallorywork> _galloryworklist=[];
  City _selectedcities=City(0, "المدينة");
  String _url="https://talaqe.org/storage/app/public/";

  List<Typetreatment> _Typetreatments =[];
  List<Like> _likelist =[];
  List<Status> _statuseslist =[];
  List<Patient> _patientlist =[];
  Account account =new Account(0,"","");
  Typetreatment _selecttype=Typetreatment(0, "", "");
  int counter = 0;
  TextEditingController searchcontroller = new TextEditingController();

  Container hometab =new Container();
  String searchword=" ";
  bool activesearch=false;
  bool progresss=true;
  @override
  void initState() {
    // TODO: implement initState
    _dentist=widget.dentist;
    getData();

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    print('respone pageKey  '+pageKey.toString());
    var response2=await CallApi().getallData("getgallorysingle/"+_dentist.id.toString()+"/"+offset.toString());
    var body = json.decode(utf8.decode(response2.bodyBytes));
    List<dynamic> gallorylist = body['Gallorywork'];
    // print('respone areas  ' + data['areas'].toString());

    setState(() {
      gallorylist.forEach((element) {
        print("add to gallorylist " + element.toString());
        if(int.parse(element['addtodoctorlist'])!=0) {
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
      });

    });
    List<dynamic> likelist = body['like'];
    // print('respone areas  ' + data['areas'].toString());

    setState(() {
      likelist.forEach((element) {
        _likelist.add(
            Like(
              element['id'],
              element['dentistid'] ?? "",
              element['galloryworkid'] ?? "",

            ));
      });
    });
    setState((){
      progresss=false;
    });

  }

  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";

    var response2=await CallApi().getallData("getgallorysingle/"+_dentist.id.toString()+"/"+offset.toString());
    var body = json.decode(utf8.decode(response2.bodyBytes));

    setState(() {
      accountid = prefsssss.getInt('accountid') ?? 0;
    });
     print('respone body  ' + body.toString());

    Map datatype1=body[0];
    List<dynamic> gallorylist = datatype1['Gallorywork'];

    setState(() {
      gallorylist.forEach((element) {
        print("add to addtodoctorlist " + element['addtodoctorlist'].toString());
           if(int.parse(element['addtodoctorlist'])!=0) {
             print("add to gallorylist " + element.toString());

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
      });

    });
    List<dynamic> likelist = datatype1['like'];
    // print('respone areas  ' + data['areas'].toString());

    setState(() {
      likelist.forEach((element) {
        _likelist.add(
            Like(
                element['id'],
                element['dentistid'] ?? "",
                element['galloryworkid'] ?? "",

            ));
      });
    });
      data = json.decode(datastring);
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

    setState((){
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
                  Row(
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



                SizedBox(height: 10),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        borderRadius:  BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),

                      ),
                      child:Stack(
                        children: [
                          progresss? Container(
                            child: Center(
                                child:  CircularProgressIndicator(

                                  valueColor:  new AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
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
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
          padding: EdgeInsets.symmetric(
              horizontal: 40.0, vertical: 15.0),
          primary:Colors.white  ,
          backgroundColor: AppColors.primaryColor,
        ),
        onPressed: () {
          _sharegallory();
        },
        child: Text('مشاركة معرض الأعمال',style:TextStyle(
          fontFamily: 'exar',
        )),
      ),

    );
  }
  Widget getarealist() {
    List<Widget> list = [];
    _cities.forEach((element) {
      print('ffff'+element.name);
      list.add( ElevatedButton(
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

        onPressed: () async {setState(() {
          _selectedcities=element;

        });
        SharedPreferences prefsssss = await SharedPreferences.getInstance();
        prefsssss.setInt("_selectedcities", _selectedcities.id);
        },

      ),);
    });
    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 20),
            child:  Column(
              children: list,
            )
        ));

  }
  Widget getTypetreatmentlist() {
    List<Widget> list =[];
    _Typetreatments.forEach((element) {
      list.add(
        Container(
          height: 35,
          margin:EdgeInsets.only(right:5),
          padding:EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color:Colors.white,

          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              shadowColor: Colors.transparent,
              primary: Colors.transparent,
              onPrimary: Color(0xFF6A21EA),
            ),
            child:  Row(
                children: [
                  Text(element.name,
                      style:TextStyle( fontFamily: 'exar',
                          fontSize: 12
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  FadeInImage(
                    image: NetworkImage(_url + element.image),
                    height: 35,
                    width:35,
                    fit: BoxFit.cover,

                    placeholder: AssetImage('asset/gg.jpg'),
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
    });
    return Container(
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
      if(offset>0){
        list.add(
            Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  color: Color(0xFFE0CDFF),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  primary: Colors.transparent,
                  // onPrimary: Color(0xFF6A21EA),
                ),
                child:    Row(
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
                      duration: Duration(milliseconds: 500), //duration of scroll
                      curve:Curves.fastOutSlowIn //scroll type
                  );
                  setState(() {
                    offset=offset-10;
                    list.clear();
                    progresss=true;

                    _fetchPage(offset);

                  });


                },


              ),


            )
        );
      }
      print('_galloryworklist'+_galloryworklist.toString());
      _galloryworklist.forEach((gallory) {
        int i=_galloryworklist.indexOf(gallory);
        colorslist.add(Colors.white);
        _Typetreatments.forEach((type) {
          if (type.id == int.parse(gallory.treatid)) {

            String result = gallory.created_at.substring(
                0, gallory.created_at.indexOf('T'));
            int exist=0;

            _likelist.forEach((like) {
              print("colorslist"+like.galloryworkid);

              if(int.parse(like.galloryworkid)==gallory.id){
                exist=1;
              }
            });
            if(exist==1){
              colorslist[i]=Color(0xFF591DC1);
            }
            list.add(
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    padding: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                        color: Color(0xFFE0CDFF),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        primary: Colors.transparent,
                        // onPrimary: Color(0xFF6A21EA),
                      ),
                      child: ListTile(
                        title:
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Text(gallory.title,
                              style: TextStyle( fontFamily: 'exar',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),),
                            Text('تاريخ الإضافة ' + result,
                              style: TextStyle( fontFamily: 'exar',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 8
                              ),)
                          ],
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("نوع العلاج: "+type.name,style:TextStyle( fontFamily: 'exar',)),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        var data = {
                          'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
                          'galloryid': gallory.id.toString(),
                          'dentistid': accountid.toString(),


                        };
                        var response = await CallApi().postData(data, 'gallorywork/setview');
                        print('respone :  ' + response.body.toString());
                        int like=0;
                        if(  colorslist[i]==Color(0xFF591DC1)){
                          like=1;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Imageprotiflio(gallorywork:gallory,like:like)));


                      },


                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    child: GestureDetector(
                      onTap: () {
                        setfavorate(i,gallory.id);
                      },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.favorite, color:  colorslist[i]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            );
          }
        });

      });
      if(list.length>=10) {
        list.add(
            Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  color: Color(0xFFE0CDFF),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  primary: Colors.transparent,
                  // onPrimary: Color(0xFF6A21EA),
                ),
                child: Row(
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
                      duration: Duration(milliseconds: 500),
                      //duration of scroll
                      curve: Curves.fastOutSlowIn //scroll type
                  );
                  setState(() {

                    progresss=true;
                    list.clear();
                    offset = offset + 10;
                    _fetchPage(offset);

                    // if (_selecttype.id == 0 && (_selectedcities.id != 0)) {
                    //   _fetchPage(offset);
                    // }
                  });
                },


              ),


            )
        );
      }
    });
    if(list.length==0){
      if(offset>0){
        list.clear();
        list.add(
            Container(
              margin: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                  color: Color(0xFFE0CDFF),
                  borderRadius: BorderRadius.circular(15)
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  primary: Colors.transparent,
                  // onPrimary: Color(0xFF6A21EA),
                ),
                child:    Row(
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
                      duration: Duration(milliseconds: 500), //duration of scroll
                      curve:Curves.fastOutSlowIn //scroll type
                  );
                  setState(() {

                    progresss=true;
                    list.clear();
                    offset=offset-10;
                    _fetchPage(offset);


                  });


                },


              ),


            )
        );
        return    SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children:list,
          ),
        );
      }
      print('dddddddddddddddddddddddddddd');
      return
        Container(
          width: screanwidth,
          alignment: Alignment.center,
          child: Text('لايتوفر تفاصيل في المعرض',style:TextStyle( fontFamily: 'exar',)),
        );
    }
    return
      SingleChildScrollView(
        controller: scrollController,

        child: Column(
          children:list,
        ),
      );


  }

  Future<void> search() async {
    SharedPreferences shpref= await SharedPreferences.getInstance();
    shpref.setString('search', searchcontroller.text);

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
                              child: Text('فشل حفظ التعديلات',style:TextStyle( fontFamily: 'exar',)),
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
                        child: Align(
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
    String sharelink="https://talaqe.org/protfolio/dentist/"+_dentist.gallorywork;
    String name=_dentist.name;
    // Share.share(' معرض اعمال الطبيب $name على تطبيق تلاقي  $sharelink', subject: '!');
  }


  Future<void> setfavorate(int i,int galloryid) async {
    if( colorslist[i]!=AppColors.primaryColor) {
      setState(() {
        colorslist[i] =AppColors.primaryColor;
      });
      var data = {
        'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
        'galloryid': galloryid.toString(),
        'dentistid': accountid.toString(),


      };
      var response = await CallApi().postData(data, 'gallorywork/setlike');
      print('respone :  ' + response.body.toString());
    }else{
      setState(() {
        colorslist[i] = Color(0xFFFFFFFF);
      });
      var data = {
        'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
        'galloryid': galloryid.toString(),
        'dentistid': accountid.toString(),


      };
      var response = await CallApi().postData(data, 'gallorywork/remove');
      print('respone :  ' + response.body.toString());
    }
  }
}

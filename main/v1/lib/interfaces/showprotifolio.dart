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
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/data/universities.dart';
import 'package:talaqe/fail.dart';
import 'package:talaqe/interfaces/addtodoctorprotif.dart';
import 'package:talaqe/interfaces/dataaccount.dart';

import 'package:talaqe/interfaces/mynotifiy.dart';
import 'package:talaqe/interfaces/mystatus.dart';
import 'package:talaqe/interfaces/singleprotifolio.dart';
import 'package:talaqe/navDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/account.dart';
class ShowProtifolio extends StatefulWidget{


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShowProtifolio();

  }


}
class _ShowProtifolio extends State<ShowProtifolio> with SingleTickerProviderStateMixin{
  List<dynamic> data=[];
  List<City> _cities=[] ;
  List<allDentist> _dentistlist=[] ;
  bool hasimage=false;
  String linkcode="";

  ScrollController scrollController = ScrollController();

  List<Gallorywork> _galloryworklist=[];
  City _selectedcities=City(0, "المدينة");
  String _url="https://talaqe.org/storage/app/public/";
  int accountid=0;
  int offset=0;
  List<University> _universities=[] ;
  List<Typetreatment> _Typetreatments =[];
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
    getData();

    super.initState();
  }


  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();

    var response=await CallApi().getallData('alldata');

    data = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      accountid = prefsssss.getInt('accountid') ?? 0;
    });
    print("account id"+accountid.toString());
    Map datatype=data[0];

    List<dynamic> cities = datatype['City'];
    // print('respone areas  ' + data['areas'].toString());
    int? idselectedcities =prefsssss.getInt("_selectedcities");
    setState(() {
      cities.forEach((element) {

        print("add to areas " + element.toString());

        _cities.add(
            City(element['id'], element['name'] ?? ""));
        if(element['id']==idselectedcities){
          _selectedcities.id=element['id'];
          _selectedcities.name=element['name'] ;
        }
      });
    });
    List<dynamic> universities = datatype['University'];
    // print('respone areas  ' + data['areas'].toString());

    setState(() {
      universities.forEach((element) {
        print("add to areas " + element.toString());

        _universities.add(
            University(element['id'], element['name'] ?? "",
                int.parse(  element['cityid'].toString() ??"0")));
      });
    });
    ///////////



    var response2=await CallApi().getallData("getgallory/"+offset.toString());
    var body = json.decode(utf8.decode(response2.bodyBytes));

print('dddddddddddddddddddddddddddd'+body.toString());
    List<dynamic> dentists =body;
    setState(() {
      dentists.forEach((element) {
        print("add to areas " + element.toString());
        _dentistlist.add(new allDentist(element['id'],
            element['name'],
            element['university'],
            element['phone'],
            element['city'],
            element['years'],
            element['statusreserv'].toString(),
            element['identifynumber'],
            element['type'],
            element['active'],
            element['avatar'],
            element['universityname'],
            element['cityname'],
          element['gallorywork'],));
        if(element['id']==accountid){
          account.id=accountid;
          account.name=element['name'];
          account.phone=element['phone'];
          linkcode=element['gallorywork'];
        }
      });
    });
    setState(() {
      progresss=false;
    });
  }
  var items = [
    "الغاء الفلترة"
  ];
  Future<void> _fetchPage(int pageKey) async {
    print('respone pageKey  '+pageKey.toString());


    var response2=await CallApi().getallData("getgallory/"+offset.toString());
    var body = json.decode(utf8.decode(response2.bodyBytes));

    print('dddddddddddddddddddddddddddd'+body.toString());
    List<dynamic> dentists =body;
    setState(() {
      dentists.forEach((element) {
        print("add to  gallorywork " +  element['gallorywork'].toString());
        _dentistlist.add(new allDentist(element['id'],
          element['name'],
          element['university'],
          element['phone'],
          element['city'],
          element['years'],
          element['statusreserv'],
          element['identifynumber'],
          element['type'],
          element['active'],
          element['avatar'],
          element['universityname'],
          element['cityname'],
          element['gallorywork'],));
        if(element['id']==accountid){
          account.id=accountid;
          account.name=element['name'];
          account.phone=element['phone'];
          linkcode=element['gallorywork'];
        }
      });
    });
    setState(() {
      progresss=false;
    });


  }
  @override
  Widget build(BuildContext context) {
    var screanwidth=MediaQuery.of(context).size.width;
    var screanheight=MediaQuery.of(context).size.height;
    return  Scaffold(

      drawer: NavDrawer(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(

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
                        Text('استعراض أعمال الاطباء',
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
                          ):   Container(
                            width: screanwidth,
                              child: getstatuslist(context))


                        ],
                      )

                    )
                ),
              ]
          )
      ),



    );
  }
  Widget getarealist(BuildContext context) {
    var screanwidth=MediaQuery.of(context).size.width;
    var screanheight=MediaQuery.of(context).size.height;

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
           
            Text(element.name,
            style:TextStyle(
              fontFamily: 'exar',
            )),
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
    if(list.length==0){
      return Container(
        width: screanwidth,
        color: Colors.white,

      );
    }
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

    List<int> intlist=[];
    int exist=0;
    int firsttime=0;
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
      _dentistlist.forEach((element) {
        hasimage=false;
        if(element.avatar!=null){
          hasimage=true;
        }
        String years="";
        if(element.years=="primary"){
          years="سنة اولى /ثانية /ثالثة";
        }
        if(element.years=="forth"){
          years="سنة رابعة";
        }
        if(element.years=="fifth"){
          years="سنة خامسة";
        }
        if(element.years=="excellent"){
          years="امتياز";
        }
        if(element.years=="master"){
          years="ماستر";
        }
        String  imagepath="";
        if( element.avatar!= null) {
          int startIndex = element.avatar.indexOf(".");
          String firstpart = element.avatar.substring(0, startIndex);
          String lastpart = element.avatar.substring(
              1 + startIndex, element.avatar.length);
          imagepath = firstpart + "-small." + lastpart;
          print("imagepath" + imagepath);
        }
        list.add(
          Container(
            margin: EdgeInsets.only(bottom: 5),
            padding: EdgeInsets.only(right: 5,bottom: 10,left: 5),
            decoration: BoxDecoration(
                color: Color(0xFFE0CDFF),
                borderRadius: BorderRadius.circular(12)
            ),
            child: Stack(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    primary: Colors.transparent,
                    // onPrimary: Color(0xFF6A21EA),
                  ),
                  child:   Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start,
                    children: [

                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  child:  !hasimage?ClipOval(
                                    child: Container(

                                        decoration: BoxDecoration(
                                          color: Color(0xFF9267DD),
                                        ),
                                        child:  Icon(Icons.person,
                                            color: Colors.white)),
                                  ):
                                  ClipOval(
                                      child:
                                      (element.avatar!=null)?Container(
                                        child: FadeInImage(
                                          image: NetworkImage(_url + imagepath),
                                          // height: 200,
                                          fit: BoxFit.cover,
                                          width: 40,
                                          height: 40,
                                          placeholder: AssetImage('asset/im.png'),
                                        ),
                                      ):
                                      Container(

                                      )
                                  ),
                                ),
                                Container(
                                  width: 3*screanwidth/5,
                                  margin: EdgeInsets.only(right: 10),
                                  child:        Text(element.name,
                                    style: TextStyle( fontFamily: 'exar',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16
                                    ),),
                                )

                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: screanwidth/2-50,
                                child:     Text('الجامعة: ' ,
                                  style: TextStyle( fontFamily: 'exar',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16
                                  ),),
                              ),
                              Container(
                                width: screanwidth/2-60,
                                child:    Text( element.universityname ,
                                  style: TextStyle( fontFamily: 'exar',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16
                                  ),),
                              )
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: screanwidth/2-50,
                                child: Text('سنة الدراسة: ',
                                  style: TextStyle( fontFamily: 'exar',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16
                                  ),),
                              ),
                              Container(
                                width: screanwidth/2-50,
                                child: Text( years ,
                                  style: TextStyle( fontFamily: 'exar',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16
                                  ),),
                              ),
                            ],
                          )
                        ],
                      )

                    ],
                  ),
                  onPressed: () {
                    hasimage=false;
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            SingleProtifolio(dentist: element,)));
                  },


                ),

              ],
            ),
          ),
        );

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
      print('dddddddddddddddddddddddddddd');
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
      return
       Container(
         width: screanwidth,
         alignment: Alignment.center,
         child: Text('لايتوفر تفاصيل في المعرض',
         style:TextStyle( fontFamily: 'exar',)),
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
                              child: Text('هل ترغب بازالة هذه الحالة من المعرض',
                                style: TextStyle(
                                  fontFamily: 'exar',
                                ),),
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
                        child: Align(
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
    print('respone dddddddd:  '+response.body.toString());
    var body=json.decode(response.body);

    if(body.toString()==""){
      print('respone ssssssssssss ');
      Navigator.of(dialogContext).pop();
      showfaildialog(dialogContext);
    }
    else {

      if (body['success'] == true) {
        Navigator.of(dialogContext).pop();

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
                              child: Text('فشل حفظ التعديلات',
                              style:TextStyle( fontFamily: 'exar',)),
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
                                style: TextStyle(
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
    String sharelink="https://talaqe.org/protfolio/dentist/"+linkcode;
    String name=account.name;
    // Share.share(' معرض اعمال الطبيب $name على تطبيق تلاقي  $sharelink', subject: '!');
  }

  void changeImage() {

  }

}

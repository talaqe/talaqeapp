import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/fail.dart';
import 'package:talaqe/interfaces/dataaccount.dart';

import 'package:talaqe/interfaces/mynotifiy.dart';
import 'package:talaqe/interfaces/mystatus.dart';
import 'package:talaqe/interfaces/patientdetail.dart';
import 'package:talaqe/main.dart';
import 'package:talaqe/navDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/account.dart';
class Findpatient extends StatefulWidget{
String stringfind;
int city;
Findpatient({this.stringfind="",this.city=0});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Findpatient();

  }


}
class _Findpatient extends State<Findpatient> with SingleTickerProviderStateMixin{
  List<dynamic> data=[];
  List<City> _cities=[] ;

  List<Widget> widgetlist =[];
  City _selectedcities=City(0, "المدينة");
  String _url="https://talaqe.org/storage/app/public/";
  int accountid=0;
  List<Typetreatment> _Typetreatments =[];
  List<Status> _statuseslist =[];
  List<Patient> _patientlist =[];
  Account account =new Account(0,"","");
  Typetreatment _selecttype=Typetreatment(0, "", "");
  int counter = 0;
  TextEditingController searchcontroller = new TextEditingController();
int offset=0;
  Container hometab =new Container();
  String searchword=" ";
  int _city=0;
  bool activesearch=true;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    _city=widget.city;
    searchword=widget.stringfind;
    getData();

    super.initState();
  }
  Future<void> _refreshData() async {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyApp()));
  }


  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";


      setState((){
        activesearch=true;
       searchcontroller.text=searchword;
      });

    print('datastring'+datastring);

    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
      });
      print("account id"+accountid.toString());
      print("city id"+_city.toString());
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
      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        cities.forEach((element) {

          print("add to _cities " + element.toString());

          _cities.add(
              City(element['id'], element['name'] ?? ""));
           if(element['id']==_city){
             _selectedcities.id=element['id'];
             _selectedcities.name=element['name'];
           }
        });

      });
      var response1=await CallApi().getallData('getsearchdata/'+searchword+"/"+_city.toString()+"/"+offset.toString());
      print('respone getsearchdata:  '+response1.body.toString());

      var body1=json.decode(response1.body);
      //_patientlist
      if (body1['success'] == true) {
      setState(() {
        offset=offset+10;
          _patientlist=[];
          List<dynamic> patientsarray=body1["patientsarray"];
          patientsarray.forEach((element) {
              _patientlist.add(
                    Patient(
                      element['id'],
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
          activesearch=false;
        });

      }



    }
  }
  var items = [
    "الغاء الفلترة"
  ];
  @override
  Widget build(BuildContext context) {
    var screanwidth=MediaQuery.of(context).size.width;
    var screanheight=MediaQuery.of(context).size.height;
    return  Scaffold(
        resizeToAvoidBottomInset: false,

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
                          Text('البحث عن مريض',
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

                  SizedBox(height:5),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:3.0,right: 5),
                        child: Container(
                            width: screanwidth/3-15,
                            height: 52,
                            decoration: BoxDecoration(
                              color:Color(0xFF9267DD),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: ElevatedButton(
                              style:  ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(12.0),
                                  ),
                                  primary: Color(0xFF9267DD)
                              ),
                              onPressed: (){
                                showModalBottomSheet(context: context,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20)
                                        )
                                    ),
                                    builder: (context){
                                      return   getarealist();
                                    });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.account_balance_rounded,
                                    color: Colors.white,),
                                  Text(_selectedcities.name,style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'exar',
                                      fontSize: 12
                                  ),)
                                ],
                              ),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:5.0),
                        child: Row(
                          children: [
                            Container(height: 53,
                                width: 2*screanwidth/3-53,
                                decoration: BoxDecoration(
                                  color:Color(0xFF9267DD),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: TextField(
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                  controller: searchcontroller,
                                  decoration: InputDecoration(
                                      labelStyle: TextStyle(
                                          fontFamily: 'exar',
                                          color: Colors.white
                                      ),
                                      hintStyle:  TextStyle(
                                          fontFamily: 'exar',
                                          color: Colors.white
                                      ),
                                      border: InputBorder.none,

                                      hintText:' ابحث عن اسم المريض او رقمه'
                                  ),
                                )
                            ),
                            Container(height: 53,
                              decoration: BoxDecoration(
                                color:Color(0xFF9267DD),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ), ),
                              child: IconButton(onPressed: (){
                          offset=0;
                          searchword=searchcontroller.text;
                          _city=_selectedcities.id;
                          _fetchPage(0);

                              }, icon: Icon(Icons.search,
                                color: Colors.white,),
                                padding: EdgeInsets.zero,),
                            )
                          ],

                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.all(20),
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius:  BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),

                          ),
                          child:Container(
                            child:   Stack(
                              children: [
                                Container(

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'الحالات العامة ',
                                        style: TextStyle( fontFamily: 'exar',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
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
                                                  style: TextStyle( fontFamily: 'exar',
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

                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 40),
                                  child:      activesearch?Container(
                                      child:Center(child:  CircularProgressIndicator(

                                        valueColor:  new AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                                        ,)
                                      )
                                  ):
                                  getstatuslist(),
                                )



                              ],
                            ),

                          )

                      )
                  ),
                ]
            )
        )
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
           
            Text(element.name,
            style:TextStyle(
              fontFamily: 'exar',
            )),
          ],
        ),

        onPressed: () async {setState(() {
          _selectedcities.id=element.id;
          _selectedcities.name=element.name;

        });
        Navigator.of(context).pop();

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

  Widget buildBottomNavigationBar() {
    final isPortrait = MediaQuery
        .of(context)
        .orientation == Orientation.portrait;

    return    BottomNavigationBar(
      currentIndex: counter,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            activeIcon:Icon(Icons.home,color:   Colors.deepPurple,) ,

            icon: Icon(Icons.home,) ,

            label: "الرئيسية"
        ),
        BottomNavigationBarItem(
            activeIcon:Icon(Icons.favorite,color:   Colors.deepPurple,) ,

            icon: Icon(Icons.favorite),label: "حالاتي"
        ),
        BottomNavigationBarItem(
            activeIcon:Icon(Icons.notifications_active,color:   Colors.deepPurple,) ,
            icon: Icon(Icons.notifications_active),label: "اشعاراتي"
        ),

      ],
      onTap: (index){
        setState(() {
          counter=index;
          print('counter'+counter.toString());
        });
      },
    );
  }
  Widget buildtab(double height,double width) {
    final isPortrait = MediaQuery
        .of(context)
        .orientation == Orientation.portrait;
    var  tabs=[
      Center(child:Stack(
        children: [
          Positioned(
            top: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width:5*width/6-20,
                  child: Text(
                    'ملفات المرضى  ',
                    style: TextStyle( fontFamily: 'exar',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  width: width/6-20,

                ),

              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 60),
              height: height-100,
              width: width,
              child: getstatuslist())


        ],
      ),
      ),

      Center(child: MyStatus(),),
      Center(child: MyNotify(),),
    ];
    return  tabs[counter];
  }
  Widget getstatuslist() {

    setState(() {
      widgetlist=[];
      if(offset>0){
        widgetlist.add(
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


                      _fetchPage(offset);

                  });


                },


              ),


            )
        );
      }
      _patientlist.forEach((patient) {

          _cities.forEach((city) {
          if(city.id==int.parse(patient.city)){
            widgetlist.add(
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
                  child: ListTile(
                    leading: Icon(Icons.dehaze_outlined),
                    title:
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween,
                      children: [
                        Row(children: [
                          Icon(Icons.person,
                          color: Colors.black,),
                          Text(patient.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'exar',
                                fontSize: 14
                            ),),
                        ],),

                      ],
                    ),
                    subtitle:      Text(city.name,
                      style: TextStyle( fontFamily: 'exar',
                          fontWeight: FontWeight.bold,

                          fontSize: 14
                      ),),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            PAtientdetail(patient:patient)));
                  },


                ),


              ),);
          }
          });




      });
      widgetlist.add(
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
                    0,  //scroll offset to go
                    duration: Duration(milliseconds: 500), //duration of scroll
                    curve:Curves.fastOutSlowIn //scroll type
                );
                setState(() {
                  offset=offset+10;
                    _fetchPage(offset);

                });


              },


            ),


          )
      );
      activesearch=false;

    });
    if(widgetlist.length==0){
      widgetlist=[];
      if(offset>0){
        widgetlist.add(
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


                    _fetchPage(offset);

                  });


                },


              ),


            )
        );
      }
      return     SingleChildScrollView(
          controller: scrollController,
          child: RefreshIndicator(
            displacement: 20,
            onRefresh: _refreshData,
            child:  Column(
              children:widgetlist,
            ),
          )
      );
    }
    return
      SingleChildScrollView(
          controller: scrollController,
          child: RefreshIndicator(
            displacement: 20,
            onRefresh: _refreshData,
            child:  Column(
              children:widgetlist,
            ),
          )
      );


  }

  Future<void> search() async {
    SharedPreferences shpref= await SharedPreferences.getInstance();
    shpref.setString('search', searchcontroller.text);
    getData();
  }
  Future<void> _fetchPage(int pageKey) async {
    setState(() {
      activesearch=true;
    });
    var response=await CallApi().getallData('getsearchdata/'+searchword+"/"+_city.toString()+"/"+offset.toString());
    var body1 = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      _patientlist=[];
      List<dynamic> patientsarray=body1["patientsarray"];
      patientsarray.forEach((element) {
        _patientlist.add(
            Patient(
              element['id'],
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
      activesearch=false;
      print('respone alldata  '+body1.toString());

    });
    print('respone offset  '+offset.toString());


  }
}

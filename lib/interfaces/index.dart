import 'dart:async';
import 'dart:convert';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/dataaccount.dart';

import 'package:talaqe/interfaces/findpatient.dart';
import 'package:talaqe/interfaces/mystatus.dart';
import 'package:talaqe/main.dart';
import 'package:talaqe/navDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Index extends StatefulWidget{
  const Index({super.key});



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Index();

  }


}
class _Index extends State<Index> with SingleTickerProviderStateMixin{
  List<dynamic> data=[];
  List<City> _cities=[] ;
  bool haveimage=false;
  ScrollController scrollController = ScrollController();
  List<Widget> widgetlist =[];
  final City _selectedcities=City(0, "المدينة");
  final String _url="https://talaqe.org/storage/app/public/";

  static const _pageSize = 10;
  int offset = 0;
  int pagenumber = 0;
int accountid=0;
  String imagepath="";
  DateTime currentBackPressTime=DateTime.now();
  final List<Typetreatment> _Typetreatments =[];
  List<allStatus> _statuseslist =[];
  final List<Patient> _patientlist =[];
  Dentist dentist=Dentist(0, "", "", "", "", "", "", "", "", "","","");
  final Typetreatment _selecttype=Typetreatment(0, "", "");
  int counter = 0;
  TextEditingController searchcontroller = TextEditingController();
  bool statusload=true;
  Container hometab =Container();
  String searchword=" ";
  bool activesearch=false;
  @override
  void initState() {
    // TODO: implement initState

    getData();


    hometab=Container(


    );
    super.initState();
  }
  Future<void> _refreshData() async {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()));
  }


  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";

    int Citees=prefsssss.getInt('citiesss')??0;
    print('datastring$datastring');

    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
        searchcontroller.text="";
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
      var response=await CallApi().getallData("getdata/dentist/$accountid");
      var body = json.decode(utf8.decode(response.bodyBytes));
      print('respone fetchPagewithtrat  $body');
      var dentists=body[0];
      int cityid=0;
      setState(() {

        dentist.id=accountid;
        dentist.name=dentists['name']??"";
        dentist.phone=dentists['phone']??"";
        dentist.university=dentists['university']??"";
        dentist.active=dentists['active']??"";
        dentist.type=dentists['type']??"";
        dentist.identifynumber=dentists['identifynumber']??"";
        dentist.years=dentists['years']??"";
        dentist.city=dentists['city']??"";
        dentist.statusreserv=dentists['statusreserv'].toString()??"";
        dentist.avatar=dentists['avatar']??"";
        dentist.gallorywork=dentists['gallorywork']??"";

        // print('avatareeee'+element['avatar']);

        if(dentists['avatar']!=null){
          haveimage=true;
          imagepath=dentist.avatar;
          int  startIndex = dentist.avatar.indexOf(".");
          String firstpart=dentist.avatar.substring(0, startIndex);
          String lastpart=dentist.avatar.substring(1+startIndex,dentist.avatar.length );
          imagepath="$firstpart-small.$lastpart";
          print("imagepath$imagepath");
        }

      });
      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());
      int? idselectedcities =prefsssss.getInt("_selectedcities");
      setState(() {
        _cities=[];
        for (var element in cities) {
          if(Citees==element['id']){
            _selectedcities.id=element['id'];
            _selectedcities.name=element['name'];
          }
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

      if(_selectedcities.id!=0){
        fetchPagewithcity(0, _selectedcities.id);

      }else{
        _fetchPage(0);
      }
    }
  }
  var items = [
    "الغاء الفلترة"
  ];
Future<void> _fetchPage(int pageKey) async {
  print('respone pageKey  $pageKey');

    var response=await CallApi().getallData("getstatusss/$offset");
    var body = json.decode(utf8.decode(response.bodyBytes));
    List<dynamic> statuslist=body;
    setState(() {
      _statuseslist=[];

      for (var element in statuslist) {
        print("iddddddddsssdddddddddddd${element['id']}");
        _statuseslist.add(


            allStatus(element['id'], element['dentistid'] ?? "",
                element['patientid'] ?? "",
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
      print('respone _statuseslist  ${_statuseslist.length}');

    });
    print('respone offset  $offset');
    setState(() {
      statusload=false;
    });

  }
  Future<void> fetchPagewithtrat(int pageKey,int idtreatment,int cityid) async {
    print('respone pageKeytreat  $pageKey');

    print('respone idtreatment  $idtreatment');
    var response=await CallApi().getallData("getstatusss_withtreat_city/$offset/$idtreatment/$cityid");
    var body = json.decode(utf8.decode(response.bodyBytes));
    print('respone fetchPagewithtrat  $body');

    List<dynamic> statuslist=body;
    setState(() {
      _statuseslist=[];

      for (var element in statuslist) {
        print("iddddddddsss${element['id']}");
        _statuseslist.add(

            allStatus(element['id'], element['dentistid'] ?? "",
                element['patientid'] ?? "",
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


    });
    print('respone offset  $offset');

    setState(() {
      statusload=false;
    });
  }
  Future<void> fetchPagewithcity(int pageKey,int idcity) async {
    print('respone pageKeycity  $pageKey');
    var response=await CallApi().getallData("getstatusss_withcity/$offset/$idcity");
    var body = json.decode(utf8.decode(response.bodyBytes));
    print('respone statuslist  $body');
    List<dynamic> statuslist=body;

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


    });
    print('respone _statuseslist  ${_statuseslist.length}');

    setState(() {
      statusload=false;
    });
  }

  @override
  Widget build(BuildContext context) {
          var screanwidth=MediaQuery.of(context).size.width;
          var screanheight=MediaQuery.of(context).size.height;
    return  MaterialApp(

      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE') // OR Locale('ar', 'AE') OR Other RTL locales
      ],
      theme: ThemeData(
        fontFamily: 'exar',
        visualDensity: VisualDensity.adaptivePlatformDensity, colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple).copyWith(background: Colors.white),
      ),
      home: Scaffold(
          resizeToAvoidBottomInset: false,
            drawer: const NavDrawer(),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              // leading: BackButton(
              //   color: Colors.transparent,
              //   onPressed: () => Navigator.of(context).pop() ,
              // ),
        title:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        const SizedBox(height:25),
                        const Text('مرحبا',
                            style:TextStyle(
                                fontFamily: 'exar',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 17.0)),
                        const SizedBox(width:10),
                        Text( dentist.name,
                            style:const TextStyle(
                                fontFamily: 'exar',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 17.0)),
                      ]
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        _refreshData();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFF9267DD), elevation: 0, backgroundColor: Colors.transparent,
                        padding: EdgeInsets.zero ,
                        shadowColor: Colors.transparent,
                      ),
                      child: Container(
                          padding:const EdgeInsets.all(12.0),
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                              color: const Color(0xFF9267DD),
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child:  const Icon(Icons.refresh,
                              color: Colors.white)
                      ),
                    ),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DataAccount()));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFF9267DD), padding: EdgeInsets.zero, backgroundColor: Colors.transparent ,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: !haveimage?Container(
                          margin: EdgeInsets.zero,
                          padding:const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: const Color(0xFF9267DD),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child:  const Icon(Icons.person,
                              color: Colors.white)):
                      Container(
                          margin: EdgeInsets.zero,
                          padding:const EdgeInsets.all(0.0),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: ClipOval(
                            child:  FadeInImage(
                              image: NetworkImage("https://talaqe.org/storage/app/public/$imagepath"),
                              // height: 200,
                              fit: BoxFit.cover,
                              width: 48,
                              height: 48,
                              placeholder: const AssetImage('asset/im.png'),
                            ),
                          )

                      ),
                    ),
                  ],
                )
                ]
            )
        ),
              backgroundColor:Colors.transparent ,
              elevation: 0,
            ),
          backgroundColor:AppColors.primaryColor,
          bottomNavigationBar:buildBottomNavigationBar(),
          body:WillPopScope(
              onWillPop: onWillPop,
            child: SafeArea(
              child:Column(

                  children:[

                    const SizedBox(height:5),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left:3.0,right: 5),
                          child: Container(
                            width: screanwidth/3-15,
                              height: 52,
                              decoration: BoxDecoration(
                                color:const Color(0xFF9267DD),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: ElevatedButton(
                                style:  ElevatedButton.styleFrom(
                                    elevation: 0, backgroundColor: const Color(0xFF9267DD),
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    )
                                ),
                                onPressed: (){
                                  showModalBottomSheet(context: context,
                                      shape: const RoundedRectangleBorder(
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
                              const Icon(Icons.account_balance_rounded,
                                color: Colors.white,),
                              Text(_selectedcities.name,style: const TextStyle(
                                color: Colors.white, fontFamily: 'exar',
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
                                  decoration: const BoxDecoration(
                                    color:Color(0xFF9267DD),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: TextField(
                                    style: const TextStyle(
                                        color: Colors.white
                                    ),
                                      controller: searchcontroller,
                                    decoration: const InputDecoration(
                                        labelStyle: TextStyle(
                                            color: Colors.white
                                        ),
                                        hintStyle:  TextStyle(
                                            color: Colors.white,
                                          fontFamily: 'exar',
                                        ),
                                        border: InputBorder.none,

                                        hintText:' ابحث عن اسم المريض او رقمه'
                                    ),
                                  )
                              ),
                              Container(height: 53,
                                decoration: const BoxDecoration(
                                  color:Color(0xFF9267DD),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ), ),
                                child: IconButton(onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Findpatient(stringfind:searchcontroller.text,city: _selectedcities.id,)));
                                }, icon: const Icon(Icons.search,
                                  color: Colors.white,),
                                padding: EdgeInsets.zero,),
                              )
                            ],

                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                   getTypetreatmentlist(),
                    const SizedBox(height: 10),
                    Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            borderRadius:  BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),

                          ),
                          child:buildtab(screanheight,screanwidth)

                        )
                    ),
                ]
              )
            ),
          )
        ),
    );
  }
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "اضغط مرتين لاغلاق التطبيق");
      return Future.value(false);
    }
    return Future.value(true);
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
           
            Text(element.name),
          ],
        ),

        onPressed: () async {setState(() {
          _selectedcities.id=element.id;
          _selectedcities.name=element.name;
          offset=0;

        });
        SharedPreferences shpref= await SharedPreferences.getInstance();
        shpref.setInt('citiesss', _selectedcities.id);
        fetchPagewithcity(0,_selectedcities.id);
        Navigator.of(context).pop();

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

      int  startIndex = element.image.indexOf(".");
       String firstpart=element.image.substring(0, startIndex);
       String lastpart=element.image.substring(1+startIndex,element.image.length );
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
                  style:const TextStyle(
                      fontFamily: 'exar',           fontSize: 12
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  FadeInImage(
                    image: NetworkImage("https://talaqe.org/storage/app/public/$firstpart-small.$lastpart"),
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
              offset=0;
            });

            scrollController.animateTo( //go to top of scroll
                0,  //scroll offset to go
                duration: const Duration(milliseconds: 500), //duration of scroll
                curve:Curves.fastOutSlowIn //scroll type
            );
            fetchPagewithtrat(0, _selecttype.id,_selectedcities.id);
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

  Widget buildBottomNavigationBar() {
    final isPortrait = MediaQuery
        .of(context)
        .orientation == Orientation.portrait;

    return    BottomNavigationBar(
      currentIndex: counter,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            activeIcon:Icon(Icons.home,color:   Colors.deepPurple,) ,

            icon: Icon(Icons.home,) ,

            label: ""
        ),
        BottomNavigationBarItem(
            activeIcon:Icon(Icons.favorite,color:   Colors.deepPurple,) ,

            icon: Icon(Icons.favorite),label: ""
        ),
        // BottomNavigationBarItem(
        //     activeIcon:Icon(Icons.notifications_active,color:   Colors.deepPurple,) ,
        //     icon: Icon(Icons.notifications_active),label: ""
        // ),

      ],
      onTap: (index){
        setState(() {
          counter=index;
          print('counter$counter');
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
                    SizedBox(
                      width:5*width/6-20,
                      child: const Text(
                        'الحالات العامة ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'exar',
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width/6-20,
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.settings),
                        // onSelected: choiceAction,
                        itemBuilder: (BuildContext context) {
                          return items.map((String choice) {
                            return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice,
                                  style: const TextStyle(
                                      fontSize: 15
                                  ),),
                                onTap: () async {
                                  setState(() {
                                    _selecttype.id = 0;
                                    offset=0;

                                  });
                                  _fetchPage(0);

                                }
                            );
                          }).toList();
                        },
                      ),
                    ),

                  ],
                ),
              ),

              Container(
                  margin: const EdgeInsets.only(top: 60),
                   height: height-100,
                  width: width,
                  child: getstatuslist()),
              !statusload?Container():
              Container(
                child: const Center(
                    child:  CircularProgressIndicator(

                      valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                      ,)

                ),
              ),


            ],
          ),
        ),

      const Center(child: MyStatus(),),
    ];
    return  tabs[counter];
  }
  Widget getstatuslist() {
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
                    widgetlist.clear();
                    statusload=true;

                    if(_selecttype.id!=0){
                      fetchPagewithtrat(offset,_selecttype.id,_selectedcities.id);
                    }else{
                      fetchPagewithcity(offset, _selectedcities.id);
                    }

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

          statuss='عامة';

        String result = item.created_at.substring(
            0, item.created_at.indexOf('T'));
         widgetlist.add( Container(
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





                },


              ),


            ));


      }
      if(widgetlist.isNotEmpty) {
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
                      duration: const Duration(milliseconds: 500),
                      //duration of scroll
                      curve: Curves.fastOutSlowIn //scroll type
                  );
                  setState(() {

                    statusload=true;
                    widgetlist.clear();
                    offset = offset + 10;
                    pagenumber = pagenumber + 1;
                    if(_selecttype.id!=0){
                      fetchPagewithtrat(offset,_selecttype.id,_selectedcities.id);
                    }else{
                      fetchPagewithcity(offset, _selectedcities.id);
                    }


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

    if(_statuseslist.isEmpty){
      if(offset>0){
        widgetlist.clear();
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

                      statusload=true;
                      widgetlist.clear();
                    offset=offset-10;

                      if(_selecttype.id!=0){
                        fetchPagewithtrat(offset,_selecttype.id, _selectedcities.id);
                      }else{
                        fetchPagewithcity(offset, _selectedcities.id);
                      }
                  });


                },


              ),


            )
        );
        return  SingleChildScrollView(
            controller: scrollController,
            child: RefreshIndicator(
              displacement: 20,
              onRefresh: _refreshData,
              child:  Column(
                children:widgetlist,
              ),
            )
        );
      }else {
        if( !statusload) {
          widgetlist=[];
          return Container(
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.topCenter,
            child: const Text('لا تتوفر حالات عامة حاليا',
              style: TextStyle(
                fontFamily: 'exar',
              ),),
          );
        }
      }
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
  }


import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';

import 'package:flutter/material.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:talaqe/widgets/home_doctors_screen_widgets.dart';

class MyStatusDoctorsScreen extends StatefulWidget {

  const MyStatusDoctorsScreen({Key? key}) : super(key: key);

  @override
  State<MyStatusDoctorsScreen> createState() => _HomeDoctorsScreenState();
}

class _HomeDoctorsScreenState extends State<MyStatusDoctorsScreen> {
  /// Selected category index
  final int _selectedCategoryIndex = 0;
  final List<Typetreatment> _Typetreatments =[];
  List<dynamic> data=[];
  int accountid=0;
  int my=0;
  double height=0;
  ScrollController scrollController = ScrollController();
  bool login=false;

  List<allStatus> _statuseslist =[];
  List<City> _cities=[] ;
  TextEditingController searchcontroller = TextEditingController();
  Dentist dentist=Dentist(0, "", "", "", "", "", "", "", "", "","","");
  final Typetreatment _selecttype=Typetreatment(0, "", "");
  final City _selectedcities=City(0, "المدينة");
  int offset = 0;
  bool statusload=true;
  List<Widget> widgetlist =[];
  @override
  void initState() {
    // TODO: implement initState


    _statuseslist=[];
    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent==scrollController.offset){
        _fetchPage(offset);
      }
    });
    getData();
    super.initState();
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  Future<void> getData() async {
    setState(() {
    _statuseslist.clear();
  });

    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";

    int Citees=prefsssss.getInt('citiesss')??0;
    print('datastring$datastring');

    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
        searchcontroller.text="";
        if(accountid!=0){
          login=true;
        }
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
      if(login) {
        _fetchPage(0);
      }
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();

    setState(() {
      accountid = prefsssss.getInt('accountid') ?? 0;

    });
    print('respone pageKey  $pageKey');
    var data={
      'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
      'offset':offset.toString(),
      'accountid':accountid.toString(),


    };
    var response=await CallApi().postData(data,"getmystatuspages");

    var body = json.decode(utf8.decode(response.bodyBytes));
    print("iddddddddsssdddddddddddd$body");
    Map datatype2 = body[0];
    print('respone datatype2  $body');


    List<dynamic> statuslist = datatype2['statuslast'];
    var dentist=datatype2['dentist'];
    print('respone areas  $dentist');
    var delement=dentist[0];

    setState(() {

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

    });
    print('respone offset  $offset');
    setState(() {
      statusload=false;

        offset=offset+1;
    });

  }

  @override
  Widget build(BuildContext context) {

    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return      Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        centerTitle: false,
        /* <---- Left side widget of appbar ----> */
        title: Container(
          padding: const EdgeInsets.only(top: 10),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              AppGaps.wGap16,
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text("حالاتي",
                      style: TextStyle(fontSize: 18),
                    ),
                    AppGaps.hGap4,
                    Text('يامكانك استعراض الحالات المكتملة ',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 13,
                            color: AppColors.secondaryFontColor,
                            fontWeight: FontWeight.w300)),
                  ],
                ),
              ),
            ],
          ),
        ),
        /* <---- Right side widgets of appbar ----> */

        actions: [
        Container(
          height: 20,
          padding: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
            color:Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
              style:  ElevatedButton.styleFrom(
                elevation: 0, backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: (){
    if(login) {
      Navigator.pushNamed(
          context, AppPageNames.endStatusScreen);
    }
              },
              child:   const Text("الحالات المكتملة",style: TextStyle(
                  color: AppColors.primaryColor, fontFamily: 'exar',
                  fontSize: 12
              ),)
          )
      ),
          // Extra right spaces
          AppGaps.wGap24,
        ],
      ),
      body: login?CustomScaffoldBodyWidget(

        child: _statuseslist.isEmpty? const Center(
            child: Text('لا تتوفر  حالات')
        ):
        RefreshIndicator(
          displacement: 2,
          onRefresh:  getData,
          child: ListView.separated(
            controller: scrollController,
              shrinkWrap: true,
          separatorBuilder: (context, index) => AppGaps.hGap16,
          itemCount:_statuseslist.length+1,
          padding: const EdgeInsets.only(
            top: 15,
            // Bottom extra spaces
            bottom: 30,
          ),
          itemBuilder:getstatuslist

            /// Single doctor data



          ),
        ),
      ):Container(padding: const EdgeInsets.all(30),
    child: Column(
    children: <Widget>[
      Image.asset('asset/logo.png',height: 150,),

    const Text("قم بانشاء حساب لتتمكن من الاستفادة من باقي خدماتنا"),
    CustomStretchedTextButtonWidget(
    buttonText: 'انشاء حساب',
    onTap: () {
    Navigator.pushNamed(
    context, AppPageNames.signInOrSignUpScreen);
    }),
    ],
    ),
    ),
    );
  }

  Widget getstatuslist(BuildContext context,int index) {
        print("fgdfgdfdff${_statuseslist.length}");


    if(index<_statuseslist.length) {
      final state=_statuseslist[index];
      String result="";
      if(state.created_at!="") {
        result = state.created_at.substring(
          0, state.created_at.indexOf('T'));
      }
      String statuss="";


      if(state.status=='end'){
        statuss='مكتملة';
      }
      if(state.status=='accept'){
        statuss='جاري التواصل';
      }
      if(state.status=='accepttreat'){
        statuss=' تحت العلاج';
      }
      return DoctorListTileWidget(
          onTap: () {
        if(state.status=='end') {
          Navigator.pushNamed(
              context, AppPageNames.myStatusScreen,
              arguments: state);
        }else{
          Navigator.pushNamed(
              context, AppPageNames.myStatusScreen,
              arguments: state);
        }
          },
          imageProvider: Image
              .network(CallApi.imgurl +state.imgtreat)
              .image,
          isActive: false,
          name: state.nametreat,
          reviewText: state.patientname,
          designationText: statuss,
          hospitalName: 'تاريخ الإضافة $result');
    }else{
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }



  }
}

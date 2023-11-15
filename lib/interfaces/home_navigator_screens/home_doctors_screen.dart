
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:talaqe/widgets/home_doctors_screen_widgets.dart';

class HomeDoctorsScreen extends StatefulWidget {
  final Object? stringfind;
   const HomeDoctorsScreen({Key? key, this.stringfind}) : super(key: key);

  @override
  State<HomeDoctorsScreen> createState() => _HomeDoctorsScreenState();
}

class _HomeDoctorsScreenState extends State<HomeDoctorsScreen> {
  /// Selected category index
  final int _selectedCategoryIndex = 0;
  final List<Typetreatment> _Typetreatments =[];
  List<dynamic> data=[];
  int accountid=0;
  List<Patient> _patientlist =[];
  int my=0;
  double height=0;
  bool activesearch=true;
  ScrollController scrollController = ScrollController();
  String stringfind="";
  int city=0;
  final List<City> _cities=[] ;
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
    _setChatScreenParameter(widget.stringfind);
    getData();
    _patientlist=[];
    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent==scrollController.offset){
        _fetchPage(offset);
      }
    });

    super.initState();
  }
  Future<void> _fetchPage(int pageKey) async {
    setState(() {
      activesearch=true;
    });
    var response=await CallApi().getallData('getsearchdata/'+stringfind+"/"+city.toString()+"/"+offset.toString());
    var body1 = json.decode(utf8.decode(response.bodyBytes));
    setState(() {
      _patientlist=[];
      List<dynamic> patientsarray=body1["patientsarray"];
      for (var element in patientsarray) {
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

      }
      activesearch=false;
      print('respone alldata  $body1');

    });
    print('respone offset  $offset');


  }
  void _setChatScreenParameter(Object? stringfind1) {
    if (stringfind1 != null && stringfind1 is String) {
      stringfind = stringfind1;
    }

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";


    setState((){
      activesearch=true;
      searchcontroller.text=stringfind;
    });

    print('datastring$datastring');

    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
        city = prefsssss.getInt('citiesss') ?? 0;
      });
      print("account id$accountid");
      print("city id$city");
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

      setState(() {
        for (var element in cities) {

          print("add to _cities $element");

          _cities.add(
              City(element['id'], element['name'] ?? ""));
          if(element['id']==city){
            _selectedcities.id=element['id'];
            _selectedcities.name=element['name'];
          }
        }

      });
      var response1=await CallApi().getallData('getsearchdata/'+stringfind+"/"+city.toString()+"/"+offset.toString());
      print('respone getsearchdata:  ${response1.body}');

      var body1=json.decode(response1.body);
      //_patientlist
      if (body1['success'] == true) {
        setState(() {
          offset=offset+10;
          _patientlist=[];
          List<dynamic> patientsarray=body1["patientsarray"];
          for (var element in patientsarray) {
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

          }
          activesearch=false;
        });

      }



    }
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

    return    Scaffold(
      /* <-------- Appbar --------> */
      appBar: CoreWidgets.appBarWidget(
          screenContext: context, titleWidget: const Text('نتائج البحث ')),
      /* <-------- Content --------> */
      body: CustomScaffoldBodyWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top extra spaces
              AppGaps.hGap15,
              /* <---- Search bar ----> */
              Row(
                children: [
                  Container(
                      width: screenWidth/3-30,
                      height: 52,
                      padding: const EdgeInsets.only(left: 2),
                      decoration: BoxDecoration(
                        color:Colors.transparent,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: ElevatedButton(
                          style:  ElevatedButton.styleFrom(
                              elevation: 0, backgroundColor: AppColors.tertiaryColor,
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
                          child:   Text(_selectedcities.name,style: const TextStyle(
                              color: Colors.white, fontFamily: 'exar',
                              fontSize: 12
                          ),)
                      )
                  ),
                  SizedBox(
                    width: 2*screenWidth/3-20,
                    child: CustomBoxTextFormField(
                        controller: searchcontroller,
                        isFilled: true,
                        hintText: '  ابحث عن اسم المريض او رقمه  ',
                        hintTextStyle: const TextStyle(fontSize: 13),
                        suffixIcon: IconButton(
                            padding: const EdgeInsets.only(left: 10),
                            visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity),
                            onPressed: () {

                              Navigator.pushNamed(
                                  context, AppPageNames.searchPatientScreen,    arguments: searchcontroller.text);
                            },
                            icon: SvgPicture.asset(
                              AppAssetImages.searchDuoColorsIconSVG,
                              width: 20,
                            ))),
                  ),
                ],
              ),
              AppGaps.hGap20,
              (_patientlist.isEmpty)?
                  const Padding(
                   padding: EdgeInsets.symmetric(vertical: 32),
                   child: Center(
                    child: Text("لا يتوفر نتائج"),
                         )):
              SizedBox(
                height:screenHeight-200,
                child: _patientlist.isEmpty? const Center(
                    child: Text('لا تتوفر  نتائج')
                ):
                RefreshIndicator(
                  displacement: 2,
                  onRefresh:  getData,
                  child: ListView.separated(
                      controller: scrollController,
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => AppGaps.hGap16,
                      itemCount:_patientlist.length+1,
                      padding: const EdgeInsets.only(
                        top: 15,
                        // Bottom extra spaces
                        bottom: 30,
                      ),
                      itemBuilder:getstatuslist

                    /// Single doctor data



                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget getstatuslist(BuildContext context,int index) {



    if(index<_patientlist.length) {
      final patient=_patientlist[index];
      String result="";
      if(patient.created_at!="") {
        result = patient.created_at.substring(
          0, patient.created_at.indexOf('T'));
      }
      final args = ModalRoute.of(context)!.settings.arguments as allStatus;
      return DoctorListTileWidget(
          onTap: () {
            Navigator.pushNamed(
                context, AppPageNames.detailPatientScreen,
                arguments: patient);
          },
          imageProvider: Image
              .asset('asset/icons/avatar.png')
              .image,
          isActive: false,
          name: patient.name,
          reviewText: 'الموقع : ${patient.location}',
          designationText:'العمر : ${patient.age}',
          hospitalName: "هاتف : ${patient.phone}");
    }else{
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }



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


}

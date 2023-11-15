import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/typetreatments.dart';

import 'package:talaqe/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_gaps.dart';
import 'package:talaqe/utils/constants/app_images.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:talaqe/widgets/home_doctors_screen_widgets.dart';

import '../data/account.dart';
class FindPersonScrean extends StatefulWidget{


  const FindPersonScrean({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FindPerson();

  }


}
class _FindPerson extends State<FindPersonScrean> with SingleTickerProviderStateMixin{
  List<dynamic> data=[];
  final List<City> _cities=[] ;

  List<Widget> widgetlist =[];
  final City _selectedcities=City(0, "المدينة");
  final String _url="https://talaqe.org/storage/app/public/";
  int accountid=0;
  final List<Typetreatment> _Typetreatments =[];
  final List<Status> _statuseslist =[];
  List<Patient> _patientlist =[];
  Account account =Account(0,"","");
  final Typetreatment _selecttype=Typetreatment(0, "", "");
  int counter = 0;
  TextEditingController searchcontroller = TextEditingController();
  int offset=0;
  Container hometab =Container();
  String searchword=" ";
  int _city=0;
  bool activesearch=false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState

    getData();

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



    print('datastringfffffffffffffffffffffffffffffffffff$datastring');

    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
        _city=prefsssss.getInt('citiesss')??0;

      });
      print("account id$accountid");
      print("city id$_city");
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
          if(element['id']==_city){
            _selectedcities.id=element['id'];
            _selectedcities.name=element['name'];
          }
        }

      });




    }
  }
  var items = [
    "الغاء الفلترة"
  ];
  @override
  Widget build(BuildContext context) {
    var screanwidth=MediaQuery.of(context).size.width;
    var screanheight=MediaQuery.of(context).size.height;

   return Scaffold(
      /* <-------- Appbar --------> */
      appBar: CoreWidgets.appBarWidget(
          screenContext: context, titleWidget: const Text(' البحث عن مريض ')),
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
                      width: screanwidth/3-30,
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
                    width: 2*screanwidth/3-20,
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
                              offset=0;
                              searchword=searchcontroller.text;
                              _city=_selectedcities.id;
                              _fetchPage(0);  },
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
                height:screanheight-200,
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
          onTap: () async {
            SharedPreferences prefsssss = await SharedPreferences.getInstance();

            prefsssss.setString("patientiidd", patient.id.toString());
            prefsssss.setString("patientiiddname", patient.name.toString());

            Navigator.pushNamed(context, AppPageNames.addStatusScreen);
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
          print('counter$counter');
        });
      },
    );
  }

  Future<void> search() async {
    var response1=await CallApi().getallData('getsearchdata/'+searchword+"/"+_city.toString()+"/"+offset.toString());
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
  Future<void> _fetchPage(int pageKey) async {
    setState(() {
      activesearch=true;
    });
    var response=await CallApi().getallData('getsearchdata/'+searchword+"/"+_city.toString()+"/"+offset.toString());
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
}

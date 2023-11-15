import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/account.dart';
import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/tooth.dart';
import 'package:talaqe/main.dart';
import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/patient.dart';

class DetailPatientScreen extends StatefulWidget {
  final Object? argument;
  const DetailPatientScreen({Key? key, this.argument}) : super(key: key);
  @override
  State<DetailPatientScreen> createState() =>
      _DetailPatientScreenState();
}

class _DetailPatientScreenState extends State<DetailPatientScreen> {

  List<dynamic> data=[];
  final List<City> _cities=[] ;
  bool showprogres=true;
  String linkcode="";
  String    gender="ذكر";
  City _selectedcities=City(0, "المدينة");
  final String _url="https://talaqe.org/storage/app/public/";


  final List<allStatus> _statuseslist =[];
  Patient patient=Patient(0, "", "", "", "", "", "", "", "", "", "");
  Account account =Account(0,"","");
  final Typetreatment _selecttype=Typetreatment(0, "", "");
  int counter = 0;
  TextEditingController searchcontroller = TextEditingController();

  Container hometab =Container();
  String searchword=" ";
  bool activesearch=false;
  bool progresss=true;
  @override
  void initState() {
    _setChatScreenParameter(widget.argument);
    // TODO: implement initState
    getData();
    super.initState();
  }
  void _setChatScreenParameter(Object? argument) {
    if (argument != null && argument is Patient) {
      patient = argument;
    }
  }

  Future<void> getData() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();

    String datastring = prefsssss.getString('data') ?? "";


    data = json.decode(datastring);

    Map datatype=data[0];




    List<dynamic> cities = datatype['City'];
    // print('respone areas  ' + data['areas'].toString());

    setState(() {
      for (var element in cities) {

        print("add to areas $element");

        _cities.add(
            City(element['id'], element['name'] ?? ""));
        if(element['id']==int.parse(patient.city)){
          _selectedcities.id=element['id'];
          _selectedcities.name=element['name'] ;
        }
      }
    });
    var response = await CallApi().getallData('getlaststatus/${patient.id}');
    // var body=json.decode(response.body);
    List<dynamic> body = json.decode(utf8.decode(response.bodyBytes));
    print('respone body  ${response.body}');
    setState(() {
      for (var element in body) {
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
                patient.name,
                patient.age,
                patient.gender,
                patient.city,
                patient.location,
                patient.other,
                patient.created_at,
                patient.identifynumber,
                patient.phone,
                patient.email,
                element['notesp'] ?? "") );
      }
    });

    setState(() {
      showprogres=false;
    });
    if(patient.gender=="f"){
      gender="انثى";
    }else{
      gender="ذكر";
    }
  }
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    /// Get screen size
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      /* <-------- Appbar with only back button --------> */
      appBar: CoreWidgets.appBarWidget(
          screenContext: context,
          titleWidget: const Text(' ملف المريض ')),
      /* <-------- Content --------> */
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top extra spaces
            AppGaps.hGap5,
            CustomScaffoldBodyWidget(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [


                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(" اسم المريض : ${patient.name}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    AppGaps.hGap2,
                     Text( " رقم الهاتف : ${patient.phone}"),
                  ],
                ))
              ]),
            ),
            AppGaps.hGap10,
            DecoratedBox(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: AppComponents.hugeBorderRadius),
                  color: AppColors.primaryColor),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomLargeIconButtonWidget(
                          width: screenSize.width < 355 ? 68 : null,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          onTap: () {

                          },
                          child: Image.asset("asset/tooth.png",
                            width:35,)),
                      CustomLargeIconButtonWidget(
                          width: screenSize.width < 355 ? 68 : null,
                          onTap: () {

                          },
                          backgroundColor: Colors.white.withOpacity(0.1),
                          child: const Icon(Icons.image,
                            color: Colors.white,
                            size: 35,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            ColoredBox(
                color: AppColors.primaryColor,
                child: Container(
                  alignment: Alignment.topCenter,
                  decoration: const BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.vertical(
                          top: AppComponents.hugeBorderRadius)),
                  child: CustomScaffoldBodyWidget(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      AppGaps.hGap30,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              constraints: const BoxConstraints(minHeight: 10),
                              child: SvgPicture.asset(
                                  AppAssetImages.personIconSVG,
                                  height: 20)),
                          AppGaps.wGap15,
                          // Label text
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('معلومات المريض ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                AppGaps.hGap10,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(

                                      alignment: Alignment.centerRight,

                                      child: Row(
                                        children: [
                                          const Text("  العمر: " ,
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                          ),
                                          Text( patient.age,
                                            style: const TextStyle(
                                              color:AppColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),

                                    ),
                                    Container(

                                      alignment: Alignment.centerLeft,

                                      child: Row(
                                        children: [
                                          const Text("الجنس: ",
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                            ),),
                                          Text(
                                            gender,
                                            style: const TextStyle(
                                              color:AppColors.primaryColor,
                                            ),),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                AppGaps.hGap4,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Container(

                                      child:  const Text(" المدينة: " ,
                                        style: TextStyle(
                                          color: Color(0xFF000000),
                                        ),
                                      ),

                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(_selectedcities.name,
                                        style: const TextStyle(
                                          color:AppColors.primaryColor,
                                        ),),

                                    ),

                                  ],
                                ),
                                AppGaps.hGap4,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Container(

                                      margin: const EdgeInsets.only(right: 5),

                                      child:  const Text(" الموقع " ,
                                        style: TextStyle(
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      child: Text(patient.location??"",
                                        style: const TextStyle(
                                          color:AppColors.primaryColor,
                                        ),),

                                    ),

                                  ],
                                ),
                                AppGaps.hGap4,
                                Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child:  const Text(" مشاكل صحية اخرى " ,
                                        style: TextStyle(
                                          color: Color(0xFF000000),
                                        ),
                                      ),


                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      alignment: Alignment.center,
                                      child: Text(patient.other??"",
                                        style: const TextStyle(
                                          color:AppColors.primaryColor,
                                        ),),
                                    ),

                                  ],
                                ),
                              ],
                            ),
                          ),


                        ],
                      ),
                      AppGaps.hGap30,
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              constraints: const BoxConstraints(minHeight: 10),
                              child: SvgPicture.asset(
                                  AppAssetImages.personIconSVG,
                                  height: 20)),

                          AppGaps.wGap15,
                          // Label text
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('  السجل الطبي السابق ',
                                    style:
                                    TextStyle(fontWeight: FontWeight.w600)),
                                AppGaps.hGap10,
                                Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child:showprogres?   Container(
                                      child: const Center(
                                          child:  CircularProgressIndicator(

                                            valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                                            ,)

                                      ),
                                    )
                                        : getstatuslist(screenHeight))
                              ],
                            ),
                          ),
                        ],
                      ),
                      AppGaps.hGap30,
                    ],
                  )),
                )),
          ],
        ),
      ),
      /* <-------- Bottom bar --------> */


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
           
            Text(element.name,
                style:const TextStyle(
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
    }
    return SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.only(top: 20),
            child:  Column(
              children: list,
            )
        ));

  }

  Widget getstatuslist(double hight) {
    List<Widget> list =[];
    String stattelast="";
    String typelast="";
    setState(() {
      for (var status in _statuseslist) {


        if(status.type=="general"){

          typelast="عامة";

        }else{
          typelast="خاصة";

        }
        if(status.status=="end"){
          stattelast="مكتملة";

        }
        if(status.status=='accept'){
          stattelast='جاري التواصل';
        }
        if(status.status=='accepttreat'){
          stattelast=' تحت العلاج';
        }
        String result = status.created_at.substring(
            0, status.created_at.indexOf('T'));


        list.add(
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 30,
              // height: 200,

              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), //color of shadow
                    spreadRadius: 2, //spread radius
                    blurRadius: 5, // blur radius
                    offset: const Offset(0, 2), // changes position of shadow
                    //first paramerter of offset is left-right
                    //second parameter is top to down
                  ),
                  //you can set more BoxShadow() here
                ],
              ),
              child:  ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0, backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  // onPrimary: Color(0xFF6A21EA),
                ),
                onPressed: () async {
                  SharedPreferences prefsssss = await SharedPreferences.getInstance();

                  var response=await CallApi().getallData("getstatus/tooth_image/${status.id}");
                  var body = json.decode(utf8.decode(response.bodyBytes));

                  prefsssss.setString('tooth_image', utf8.decode(response.bodyBytes).toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Toothinterf(argument:
                      status
                      )
                      ));


                },
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(

                            alignment: Alignment.centerRight,

                            margin: const EdgeInsets.only(right: 5),

                            child: Row(
                              children: [
                                const Text("  نوع العلاج: ",
                                  style: TextStyle(
                                    fontSize: 12, fontFamily: 'exar',
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                Text(status.nametreat,
                                  style: const TextStyle(
                                    fontSize: 12, fontFamily: 'exar',
                                    color:AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                const Text("الحالة: ",
                                  style: TextStyle(
                                    fontSize: 12, fontFamily: 'exar',
                                    color: Color(0xFF000000),
                                  ),),
                                Text(stattelast,
                                  style: const TextStyle(
                                    fontSize: 12, fontFamily: 'exar',
                                    color:AppColors.primaryColor,
                                  ),),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Container(

                            alignment: Alignment.centerRight,
                            margin: const EdgeInsets.only(right: 5),

                            child:Row(
                              children: [
                                const Text(" النوع: ",
                                  style: TextStyle(
                                    fontSize: 12, fontFamily: 'exar',
                                    color: Color(0xFF000000),
                                  ),),
                                Text( typelast,
                                  style: const TextStyle(
                                    fontSize: 12, fontFamily: 'exar',
                                    color:AppColors.primaryColor,
                                  ),),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [const Text("التاريخ:  ",
                                style: TextStyle(
                                  fontSize: 12, fontFamily: 'exar',
                                  color: Color(0xFF000000),
                                ),),
                                Text(result,
                                  style: const TextStyle(
                                    fontSize: 12, fontFamily: 'exar',
                                    color:AppColors.primaryColor,
                                  ),),],
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(

                      child:         Column(
                        children: [
                          Container(

                            alignment: Alignment.center,

                            child:  const Text(" ملاحظات " ,
                              style: TextStyle(
                                fontSize: 12, fontFamily: 'exar',
                                color: Color(0xff0000000),
                              ),
                            ),

                          ),
                          Container(

                            alignment: Alignment.center,

                            child: Text(status.notes ,                                               style: const TextStyle(
                              fontSize: 12, fontFamily: 'exar',
                              color:AppColors.primaryColor,
                            ),),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child:         Column(
                        children: [
                          Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: [
                              Container(

                                alignment: Alignment.centerRight,

                                child:  const Text(" وصف العلاج المطبق " ,
                                  style: TextStyle(
                                    fontSize: 12, fontFamily: 'exar',
                                    color: Color(0xff0000000),
                                  ),
                                ),

                              ),
                              Container(

                                alignment: Alignment.center,

                                child: Row(
                                  children: [
                                    const Text(" التاريخ:  ",
                                      style: TextStyle(
                                        fontSize: 12, fontFamily: 'exar',
                                        color: Color(0xFF000000),
                                      ),
                                    ),
                                    Text(status.datetreatment,
                                      style: const TextStyle(
                                        fontSize: 12, fontFamily: 'exar',
                                        color:AppColors.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),

                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width-100,
                            child: Text(status.treatment ,                                               style: const TextStyle(
                              fontSize: 12, fontFamily: 'exar',
                              color:AppColors.primaryColor,
                            ),),
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
        );


      }
    });
    if(list.isEmpty){
      return Container(

        color: Colors.transparent,
        alignment: Alignment.topCenter,
        child: const Text("لا يتوفر سجل ",
            style:TextStyle(
              fontFamily: 'exar',
            )),
      );
    }
    return
      Container(
        color: Colors.transparent,
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
                              child: Text('فشل حفظ التعديلات',style: TextStyle( fontFamily: 'exar',),),
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


}

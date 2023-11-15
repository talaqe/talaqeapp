import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/account.dart';
import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/main.dart';
import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GeneralStatusScreen extends StatefulWidget {
  final Object? argument;
  const GeneralStatusScreen({Key? key, this.argument}) : super(key: key);
  @override
  State<GeneralStatusScreen> createState() =>
      _GeneralStatusScreenState();
}

class _GeneralStatusScreenState extends State<GeneralStatusScreen> {
  bool selectspecialtype=false;
  String gender="انثى";
  int numstat=-1;
  bool reservstat=true;
  allStatus status=allStatus(0, "", "", "","","","","","","","","","","","","","","","","","","","","");
  City city=City(0, "");
  final List<Typetreatment> _Typetreatments =[];
  final List<Status> _laststatus =[];
  List<dynamic> data=[];
  bool progressstatus=true;
  String dentisttype="";
  String statte="";
  String type1="";
  String type2="";
  String type3="";
  String special="";
  String stopped="";
  String statustype="";
  final String _url="https://talaqe.org/storage/app/public/";
  int accountid=0;
  int  allowedyear=0;
  String years="primary";
  Account account =Account(0,"","");
  @override
  void initState() {
    _setChatScreenParameter(widget.argument);
    // TODO: implement initState
    getdata();
    super.initState();
  }
  void _setChatScreenParameter(Object? argument) {
    if (argument != null && argument is allStatus) {
      status = argument;
    }
  }

  Future<void> getdata() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";
    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
        dentisttype = prefsssss.getString('dentisttype') ?? "";
        years = prefsssss.getString('yearss') ?? "primary";
        if(years!="primary"){
          reservstat=true;
        }
      });

      print("account id$accountid");
      print("stat id${status.id}");
      Map datatype = data[0];


      List<dynamic> Numststus = datatype['Numststu'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in Numststus) {
          print("add to type1 $element");

          type1=element['type1'].toString()??"";
          type2=element['type2'].toString()??"";
          type3=element['type3'].toString()??"";
          special=element['spacial'].toString()??"";
          stopped=element['stopped'].toString()??"";

        }
      });
      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in cities) {
          print("add to areas $element");

          if(int.parse(status.patientcity)==element['id']){
            city.id=element['id'];
            city.name=  element['name'] ?? "";
          }

        }
      });
      setState((){
        if(status.type=="general"){

          statustype="عامة";

        }else{
          statustype="خاصة";
        }
        if(status.status=="waiting"){

          statte="عامة";

        }
        if(status.status=="end"){
          statte="مكتملة";

        }
        if(status.status=="cancel"){
          statte="ملغية";
        }
        if(status.status=='accept'){
          statte='جاري التواصل';
        }
        if(status.status=='accepttreat'){
          statte=' تحت العلاج';
        }
        // selectspecialtype=true;

        if(dentisttype!="advanced") {
          if(status.nametreat== "حالات خاصة"){
            selectspecialtype=true;
          }
        }
      });
      setState(() {

        progressstatus=false;
      });
      if(status.patientgender=="f"){
        gender="انثى";
      }else{
        gender="ذكر";
      }
    }
    var response=await CallApi().getallData("getstatus/tooth_image/${status.id}");
    var body = json.decode(utf8.decode(response.bodyBytes));

    prefsssss.setString('tooth_image', utf8.decode(response.bodyBytes).toString());

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
          titleWidget: const Text('تفاصيل الحالة ')),
      /* <-------- Content --------> */
      body: SingleChildScrollView(
        child:selectspecialtype? Container(
          child: const Center(
             child: Text("هذه الحالات مخصصة للحسابات من الفئة الذهبية ")
          ),
        ):Column(
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
                    Text(" اسم المريض : ${status.patientname}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    AppGaps.hGap2,
                     Text( " الحالة : ${status.nametreat}"),
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
                            Navigator.pushNamed(
                                context, AppPageNames.toothgeneralStatusScreen,
                                arguments: status);
                          },
                          child: Image.asset("asset/tooth.png",
                            width:35,)),
                      CustomLargeIconButtonWidget(
                          width: screenSize.width < 355 ? 68 : null,
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppPageNames.imagesgeneralStatusScreen,
                                arguments: status);
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
                                  AppAssetImages.clockIconSVG,
                                  height: 20)),
                          AppGaps.wGap15,
                          // Label text
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                const Text('تفاصيل الحالة',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                AppGaps.hGap10,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(

                                      alignment: Alignment.centerRight,
                                      margin: const EdgeInsets.only(right: 5),

                                      child: Row(
                                        children: [
                                          const Text(" النوع : ",
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                            ),
                                          ),
                                          Text(statustype ,
                                            style: const TextStyle(
                                              color:AppColors.primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      alignment: Alignment.centerLeft,
                                      child:Row(
                                        children: [
                                          const Text("الحالة : ",
                                            style: TextStyle(
                                              color: Color(0xFF000000),
                                            ),),
                                          Text(statte,
                                            style: const TextStyle(
                                              color:AppColors.primaryColor,
                                            ),),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                AppGaps.hGap4,
                                Column(
                                  children: [
                                    Container(

                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width-50,
                                      margin: const EdgeInsets.only(right: 5),

                                      child:  const Text(" ملاحظات: " ,
                                        style: TextStyle(
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width-100,
                                      child: Text(status.notes ,                                               style: const TextStyle(
                                        color:AppColors.primaryColor,
                                      ),),
                                    ),

                                  ],
                                ),
                                AppGaps.hGap4,

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
                                          Text( status.patientage,
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
                                      child: Text(city.name,
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
                                      child: Text(status.patientlocation,
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
                                      child: Text(status.patientother,
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

                    ],
                  )),
                )),
          ],
        ),
      ),
      /* <-------- Bottom bar --------> */
      bottomNavigationBar:
      reservstat?
      CustomScaffoldBottomBarWidget(

          child: selectspecialtype? Container(
            child: const Center(
                child: Text("هذه الحالات مخصصة للحسابات من الفئة الذهبية ")
            ),
          ):CustomStretchedTextButtonWidget(
              onTap: () {
                bookstate() ;
              },
              buttonText:'حجز الحالة'))
          :SizedBox(
        width: screenWidth,
        height: 0,
      )


    );
  }

  Future<void> bookstate() async {
    SharedPreferences shpref= await SharedPreferences.getInstance();
    int totalsavestat = shpref.getInt('totalsavestat') ?? 0;
    int accountid = shpref.getInt('accountid') ?? 0;
    String datastring = shpref.getString('data') ?? "";
    print('datastring$datastring');

    data = json.decode(datastring);
    Map datatype=data[0];
    List<dynamic> dentists = datatype['Dentist'];
    bool allowbooking=false;
    setState(() {
      for (var element in dentists) {
        print("add to areas $element");
        if(element['id']==accountid){
          if(element['type']=='normal')
          {
            if(type1!=""){
              if(type1=="all"){
                allowbooking=true;

              }else{
                if(int.parse(element['statusreserv'])<int.parse(type1)){
                  allowbooking=true;
                }
              }
            }
          }
          if(element['type']=='medium') {
            if(type2!=""){
              if(type2=="all"){
                allowbooking=true;

              }else{
                if(int.parse(element['statusreserv'])<int.parse(type2)){
                  allowbooking=true;
                }
              }
            }
          }
          if(element['type']=='advanced')

            if(type3!=""){
              if(type3=="all"){
                allowbooking=true;

              }else{
                if(int.parse(element['statusreserv'])<int.parse(type3)){
                  allowbooking=true;
                }
              }
            }
          if(element['type']=='spacial'){
            if(special!=""){
              if(int.parse(element['statusreserv'])<int.parse(special)){
                allowbooking=true;
              }
            }

          }
          if(element['type']=='stopped'){
            if(stopped!=""){
              if(int.parse(element['statusreserv'])<int.parse(stopped)){
                allowbooking=true;
              }
            }
          }
        }


      }
    });
    if(allowbooking){
      showbookingdialog(context);
    }else{
      showfaildialog(context);
    }
  }
  void showbookingdialog(BuildContext context) {

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
                              child: Text('هل ترغب بحجز هذه الحالة؟ '),
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
                                style: TextStyle(
                                    color:AppColors.primaryColor, fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: ()  async {

                              var data={
                                'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
                                'dentist':accountid,
                                'status':status.id,


                              };
                              var response=await CallApi().postData(data,'booking/status');
                              print('respone :  ${response.body}');
                              var body=json.decode(response.body);

                              if(body.toString()==""){
                                print('respone ssssssssssss ');
                                showfaildialog(context);
                              }
                              else {
                                int bookingstatnum= 0;

                                if (body['success'] == true) {
                                  setState(() {
                                    bookingstatnum = body['statusreserv'] ?? "0";

                                  });
                                  SharedPreferences prefsssss = await SharedPreferences
                                      .getInstance();
                                  prefsssss.setInt("totalsavestat", bookingstatnum);
                                  Navigator.of(dialogContext).pop();
                                  showsuccessdialog(context);
                                }else{
                                  Navigator.of(dialogContext).pop();
                                  showfaildialog(context);
                                }
                              }
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
                            child: Icon(Icons.close, color:AppColors.primaryColor,
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
                              child: Text('قد تجاوزت الحد المسموح في الاسبوع'),
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
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color:AppColors.primaryColor,
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
  void showsuccessdialog(BuildContext context) {

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
                              child: Text('تم حجز الحالة المطلوبة سيتم تحديث معلومات التطبيق '),
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
                                style: TextStyle(
                                    color: AppColors.primaryColor, fontSize: 20.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyApp()));

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
}

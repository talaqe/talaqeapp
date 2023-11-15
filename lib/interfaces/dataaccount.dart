import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:image_picker/image_picker.dart';
import 'package:talaqe/data/account.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/fail.dart';
import 'package:talaqe/interfaces/index.dart';
import 'package:talaqe/interfaces/protifolo.dart';

import '../CallApi.dart';
import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataAccount extends StatefulWidget{
  const DataAccount({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DataAccount();
  }


}
class _DataAccount extends State<DataAccount>{
  List<dynamic> data=[];
  final City _selectedcities=City(0, "المدينة");
  bool haveimage=false;
  final String _url="https://talaqe.org/storage/app/public/";

  String imagepath="";
  late File imageFile=File("");
  int accountid=0;
  String cityname="";
  String univname="";
  String yearsname="";
  String typename="";
  Account account =Account(0,"","");
  Dentist dentist=Dentist(0, "", "", "", "", "", "", "", "", "","","");
  @override
  void initState() {
    // TODO: implement initState
    getdata();
    super.initState();
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
    // TODO: implement build
    return  Scaffold(
      backgroundColor: Colors.white,
      drawer: const NavDrawer(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // backgroundColor: AppColors.primaryColor,
        backgroundColor:Colors.transparent ,
        elevation: 0,
        leading: BackButton(
          color: Colors.white,
          onPressed: () =>   Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Index())),

        ),
        iconTheme: const IconThemeData(
          color: Color(0xFFFFFFFF), //change your color here
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text("معلومات الحساب",style: TextStyle(  color: Color(0xFFFFFFFF),
              fontFamily: 'exar',),),

//0xFF591DC1
            ElevatedButton(
              onPressed: (){
                changeImage();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF9267DD), padding: EdgeInsets.zero, backgroundColor: Colors.transparent ,
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child:
             !haveimage?Container(
                margin: EdgeInsets.zero,
                width: 40,
                padding:const EdgeInsets.only(right: 5,left: 5,top: 12,bottom: 12),
                decoration: BoxDecoration(
                    color: const Color(0xFF9267DD),
                    borderRadius: BorderRadius.circular(30)
                ),
                child:  const Icon(Icons.add_photo_alternate_outlined,
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
                   image: NetworkImage(_url +imagepath),
                   // height: 200,
                   fit: BoxFit.cover,
                   width: 40,
                   height: 40,
                   placeholder: const AssetImage('asset/im.png'),
                 ),
               )

              ),
              ),

          ],
        ),

        //Text(widget.title)
      ),
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: 120,
            margin: const EdgeInsets.only(right: 0,left: 0,top: 0,bottom: 5),
            padding: const EdgeInsets.only(top: 50,right:50,left: 50 ),
            color: AppColors.primaryColor,


          ),
          Container(

              margin: const EdgeInsets.only(top: 90,bottom: 0,left:0 ,right: 0),
              alignment: Alignment.topCenter,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:  BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.only(top: 60.0,left: 0.0,right: 0.0,bottom: 0.0),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text("الاسم: ",style: TextStyle(
                              fontFamily: 'exar',
                            ),),
                            subtitle:Text(dentist.name,
                              style: const TextStyle(
                                fontFamily: 'exar',
                              ),) ,),
                          ListTile(
                            leading: const Icon(Icons.apartment),
                            title: const Text("الجامعة:  ",style: TextStyle(
                              fontFamily: 'exar',
                            ),),
                            subtitle:Text(univname,
                              style: const TextStyle(
                                fontFamily: 'exar',
                              ),) ,),


                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: const Text("رقم الهاتف: ",style: TextStyle(
                              fontFamily: 'exar',
                            ),),
                            subtitle:Text(dentist.phone,
                              style: const TextStyle(
                                fontFamily: 'exar',
                              ),) ,),
                          ListTile(
                            leading: const Icon(Icons.account_balance_rounded),
                            title: const Text("المدينة: ",style: TextStyle(
                              fontFamily: 'exar',
                            ),),
                            subtitle:Text(cityname,
                              style: const TextStyle(
                                fontFamily: 'exar',
                              ),) ,),

                          ListTile(
                            leading: const Icon(Icons.dashboard_customize),
                            title: const Text(" السنة الدراسية: ",style: TextStyle(
                              fontFamily: 'exar',
                            ),),
                            subtitle:Text(yearsname,
                              style: const TextStyle(
                                fontFamily: 'exar',
                              ),) ,),
                          ListTile(
                            leading: const Icon(Icons.list_alt),
                            title: const Text("عددالحالات المحجوزة: ",style: TextStyle(
                              fontFamily: 'exar',
                            ),),
                            subtitle:Text(dentist.statusreserv,
                              style: const TextStyle(
                                fontFamily: 'exar',
                              ),) ,),
                          ListTile(
                            leading: const Icon(Icons.list_alt),
                            title: const Text("  نوع الحساب: ",style: TextStyle(
                              fontFamily: 'exar',
                            ),),
                            subtitle:Text(typename,
                              style: const TextStyle(
                                fontFamily: 'exar',
                              ),) ,),

                        ],
                      ),
                    ),))
          )
        ],
      ),

   bottomNavigationBar:  TextButton(
     style: TextButton.styleFrom(
       foregroundColor: Colors.white, shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.all(Radius.zero)),
       padding: const EdgeInsets.symmetric(
           horizontal: 40.0, vertical: 15.0) ,
       backgroundColor:AppColors.primaryColor,
     ),
     onPressed: () {
       Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => Protifolio(dentist: dentist,)));
     },
     child: const Text('معرض الأعمال الشخصي ',
     style:TextStyle( fontFamily: 'exar',)),
   ),
      //Text(widget.title)
    );
  }

  Future<void> getdata() async {

    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";
    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
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
        dentist.statusreserv=dentists['statusreserv']??"";
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

      Map datatype = data[0];

      List<dynamic> cities = datatype['City'];
      // print('respone areas  ' + data['areas'].toString());
      setState(() {
        for (var element in cities) {

          print("add to areas $element");

          if(element['id']==int.parse(dentist.city)){
            _selectedcities.id=element['id'];
            _selectedcities.name=element['name'] ;
            cityname=element['name'];
          }
        }
      });
      List<dynamic> universities = datatype['University'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in universities) {
          print("add to areas $element");
          if(element['id']==int.parse(dentist.university)) {
           univname=element['name'];

          }
        }
      });
      if(dentist.type=='normal'){
typename="عادي";
      }else if(dentist.type=="medium"){
        typename="فضي";

      }else{
        typename="ذهبي";

      }
    }
    if(dentist.years=="primary"){
      yearsname="سنة اولى/ثانية/ثالثة";

    }else if(dentist.years=='forth'){
      yearsname="سنة رابعة";
    }else if(dentist.years=='fifth'){
      yearsname="سنة خامسة";
    }else if(dentist.years=='excellent'){
      yearsname="امتياز ";
    }else if(dentist.years=='master'){
      yearsname="ماستر ";
    }

    }

  Future<void> changeImage() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      Map<String, String> iddata = {

        'id': accountid.toString()};

      var response2 = await CallApi().addImagedentist(iddata, imageFile.path);
      print('responedddddd :  $response2');
      var body=json.decode(response2);
      SharedPreferences prefsssss = await SharedPreferences.getInstance();

      prefsssss.setString("imagedintest", body["success"]);
      String image=body["success"];
   setState(() {
     int  startIndex =image.indexOf(".");
     String firstpart=image.substring(0, startIndex);
     String lastpart=image.substring(1+startIndex,image.length );
     imagepath="$firstpart-small.$lastpart";
     print("imagepath$imagepath");
   });
      _refreshData();
    }
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
      getdata();

    }

  }
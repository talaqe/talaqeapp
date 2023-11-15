import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:talaqe/data/Gallorywork.dart';
import 'package:talaqe/data/imagework.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/scans.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/toothes.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/fail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talaqe/interfaces/FullScrean.dart';
import 'package:talaqe/interfaces/dataaccount.dart';
import 'package:talaqe/interfaces/showprotifolio.dart';
import '../CallApi.dart';
import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Imageprotiflio extends StatefulWidget{
  int like=0;
  Gallorywork gallorywork;
  Imageprotiflio({super.key, required this.gallorywork,this.like=0});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _Imageprotiflio();
  }


}
class _Imageprotiflio extends State<Imageprotiflio>{
  int _like=0;

  Gallorywork gallorywork=Gallorywork(0, "", "", "", "", "", "", "", "","","");
  String addtodoc="";
  bool ifadd=false;
  bool progresss=true;
  late File imageFile=File("");
  bool prograss=false;
  // Status status=Status(0, "", "", "", "", "", "", "", "", "", "");
  Patient patient=Patient(0, "", "", "", "", "", "", "", "", "", "");
  Typetreatment typetreatment=Typetreatment(0, "", "");
  final String _url="https://talaqe.org/storage/app/public/";
  final List<Scans> _scans =[];
  List<Imagegallory> _Imagegallorys =[];
  int numimage=-1;
  int accountid=0;

  Color colorsl=const Color(0xfffffffff);

  List<dynamic> data=[];
  Gallorywork galory=Gallorywork(0, "", "", "", "", "", "", "", "","","");
  @override
  void initState() {
    // TODO: implement initState
    gallorywork=widget.gallorywork;
    _like=widget.like;
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
      key: const ValueKey(6),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFE5E5E5),
      appBar: AppBar(
        title:    Container(
          color:AppColors.primaryColor,
          margin: const EdgeInsets.only(top: 15),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  alignment: Alignment.center,
                  child:   const Text("تفاصيل الحالة",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'exar',
                        color: Color(0xFFFFFFFF)
                    ),
                  ),

                ),
                GestureDetector(
                  onTap: () {
                    setfavorate(gallorywork.id);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 14.0,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.favorite, color:  colorsl),
                    ),
                  ),
                ),
              ]
          ),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop() ,
        ),
        backgroundColor:Colors.transparent ,
        elevation: 0,
      ),
      body:Stack(
          children:[
            Container(
              width: screenWidth,
              height: screenHeight/3,
              margin: const EdgeInsets.only(right: 0,left: 0,top: 0,bottom: 5),
              padding: const EdgeInsets.only(top: 50,right:50,left: 50 ),
              color: AppColors.primaryColor,


            ),


            Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(top: 120,bottom: 5,left:0 ,right: 0),
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topCenter,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                ),
                child:  !prograss?   SingleChildScrollView(

                    child:  Stack(children:[
                       Container(
                        margin: const EdgeInsets.only(top: 10,right: 10,left: 10),

                      ),
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.center,
                          child: const Text("  وصف الحالة",
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'exar',
                                fontWeight: FontWeight.bold,
                                color:AppColors.primaryColor
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(5),
                          margin: const EdgeInsets.only(bottom: 10,right: 20,left: 20,top: 10),

                          child:SingleChildScrollView(child: Text(gallorywork.text,
                          style:const TextStyle( fontFamily: 'exar',))),
                        ),
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.remove_red_eye),
                                  const SizedBox(width: 16,),
                                  Text(gallorywork.views,style:const TextStyle(
                                    fontFamily: 'exar',
                                  ))
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [
                                  const Icon(Icons.favorite),
                                  const SizedBox(width: 22,),
                                  Text(gallorywork.likes,
                                  style:const TextStyle(
                                    fontFamily: 'exar',
                                  ))
                                ],
                              ),
                            )
                          ],
                        ),

                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          alignment: Alignment.center,
                          child: const Text("  صور الحالة",
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'exar',
                                fontWeight: FontWeight.bold,
                                color:AppColors.primaryColor
                            ),
                          ),
                        ),
                        progresss?
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          child: const Center(
                              child:  CircularProgressIndicator(

                                valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                                ,)

                          ),
                        ):     Container(
                            margin: const EdgeInsets.only(bottom: 0,right: 0,left: 0,top: 10),
                            child: getlaststatuslist(context))

                      ],
                    )
                    ]
                    )
                )

                    :  Container(


                    child:const Center(child:  CircularProgressIndicator(

                      valueColor:  AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                      ,)
                    )
                )
            )
          ]),

    ); }


  Future<void> getdata() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";

      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
      });
      print("account id$accountid");

      Map datatype = data[0];
    _Imagegallorys=[];
      var response2=await CallApi().getallData("getgalloryimage/${gallorywork.id}");
      var body = json.decode(utf8.decode(response2.bodyBytes));

      print('dddddddddddddddddddddddddddd$body');
      List<dynamic> imagegals =body;
      setState(() {
        for (var element in imagegals) {
          print("add to _Imagegallorys $element");
          _Imagegallorys.add(
              Imagegallory(element['id'], element['image'] ?? "",
                  element['protiflioid'] ?? ""
              ));
        }
      });






   if(_like==1)
{
  colorsl=const Color(0xFFA54DD4);

}

      setState(() {
        progresss=false;
      });
  }
  Widget getlaststatuslist(BuildContext context) {
    List<Widget> list = [];
   if(progresss==true){
    return Container();
   }
    for (var element in _Imagegallorys) {
      print('ddddfsd${element.image}');
      numimage=numimage+1;
      int  startIndex = element.image.indexOf(".");
      String firstpart=element.image.substring(0, startIndex);
      String lastpart=element.image.substring(1+startIndex,element.image.length );
      String  imagepath="$firstpart-small.$lastpart";
      print("imagepath$imagepath");
      list.add(
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width - 50,
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
          child:  Column(
            children: [
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FullScrean(link:element.image ,)));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0x006a21ea), elevation: 0, backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white
                  ),
                  alignment: Alignment.center,
                  child: FadeInImage(
                    image: NetworkImage(_url + imagepath),
                    // height: 200,
                    fit: BoxFit.cover,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width-70 ,
                    height: 250,
                    placeholder: const AssetImage('asset/im.png'),
                  ),


                ),
              ),

            ],
          ),
        ),


      );

    }

    if(list.isNotEmpty) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom:0, right: 0, left: 0,top: 30),

        child: Column(
            children: list
        ),
      );
    }else{
      return Container(
        margin: const EdgeInsets.only(top: 40),
        child: const Center(
          child: Text('لاتتوفر صور حاليا',
            style:TextStyle( fontFamily: 'exar',)
          ),
        ),
      );
    }
  }

  Future<void> uploadimage() async {
    Map<String, String> iddata = {

      'id': gallorywork.id.toString()};

    var response2 = await CallApi().addImagegallory(iddata, imageFile.path);
    print('respone :  $response2');
    setState((){
      prograss=false;
    });
    _refreshData();
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
    setState((){
      prograss=false;
    });
  }
  Future<void> _refreshDataend() async {
    try {
      var data={
        'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
        'galloryworkid':gallorywork.id,


      };
      var response=await CallApi().postData(data,'addtodoctor/status');
      print('respone :  ${response.body}');
      var body=json.decode(response.body);

      var responsee = await CallApi().getallData('alldata');
      // var body=json.decode(response.body);
      var bodyr = json.decode(utf8.decode(response.bodyBytes));
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
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DataAccount()));
  }

  Future<void> setfavorate(int galloryid) async {
    if( colorsl!= const Color(0xFFA54DD4)) {
      setState(() {
        colorsl = const Color(0xFFA54DD4);
      });
      var data = {
        'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
        'galloryid': galloryid.toString(),
        'dentistid': accountid.toString(),


      };
      var response = await CallApi().postData(data, 'gallorywork/setlike');
      setState((){
        gallorywork.likes=(int.parse(gallorywork.likes)+1).toString();
      });
      print('respone :  ${response.body}');
    }else{
      setState(() {
        colorsl = const Color(0xFFFFFFFF);
      });
      var data = {
        'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
        'galloryid': galloryid.toString(),
        'dentistid': accountid.toString(),


      };
      var response = await CallApi().postData(data, 'gallorywork/remove');
setState((){
  gallorywork.likes=(int.parse(gallorywork.likes)-1).toString();

});
      print('respone :  ${response.body}');
    }
  }
  Future<void> reooveformdoc() async {
    var data={
      'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
      'galloryworkid':gallorywork.id,


    };
    var response=await CallApi().postData(data,'removeodoctor/status');
    print('respone :  ${response.body}');
    var body=json.decode(response.body);
  }
}


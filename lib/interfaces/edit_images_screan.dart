import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;


import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/scans.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/fail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talaqe/interfaces/FullScrean.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import '../CallApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Edit_ImageScrean extends StatefulWidget{

 final Object? argument;
 const Edit_ImageScrean({Key? key, this.argument}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _Edit_Imageinterfac();
  }


}
class _Edit_Imageinterfac extends State<Edit_ImageScrean>{
  allStatus status=allStatus(0, "", "", "","","","","","","","","","","","","","","","","","","","","");
  late File imageFile=File("");

  bool prograss=false;
  Typetreatment typetreatment=Typetreatment(0, "", "");
  final String _url="https://talaqe.org/storage/app/public/";
  List<Scans> _scans =[];
  int numimage=-1;
  int accountid=0;
  List<dynamic> data=[];
  @override
  void initState() {
    // TODO: implement initState
    _setChatScreenParameter(widget.argument);

    getdata();
    super.initState();
  }
  void _setChatScreenParameter(Object? argument) {
    if (argument != null && argument is allStatus) {
      status = argument;
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
                Column(
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          const SizedBox(height:25),
                          const Text(' المريض:',
                              style:TextStyle(
                                  fontFamily: 'exar',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17.0)),
                          const SizedBox(width:10),
                          Text( status.patientname,
                              style:const TextStyle(
                                  fontFamily: 'exar',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 17.0)),
                        ]
                    ),

                  ],
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
                        margin: const EdgeInsets.only(top: 0),
                        width: screenWidth,
                        alignment: Alignment.center,
                        child:   const Text("صور الاشعة",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'exar',
                              color:AppColors.primaryColor
                          ),
                        ),

                      ),
                      getlaststatuslist(context)

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
      bottomNavigationBar: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white, shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.zero)),
          padding: const EdgeInsets.symmetric(
              horizontal: 40.0, vertical: 15.0)  ,
          backgroundColor: AppColors.primaryColor,
        ),
        onPressed: () {
          _getFromGallery();
        },
        child: const Text(' ارفاق صور',style:TextStyle( fontFamily: 'exar',)),
      ),
    ); }

  _getFromGallery() async {
    if (kIsWeb) {
      // running on the web!
      final Uri url = Uri.parse(
          'https://talaqe.org/api/uploadimg/${status.id}/toothimg');
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }

    }
    else {
      setState(() {
        prograss = true;
      });
      PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
        uploadimage();
      }
    }
  }
  Future<void> getdata() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('tooth_image') ?? "";
    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
      });
      print("account id$accountid");
      List<dynamic> datatype = json.decode(datastring);
      var data1 = datatype[0];
      print("data$data1");


      List<dynamic> scans = data1['scans'];
      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        _scans=[];
        for (var element in scans) {
          print('respone scansa  ${element['id']}');
           _scans.add(
                Scans(
                    element['id'],
                    element['patientid'].toString() ?? "",
                    element['image'] ?? "",
                    element['created_at'] ?? ""

                ));

        }
      });



    }
  }
  Widget getlaststatuslist(BuildContext context) {
    List<Widget> list = [];

    for (var element in _scans) {

      String result = element.created_at.substring(
          0, element.created_at.indexOf('T'));
      numimage=numimage+1;
      int  startIndex = element.image.indexOf(".");
      String firstpart=element.image.substring(0, startIndex);
      String lastpart=element.image.substring(1+startIndex,element.image.length );
      String  imagepath="$firstpart-small.$lastpart";
      list.add(
        Container(
          width: MediaQuery
              .of(context)
              .size
              .width - 50,
          padding: const EdgeInsets.all(5),

          margin: const EdgeInsets.only(bottom: 10, right: 15, left: 15),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(" تاريخ الإضافة : ",
                    style: TextStyle(
                      fontFamily: 'exar',
                      color: Color(0xFF000000),
                    ),
                  ),
                  Text(result,
                    style: const TextStyle(
                      fontFamily: 'exar',
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

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
                        image: NetworkImage(_url +imagepath),
                        // height: 200,
                        fit: BoxFit.cover,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width-111 ,
                        height: 250,
                        placeholder: const AssetImage('asset/im.png'),
                      ),


                    ),
                  ),

                ],
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
            style:TextStyle(
              fontFamily: 'exar',
            )
          ),
        ),
      );
    }
  }

  Future<void> uploadimage() async {
    Map<String, String> iddata = {
      'statusid': status.id.toString(),
      'patientid': status.patientid.toString()};


    var response2 = await CallApi().addImagepatient(iddata, imageFile.path);
    print('respone :  $response2');
        setState((){
          prograss=false;
        });
    _refreshData();
  }
  Future<void> _refreshData() async {
    try {
      var response=await CallApi().getallData("getstatus/tooth_image/${status.id}");
      var body = json.decode(utf8.decode(response.bodyBytes));
      print('respone tooth_image  ${response.body}');
      SharedPreferences shpref= await SharedPreferences.getInstance();
      shpref.setString('tooth_image', utf8.decode(response.bodyBytes).toString());
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

}
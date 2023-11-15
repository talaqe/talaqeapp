import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:talaqe/utils/constants/app_colors.dart';

import 'package:talaqe/data/imagework.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/scans.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/fail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talaqe/interfaces/FullScrean.dart';
import 'package:talaqe/interfaces/dataaccount.dart';
import '../CallApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddImageprotiflio extends StatefulWidget{
  int protifloid=0;
  AddImageprotiflio({super.key, this.protifloid=0});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _AddImageprotiflio();
  }


}
class _AddImageprotiflio extends State<AddImageprotiflio>{
  int _protilflioid=0;
  bool ifadd=false;

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
  List<dynamic> data=[];
  @override
  void initState() {
    // TODO: implement initState
    _protilflioid=widget.protifloid;
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
                  child:   const Text("صور المعرض",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'exar',
                        color: Color(0xFFFFFFFF)
                    ),
                  ),

                ),
                ElevatedButton(
                  onPressed: (){
                    _getFromGallery();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF9267DD), padding: EdgeInsets.zero, backgroundColor: Colors.transparent ,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: Container(
                      margin: EdgeInsets.zero,
                      padding:const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          color: const Color(0xFF9267DD),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      child:  const Icon(Icons.add,
                          color: Colors.white)
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
      bottomNavigationBar: Row(
        children: [
          SizedBox(
            width: screenWidth/2,
            child:  TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF591DC1), shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 5.0, vertical: 15.0) ,
                backgroundColor:  const Color(0xFFFFFFFF),
              ),
              onPressed: () {
           showsuccessdialog(context);
              },
              child:const Text('حفظ وعودة للمعرض',
              style: TextStyle(
                fontFamily: 'exar',
              ),),
            ),
          ),
          SizedBox(
            width: screenWidth/2,

            child:  TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white, shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 5.0, vertical: 15.0)  ,
                backgroundColor: AppColors.primaryColor,
              ),
              onPressed: () {
                if(ifadd){
                  reooveformdoc();
                }
              else{
                  _refreshDataend();
                }

              },
              child:ifadd?const Text('ازالة من معرض الاطباء',
              style: TextStyle( fontFamily: 'exar',),) :
              const Text('إضافة لمعرض الاطباء',
              style: TextStyle( fontFamily: 'exar',),),
            ),
          )
        ],
      )
    ); }

  _getFromGallery() async {
    setState((){
      prograss=true;
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
  Future<void> getdata() async {
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";
    var response2=await CallApi().getallData("getimagegallorysingle/$_protilflioid");

    var body = json.decode(utf8.decode(response2.bodyBytes));
    print('respone areas  $body');

    Map datatype1=body[0];
    List<dynamic> gallorylist = datatype1['Gallorywork'];
    List<dynamic> Imagegallorys = datatype1['Imagegallory'];
    if (datastring != "") {
      data = json.decode(datastring);
      setState(() {
        accountid = prefsssss.getInt('accountid') ?? 0;
      });
      print("account id$accountid");

      Map datatype = data[0];

      // print('respone areas  ' + data['areas'].toString());

      setState(() {
        for (var element in gallorylist) {
          print("add to gallorylist $element");

          if(_protilflioid==element['id']) {

            if(element['addtodoctorlist']=="0"){
              ifadd=false;

            }else{
              ifadd=true;
            }
          }
        }

      });







      // print('respone areas  ' + data['areas'].toString());
      setState(() {
        _Imagegallorys=[];
        for (var element in Imagegallorys) {
          print("add to areas $element");
              if(_protilflioid==int.parse( element['protiflioid']))
       {
         _Imagegallorys.add(
             Imagegallory(element['id'], element['image'] ?? "",
                 element['protiflioid'] ?? ""
             ));
       }
        }
      });



    }
  }
  Widget getlaststatuslist(BuildContext context) {
    List<Widget> list = [];

    for (var element in _Imagegallorys) {
        print('ddddfsd${element.image}');
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
          child:  ElevatedButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FullScrean(link:element.image ,)));
              },
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0x006a21ea), elevation: 0, backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: Column(
              children: [
                Container(
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
                        .width-70 ,
                    height: 250,
                    placeholder: const AssetImage('asset/im.png'),
                  ),


                ),

              ],
            ),
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
            style: TextStyle( fontFamily: 'exar',),
          ),
        ),
      );
    }
  }

  Future<void> uploadimage() async {
    Map<String, String> iddata = {

      'id': _protilflioid.toString()};

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
        'galloryworkid':_protilflioid,


      };
      var response=await CallApi().postData(data,'addtodoctor/status');
      print('respone :  ${response.body}');
      var body=json.decode(response.body);


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
    showsuccessdialog( context);
  }

  Future<void> reooveformdoc() async {
    var data={
      'api_key': 'KeygH9vj6sMwkTP_MZBdEBGtM8g1ob3Go1uG5v',
      'galloryworkid':_protilflioid,


    };
    var response=await CallApi().postData(data,'removeodoctor/status');
    print('respone :  ${response.body}');
    var body=json.decode(response.body);
    showsuccessremovedialog( context);
  }
  void showsuccessremovedialog(BuildContext context) {

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
                              child: Text('تم حذف الحالة من معرض الاطباء',
                                style: TextStyle( fontFamily: 'exar',),),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const DataAccount()) );

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
                              child: Text('تم اضافة الحالة لمعرض الاطباء ',
                              style: TextStyle( fontFamily: 'exar',),),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const DataAccount()) );

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
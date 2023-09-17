import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:talaqe/data/alldatastatus.dart';
import 'package:talaqe/data/patient.dart';
import 'package:talaqe/data/product.dart';
import 'package:talaqe/data/scans.dart';
import 'package:talaqe/data/statuses.dart';
import 'package:talaqe/data/toothes.dart';
import 'package:talaqe/data/typetreatments.dart';


import 'package:talaqe/fail.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talaqe/interfaces/FullScrean.dart';
import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import '../CallApi.dart';
import '../navDrawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Edit_ImageProductsScrean extends StatefulWidget{

 final Object? argument;
 Edit_ImageProductsScrean({Key? key, this.argument}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _Edit_Imageinterfac();
  }


}
class _Edit_Imageinterfac extends State<Edit_ImageProductsScrean>{
int productid=0;
  late File imageFile=File("");
Product product = Product(0, "", "","","","","","","","","","","");

bool prograss=false;
  Typetreatment typetreatment=new Typetreatment(0, "", "");
  String _url="https://talaqe.org/storage/app/public/";
  List<String> _scans =[];
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
    if (argument != null && argument is Product) {
      product = argument;
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
      key: ValueKey(6),
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xFFFFFFFF),
      appBar: CoreWidgets.appBarWidget(
          screenContext: context, titleWidget: const Text('  ارفاق صور')),
      body:SingleChildScrollView(
        child: Column(
            children:[



              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 120,bottom: 5,left:0 ,right: 0),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius:  BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                  ),
                  child:  !prograss?   SingleChildScrollView(

                      child:  Stack(children:[
                        Container(
                          margin: EdgeInsets.only(top: 0),
                          width: screenWidth,
                          alignment: Alignment.center,
                          child:   Text("معرض الصور ",
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
                  child:Center(child:  CircularProgressIndicator(

                    valueColor:  new AlwaysStoppedAnimation<Color>(Color(0xFF6F1CE6))
                    ,)
                  )
              )
              )
            ]),
      ),
      bottomNavigationBar: Row(
        children: [
          Container(
            width: screenWidth/2,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero)),
                padding: EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 15.0),
                primary:Colors.white  ,
                backgroundColor: AppColors.primaryColor,
              ),
              onPressed: () {
                _getFromGallery();
              },
              child: Text(' ارفاق صور',style:TextStyle( fontFamily: 'exar',)),
            ),
          ),
          Container(
            width: screenWidth/2,

            child: TextButton(
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.zero)),
                padding: EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 15.0),
                primary:AppColors.primaryColor  ,
                backgroundColor:AppColors.backgroundColor,
              ),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, AppPageNames.DetailMyproductScrean, (_) => false);
                            },
              child: Text('  حفظ وانهاء',style:TextStyle( fontFamily: 'exar',)),
            ),
          ),
        ],
      ),
    ); }

  _getFromGallery() async {
    if (kIsWeb) {
      // running on the web!
      final Uri _url = Uri.parse(
          'https://talaqe.org/api/uploadimg/' + product.id.toString() + '/toothimg');
      if (!await launchUrl(_url)) {
        throw Exception('Could not launch $_url');
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
    setState(() {
      accountid = prefsssss.getInt('accountid') ?? 0;
    });
   print("product.imgs"+product.imgs);
    List<dynamic> dataimgs= json.decode(product.imgs);
    setState(() {
      dataimgs.forEach((element) {
        _scans.add(element);
      });
    });

  }
  Widget getlaststatuslist(BuildContext context) {
    List<Widget> list = [];

    _scans.forEach((element) {


      numimage=numimage+1;
      int  startIndex = element.indexOf(".");
      String firstpart=element.substring(0, startIndex);
      String lastpart=element.substring(1+startIndex,element.length );
      String  imagepath=firstpart+"-small."+lastpart;
      list.add(Container(
        width: MediaQuery
            .of(context)
            .size
            .width - 50,
        padding: EdgeInsets.all(5),

        margin: EdgeInsets.only(bottom: 10, right: 15, left: 15),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), //color of shadow
              spreadRadius: 2, //spread radius
              blurRadius: 5, // blur radius
              offset: Offset(0, 2), // changes position of shadow
              //first paramerter of offset is left-right
              //second parameter is top to down
            ),
            //you can set more BoxShadow() here
          ],
        ),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.only(top: 0.0, right: 0.0),
              decoration: BoxDecoration(
                  color: Colors.white,


                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 0.0,
                      offset: Offset(0.0, 0.0),
                    ),
                  ]),
              child:   Column(
                children: [

                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FullScrean(link:element ,)));
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      primary: Colors.transparent,
                      onPrimary: Color(0x6A21EA),
                    ),
                    child: Container(

                      decoration: BoxDecoration(
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
                        placeholder: AssetImage('asset/im.png'),
                      ),


                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0.0,
              child: GestureDetector(
                onTap: () {
                        deleteimg(element);
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    radius: 14.0,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: AppColors
                        .primaryColor,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ));
  

    });

    if(!list.isEmpty) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(bottom:0, right: 0, left: 0,top: 30),

        child: Column(
            children: list
        ),
      );
    }else{
      return Container(
        margin: EdgeInsets.only(top: 40),
        child: Center(
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
      'id': product.id.toString(),

    };

    var response2 = await CallApi().addImagesproduct(iddata, imageFile.path);
    print('respone addImagesproduct:  ' + response2.toString());
        setState((){
          prograss=false;
        });
    _refreshData();
  }
  Future<void> _refreshData() async {
    try {
      var response=await CallApi().getallData("product/getimges/"+product.id.toString());
      var body = json.decode(utf8.decode(response.bodyBytes));
     setState(() {
       product.imgs= utf8.decode(response.bodyBytes).toString();
     });
    } on TimeoutException catch (_) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Fail()));
    }
    on SocketException catch (_) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Fail()));
    }
    getdata();
    setState((){
      prograss=false;
    });
  }

  Future<void> deleteimg(String imagepath) async {
    var data = {'api_key': 'fYqUL6SU6bMJ_K4z9Nbb1TACyz1GZ7jbPgG',
      'id': product.id,
      'img': imagepath,

    };
    var response = await CallApi().postData(data,'product/deleteimges');
    var body = json.decode(utf8.decode(response.bodyBytes));

    setState(() {
      product.imgs= utf8.decode(response.bodyBytes).toString();
      prograss=false;
    });
    showsuccessdialog();


  }
void showsuccessdialog() {

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
              margin: EdgeInsets.only(left: 0.0, right: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(top: 0.0, right: 0.0),
                    decoration: BoxDecoration(
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
                          margin: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text('تمت العملية بنجاح',
                                style: TextStyle(fontFamily: 'exar',)),
                          ),

                        ),

                        InkWell(
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 15.0, bottom: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,

                            ),
                            child: Text(
                              "متابعة",
                              style: TextStyle(fontFamily: 'exar',
                                  color: AppColors.primaryColor,
                                  fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(dialogContext).pop();
                            Navigator.pushNamedAndRemoveUntil(
                                context, AppPageNames.homeNavigatorScreen, (_) => false);

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
                      child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          radius: 14.0,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.close, color: AppColors
                              .primaryColor,
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
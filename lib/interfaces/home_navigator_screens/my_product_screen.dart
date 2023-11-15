
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:talaqe/CallApi.dart';
import 'package:talaqe/data/cities.dart';
import 'package:talaqe/data/dentist.dart';
import 'package:talaqe/data/product.dart';
import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/add_product_screen.dart';
import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:talaqe/widgets/home_doctors_screen_widgets.dart';

class MyProductScreen  extends StatefulWidget {
  const MyProductScreen({Key? key}) : super(key: key);

  @override
  State<MyProductScreen> createState() => _myProductScreenState();
}

class _myProductScreenState extends State<MyProductScreen> {
  final int _selectedCategoryIndex = 0;
  final List<Typetreatment> _Typetreatments =[];
  List<dynamic> data=[];
  int accountid=0;
  int my=0;
  double height=0;
  ScrollController scrollController = ScrollController();
  List<Product> _productlist =[];
  Widget scrolwiting=const Center();
  List<City> _cities=[] ;
  TextEditingController lowpricecontroller = TextEditingController();
  TextEditingController highpricecontroller = TextEditingController();
  Dentist dentist=Dentist(0, "", "", "", "", "", "", "", "", "","","");
  final Typetreatment _selecttype=Typetreatment(0, "", "");
  final City _selectedcities=City(0, "المدينة");
  int offset = 0;
  bool statusload=true;
  List<Widget> widgetlist =[];
  bool haveimage=false;
  String imagepath="";
  bool usecity=false;
  bool useprice=false;
  bool login=false;

  double margin=0.0;
  Future<void> getData() async {
    setState(() {
      _productlist.clear();
       usecity=false;
       useprice=false;
    });
    SharedPreferences prefsssss = await SharedPreferences.getInstance();
    String datastring = prefsssss.getString('data') ?? "";

    int Citees = prefsssss.getInt('citiesss') ?? 0;
    print('datastring$datastring');

    if (datastring != "") {

      setState(() {
        data = json.decode(datastring);
        accountid = prefsssss.getInt('accountid') ?? 0;
        lowpricecontroller.text="";
        highpricecontroller.text="";

        if(accountid!=0){
          login=true;
        }
      });
      Map datatype = data[0];
      if(login) {
        var response = await CallApi().getallData(
            "getdata/dentist/$accountid");
        var body = json.decode(utf8.decode(response.bodyBytes));
        print('respone fetchPagewithtrat  $body');
        var dentists = body[0];
        int cityid = 0;
        setState(() {
          dentist.id = accountid;
          dentist.name = dentists['name'] ?? "";
          dentist.phone = dentists['phone'] ?? "";
          dentist.university = dentists['university'] ?? "";
          dentist.active = dentists['active'] ?? "";
          dentist.type = dentists['type'] ?? "";
          dentist.identifynumber = dentists['identifynumber'] ?? "";
          dentist.years = dentists['years'] ?? "";
          dentist.city = dentists['city'] ?? "";
          dentist.statusreserv = dentists['statusreserv'].toString() ?? "";
          dentist.avatar = dentists['avatar'] ?? "";
          dentist.gallorywork = dentists['gallorywork'] ?? "";

          // print('avatareeee'+element['avatar']);

          if (dentists['avatar'] != null) {
            haveimage = true;
            imagepath = dentist.avatar;
            int startIndex = dentist.avatar.indexOf(".");
            String firstpart = dentist.avatar.substring(0, startIndex);
            String lastpart = dentist.avatar.substring(
                1 + startIndex, dentist.avatar.length);
            imagepath = "$firstpart-small.$lastpart";
            print("imagepath$imagepath");
          }
        });
      }
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
    if(imagepath!=""){
      imagepath="https://talaqe.org/storage/app/public/$imagepath";
    }
    print("https://talaqe.org/storage/app/public/$imagepath");
  }
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }



  @override
  void initState() {
    // TODO: implement initState
    _productlist=[];

    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent==scrollController.offset){

        _fetchPage(offset);
      }
    });
    getData();
    super.initState();
  }


  Future<void> _fetchPage(int pageKey) async {

    setState(() {
      offset=offset+10;
      scrolwiting=const Center(
        child: CircularProgressIndicator(),
      );
    });
    print('respone pageKey  $accountid');
    var response;
    print('myyyyyyyyy');

    response = await CallApi().getallData("getmyproducts/$pageKey/$accountid");
    print("iddddddddsssdddddddddddd${utf8.decode(response.bodyBytes)}");
    var body = json.decode(utf8.decode(response.bodyBytes));

    List<dynamic> statuslist=body;


    setState(() {

      for (var element in statuslist) {
        _productlist.add(


            Product(
                element['id'],
                element['dentistid'].toString()?? "",
                element['dentistname'].toString()?? "",
                element['title'] ?? "",
                element['description'] ?? "",
                element['img'] ?? "",
                element['imgs'] ?? "",
                element['status'] ?? "",
                element['created_at'] ?? "",
                element['price'].toString() ??"",
                element['phone'] ?? "",
                element['cityid'].toString()  ?? "",
                element['ciyname'] ?? "")    );
      }
      print('respone _productlist  ${_productlist.length}');

    });
    print('respone offset  $offset');
    setState(() {
      statusload=false;
    });
    setState(() {

      scrolwiting=const Center(

      );
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
    return Scaffold(
      /* <-------- Appbar --------> */
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
                    Text("المتجر",
                      style: TextStyle(fontSize: 18),
                    ),
                    AppGaps.hGap4,
                    Text('يامكانك استعراض منتجاتنا ',
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
          Center(
            child: CustomIconButtonWidget(
                onTap: () {
    if(login) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>   const AddMyproductScrean(),
                      ));}
                },
                borderRadiusRadiusValue: AppComponents.defaultBorderRadius,
                backgroundColor: AppColors.secondaryFontColor.withOpacity(0.2),
                child:const Icon(Icons.add_business_rounded,color: Colors.black,),
          )),
          // Extra right spaces
          AppGaps.wGap24,
        ],
      ),
      /* <-------- Content --------> */
      body: CustomScaffoldBodyWidget(
          child: SingleChildScrollView(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top extra spaces
          AppGaps.hGap15,

          /* <----- 'Top doctors' text and 'View all' text button row -----> */
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(' منتجاتي ', style: AppComponents.headerTextStyle),

            ],
          ),
          AppGaps.wGap30,
          /* <----- Top doctors horizontal list -----> */
        login?  SizedBox(
            height:screenHeight-100,
            child: _productlist.isEmpty? const Center(
                child: Text('لا تتوفر منتجات ')
            ):
            RefreshIndicator(
              displacement: 2,
              onRefresh:  getData,
              child: ListView.separated(
                  controller: scrollController,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => AppGaps.hGap16,
                  itemCount:_productlist.length+1,
                  padding: const EdgeInsets.only(
                    top: 15,
                    // Bottom extra spaces
                    bottom: 30,
                  ),
                  itemBuilder:getstatuslist

                /// Single doctor data



              ),
            ),
          ):Container(
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
          // Bottom extra spaces
          scrolwiting,
          // Bottom spaces
          AppGaps.hGap100,
        ],
      ))),
    );
  }



  Widget getstatuslist(BuildContext context,int index) {



    if(index<_productlist.length) {
      final product=_productlist[index];
      String result="";
      String  imagepath="";
      String status="للبيع";
      if(product.status=="accepted"){
        status="للبيع";
      }
      else if(product.status=="waiting"){
        status="بانتظار الموافقة ";
      }else if(product.status=="cancel"){
        status=" ملغي ";
      }
      else if(product.status=="prid"){
        status="تم البيع";

      }
      if(product.img!=""){


      int  startIndex = product.img.indexOf(".");
      print("startIndex$startIndex");
      String firstpart=product.img.substring(0, startIndex);
      String lastpart=product.img.substring(1+startIndex,product.img.length );
      imagepath ="$firstpart-small.$lastpart";
      }
      if(product.created_at!="") {
        result = product.created_at.substring(
            0, product.created_at.indexOf('T'));
      }
      // final args = ModalRoute.of(context)!.settings.arguments as allStatus;
      return DoctorListTileWidget(
          onTap: () {
            Navigator.pushNamed(
                context, AppPageNames.editproductScreen,
                arguments: product);
          },
          imageProvider:   FadeInImage(
      image: NetworkImage(CallApi.imgurl +imagepath),

    fit: BoxFit.fill,

    placeholder: const AssetImage('asset/banner.png'),
    ).image,
          isActive: false,
          name: product.title,
          reviewText: product.ciyname,
          designationText:status,
          hospitalName: 'تاريخ الإضافة $result');
    }else{
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(

        ),
      );
    }



  }


}

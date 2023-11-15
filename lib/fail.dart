import 'load.dart';
import 'package:flutter/material.dart';
class Fail extends StatefulWidget{
  const Fail({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Fail();
  }

}
class _Fail extends State<Fail>{


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[ Container(
          child:    Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Image.asset("asset/error.jpg",
              fit: BoxFit.fill,
            ),
          ),
        ),
          const Text("لايتوفر اتصال بالانترنت"),
          MaterialButton(
            color: Colors.redAccent,
              onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Load() ));
          },
              child: const Text('اعادة التحميل'))
    ]
      ),

    );
  }

}
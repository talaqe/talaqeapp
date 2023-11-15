

import 'package:flutter/material.dart';



class FullScrean extends StatefulWidget {
  String link;
  FullScrean({super.key, 
    this.link=""
  }) ;

  @override
  _FullScreanState createState() => _FullScreanState();
}

class _FullScreanState extends State<FullScrean> {
  String _link="";
  final String _url="https://talaqe.org/storage/app/public/";

  @override
  void initState() {
    // TODO: implement initState
    _link=widget.link;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop() ,
        ),
        backgroundColor:Colors.transparent ,
        elevation: 0,
      ),
      body: Container(
          width:  MediaQuery.of(context).size.width,
          height:  MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Color(0xFF000000),

          ),

          child: InteractiveViewer(
            panEnabled: false, // Set it to false
            boundaryMargin: const EdgeInsets.all(100),
            minScale: 0.1,
            maxScale: 2,
            child: FadeInImage(
              image: NetworkImage(_url +_link),
              // height: 200,
              fit: BoxFit.contain,
              width: MediaQuery
                  .of(context)
                  .size
                  .width-70 ,
              placeholder: const AssetImage('asset/im.png'),
            ),
          ),
      ),
    );
  }

}


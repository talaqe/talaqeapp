

import 'package:talaqe/data/typetreatments.dart';
import 'package:talaqe/interfaces/home_navigator_screens/mystatus_doctors_screen.dart';
import 'package:talaqe/utils/constants/app_constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/widgets/core_widgets.dart';

class MYHomeDoctorsScreen extends StatefulWidget {
  const MYHomeDoctorsScreen({Key? key}) : super(key: key);

  @override
  State<MYHomeDoctorsScreen> createState() => _HomeDoctorsScreenState();
}

class _HomeDoctorsScreenState extends State<MYHomeDoctorsScreen> {
  /// Selected category index
  final int _selectedCategoryIndex = 0;
  final List<Typetreatment> _Typetreatments =[];
  List<dynamic> data=[];

  @override
  void initState() {
    // TODO: implement initState


    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* <-------- Appbar --------> */
      appBar: CoreWidgets.appBarWidget(
          screenContext: context, titleWidget: const Text('حالاتي')),
      /* <-------- Content --------> */
      body: CustomScaffoldBodyWidget(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top extra spaces
          AppGaps.hGap15,
          /* <---- Search bar ----> */
          CustomBoxTextFormField(
              isFilled: true,
              hintText: '  ابحث عن اسم المريض او رقمه  ',
              hintTextStyle: const TextStyle(fontSize: 13),
              suffixIcon: IconButton(
                  padding: const EdgeInsets.only(left: 10),
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    AppAssetImages.searchDuoColorsIconSVG,
                    width: 20,
                  ))),
          AppGaps.hGap20,

          const MyStatusDoctorsScreen()
        ],
      )),
    );
  }
}

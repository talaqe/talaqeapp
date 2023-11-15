import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorListTileWidget extends StatelessWidget {
  final void Function()? onTap;
  final ImageProvider<Object> imageProvider;
  final String name;
  final String searchMatchedText;
  final String reviewText;
  final String designationText;
  final String hospitalName;
  final bool isActive;
  const DoctorListTileWidget({
    Key? key,
    required this.imageProvider,
    required this.name,
    required this.reviewText,
    required this.designationText,
    required this.hospitalName,
    this.onTap,
    this.isActive = false,
    this.searchMatchedText = '',
  }) : super(key: key);

  Widget _doctorProfilePicture() {
    Widget doctorImageWidget = Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            image: DecorationImage(image: imageProvider)));
    return isActive
        ? Stack(
            alignment: Alignment.topRight,
            clipBehavior: Clip.none,
            children: [
              doctorImageWidget,
              Positioned(
                  top: -3,
                  right: -1,
                  child: Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                  ))
            ],
          )
        : doctorImageWidget;
  }

  @override
  Widget build(BuildContext context) {
    return CustomListTileWidget(
      onTap: onTap,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        _doctorProfilePicture(),
        AppGaps.wGap10,
        Expanded(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(TextSpan(
                children: [
                  TextSpan(
                      text: searchMatchedText,
                      style: const TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w200,
                   )),
                  TextSpan(text: name),
                ],
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500))),
            // Text( name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
            AppGaps.hGap2,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(AppAssetImages.starSolidIconSVG,
                    color: AppColors.color4),
                AppGaps.wGap5,
                Text(
                  reviewText,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.secondaryFontColor),
                ),
              ],
            ),
            AppGaps.hGap5,
            Text.rich(
                TextSpan(children: [
                  TextSpan(
                      text: designationText,
                      style: const TextStyle(
                        color: AppColors.primaryFontColor,
                      )),
                  const TextSpan(text: ' - '),
                  TextSpan(text: hospitalName)
                ]),
                style:
                    DefaultTextStyle.of(context).style.copyWith(fontSize: 12)),
          ],
        ))
      ]),
    );
  }
}

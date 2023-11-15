import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsListTileWidget extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final Widget? suffixWidget;
  final String prefixSVGIconLocalAssetFileName;
  final Color prefixIconColor;
  const SettingsListTileWidget({
    Key? key,
    this.onTap,
    required this.text,
    this.suffixWidget,
    required this.prefixIconColor,
    required this.prefixSVGIconLocalAssetFileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomRawListTileWidget(
        onTap: onTap,
        borderRadiusRadiusValue: const Radius.circular(15),
        child: Row(children: [
          CustomIconButtonWidget(
              fixedSize: const Size(50, 50),
              borderRadiusRadiusValue: const Radius.circular(15),
              backgroundColor: prefixIconColor.withOpacity(0.1),
              child: SvgPicture.asset(
                prefixSVGIconLocalAssetFileName,
                color: prefixIconColor,
                height: 20,
              )),
          AppGaps.wGap16,
          Expanded(child: Text(text)),
          suffixWidget ??
              RotatedBox(
                  quarterTurns: 3,
                  child: SvgPicture.asset(AppAssetImages.arrowDownIconSVG)),
        ]));
  }
}

/// Custom item widget for cupertino picker widget with text widget
class CustomCupertinoPickerTextItemWidget extends StatelessWidget {
  final String valueString;
  const CustomCupertinoPickerTextItemWidget({
    Key? key,
    required this.valueString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            border: Border(
          top: BorderSide(color: AppColors.primaryFontColor),
          bottom: BorderSide(color: AppColors.primaryFontColor),
        )),
        child: Text(
          valueString,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ));
  }
}

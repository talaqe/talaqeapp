import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIconButtonWidget extends StatelessWidget {
  final void Function()? onTap;
  final bool hasBorder;
  final String localSVGAssetLocation;
  final Color? backgroundColor;
  const SocialIconButtonWidget({
    Key? key,
    this.onTap,
    this.hasBorder = true,
    required this.localSVGAssetLocation,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomIconButtonWidget(
        onTap: onTap,
        backgroundColor: backgroundColor ?? AppColors.backgroundColor,
        fixedSize: const Size(50, 50),
        hasBorder: hasBorder,
        borderRadiusRadiusValue: const Radius.circular(10),
        child: SvgPicture.asset(localSVGAssetLocation));
  }
}

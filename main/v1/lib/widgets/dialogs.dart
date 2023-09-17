import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// This class contains functions that call to open dialog popup
class AppDialogs {
  /// Open usual dialog
  static Future<Object?> openDialog(
      {required BuildContext dialogContext,
      required String sloganText,
      required String subtitleText,
      void Function()? onTap,
      required String iconLocalSVGImageAssetName,
      Color? iconColor}) {
    return showDialog(
      context: dialogContext,
      builder: (context) => CustomAlertDialogWidget(
          iconLocalSVGImageAssetName: iconLocalSVGImageAssetName,
          iconColor: iconColor,
          sloganText: sloganText,
          subtitleText: subtitleText,
          onTap: onTap),
    );
  }

  /// Open usual choice dialog
  static Future<Object?> openChoiceDialog(
      {required BuildContext dialogContext,
      required String confirmText,
      required String cancelText,
      required String sloganText,
      required String subtitleText,
      void Function()? onConfirmTap,
      void Function()? onCancelTap,
      required String iconLocalSVGImageAssetName,
      required Color iconColor}) {
    return showDialog(
      context: dialogContext,
      builder: (context) => CustomChoiceDialogWidget(
          iconLocalSVGImageAssetName: iconLocalSVGImageAssetName,
          iconColor: iconColor,
          sloganText: sloganText,
          subtitleText: subtitleText,
          confirmText: confirmText,
          cancelText: cancelText,
          onConfirmTap: onConfirmTap,
          onCancelTap: onCancelTap),
    );
  }

  /// Open raw dialog with dialog height and width same as usual dialog
  static Future<Object?> openRawDialog(
      {required BuildContext dialogContext, required Widget child}) {
    return showDialog(
        context: dialogContext,
        builder: (context) => CustomRawDialogWidget(child: child));
  }
}

/// Custom raw dialog popup widget
class CustomRawDialogWidget extends StatelessWidget {
  final Widget child;
  const CustomRawDialogWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Container(
          padding: const EdgeInsets.all(30),
          height: 504,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(14))),
          child: child,
        ));
  }
}

/// Alert dialog popup widget
class CustomAlertDialogWidget extends StatelessWidget {
  final String iconLocalSVGImageAssetName;
  final String sloganText;
  final String subtitleText;
  final void Function()? onTap;
  final Color? iconColor;
  const CustomAlertDialogWidget({
    Key? key,
    required this.iconLocalSVGImageAssetName,
    required this.sloganText,
    required this.subtitleText,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomRawDialogWidget(
        child: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* <---- Dialog image ----> */
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topRight,
                    children: [
                      CustomIconButtonWidget(
                          fixedSize: const Size(100, 100),
                          child: SvgPicture.asset(
                            iconLocalSVGImageAssetName,
                            height: 40,
                            color: iconColor,
                          )),
                      Positioned(
                          top: -7,
                          right: -7,
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                                border:
                                    Border.all(color: Colors.white, width: 3)),
                            child: Center(
                                child: SvgPicture.asset(
                              AppAssetImages.checkMarkTickIconSVG,
                              color: Colors.white,
                              height: 10.63,
                            )),
                          ))
                    ],
                  ),
                  AppGaps.hGap50,
                  /* <---- Dialog title and subtitle text ----> */
                  HighlightAndDetailTextWidget(
                      slogan: sloganText, subtitle: subtitleText),
                  AppGaps.hGap50,
                ],
              ),
            ),
          ),
        ),
        CustomStretchedTextButtonWidget(
            onTap: onTap, buttonText: 'Go to dashboard'),
      ],
    )));
  }
}

/// Choice dialog popup widget
class CustomChoiceDialogWidget extends StatelessWidget {
  final String iconLocalSVGImageAssetName;
  final String sloganText;
  final String subtitleText;
  final void Function()? onConfirmTap;
  final void Function()? onCancelTap;
  final Color iconColor;
  final String confirmText;
  final String cancelText;
  const CustomChoiceDialogWidget({
    Key? key,
    required this.iconLocalSVGImageAssetName,
    required this.sloganText,
    required this.subtitleText,
    required this.iconColor,
    required this.confirmText,
    required this.cancelText,
    this.onConfirmTap,
    this.onCancelTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomRawDialogWidget(
        child: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* <---- Dialog image ----> */
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topRight,
                    children: [
                      CustomIconButtonWidget(
                          fixedSize: const Size(100, 100),
                          child: SvgPicture.asset(
                            iconLocalSVGImageAssetName,
                            height: 40,
                            color: iconColor,
                          )),
                      Positioned(
                          top: -7,
                          right: -7,
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primaryColor,
                                border:
                                    Border.all(color: Colors.white, width: 3)),
                            child: Center(
                                child: SvgPicture.asset(
                              AppAssetImages.checkMarkTickIconSVG,
                              color: Colors.white,
                              height: 10.63,
                            )),
                          ))
                    ],
                  ),
                  AppGaps.hGap50,
                  /* <---- Dialog title and subtitle text ----> */
                  HighlightAndDetailTextWidget(
                      slogan: sloganText, subtitle: subtitleText),
                  AppGaps.hGap50,
                ],
              ),
            ),
          ),
        ),
        CustomStretchedTextButtonWidget(
            onTap: onConfirmTap, buttonText: confirmText),
        AppGaps.hGap20,
        CustomStretchedTextButtonWidget(
            hasBorder: true,
            onTap: onCancelTap,
            color: AppColors.primaryColor,
            backgroundColor: Colors.white,
            buttonText: cancelText),
      ],
    )));
  }
}

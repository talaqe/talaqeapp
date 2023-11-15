import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';

class TopDoctorWidget extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final ImageProvider<Object> imageProvider;
  final void Function()? onTap;
  const TopDoctorWidget({
    Key? key,
    required this.titleText,
    required this.subtitleText,
    required this.imageProvider,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.all(AppComponents.mediumBorderRadius),
      child: InkWell(
        borderRadius: const BorderRadius.all(AppComponents.mediumBorderRadius),
        onTap: onTap,
        child: Container(
          height: 188,
          width: 130,
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.all(AppComponents.mediumBorderRadius)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 125,
                width: 110,
                decoration: BoxDecoration(
                    image: DecorationImage(image: imageProvider),
                    borderRadius: const BorderRadius.all(
                        AppComponents.largerBorderRadius)),
              ),
              AppGaps.hGap10,
              Center(
                child: Text(
                  titleText,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              AppGaps.hGap2,
              Text(
                subtitleText,
                maxLines: 1,
                style: const TextStyle(
                    color: AppColors.secondaryFontColor, fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OfferBannerWidget extends StatelessWidget {
  final String titleText;
  final String subtitleText;
  final String offerText;
  const OfferBannerWidget({
    Key? key,
    required this.titleText,
    required this.subtitleText,
    required this.offerText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          height: 121,
          width: 287,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: AppComponents.defaultBorder,
              borderRadius:
                  const BorderRadius.all(AppComponents.defaultBorderRadius)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                titleText,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              AppGaps.hGap14,
              Expanded(
                  child: Container(
                padding: const EdgeInsets.only(left: 15),
                decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: AppColors.primaryColor, width: 2))),
                child: Text(
                  subtitleText,
                  style: const TextStyle(fontSize: 14),
                ),
              ))
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(9),
          decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  topRight: Radius.circular(5))),
          child: Text(
            offerText,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class SpecialistWidget extends StatelessWidget {
  final Color backgroundColor;
  final Widget icon;
  final String titleText;
  final String subtitleText;
  final void Function()? onTap;
  const SpecialistWidget({
    Key? key,
    required this.backgroundColor,
    required this.icon,
    required this.titleText,
     this.subtitleText="",
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: const BorderRadius.all(AppComponents.defaultBorderRadius),
      child: InkWell(
        borderRadius: const BorderRadius.all(AppComponents.defaultBorderRadius),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.all(0),
          height: 50,
          width: 90,
          decoration: const BoxDecoration(
              borderRadius:
                  BorderRadius.all(AppComponents.defaultBorderRadius)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,

              SizedBox(
                height: 25,
                child: Center(
                  child: Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              (subtitleText!="")?
                  Column(
                    children: [
                      AppGaps.hGap5,
                      Text(
                        subtitleText,
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      )
                    ],
                  ):const Center(),

            ],
          ),
        ),
      ),
    );
  }
}

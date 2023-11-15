import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/utils/constants/app_page_names.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SetUpProfileScreen extends StatelessWidget {
  const SetUpProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* <-------- Appbar with only back button --------> */
      appBar: CoreWidgets.appBarWidget(screenContext: context),
      /* <-------- Content --------> */
      body: CustomScaffoldBodyWidget(
          child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top extra spaces
              AppGaps.hGap15,
              Text('Set up your profile',
                  style: Theme.of(context).textTheme.bodyLarge),
              AppGaps.hGap15,
              const Text(
                  'Update your profile to connect your doctor with better impression.'),
              AppGaps.hGap30,
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButtonWidget(
                            fixedSize: const Size(130, 130),
                            borderRadiusRadiusValue: const Radius.circular(40),
                            backgroundColor:
                                AppColors.secondaryFontColor.withOpacity(0.1),
                            child: SvgPicture.asset(
                                AppAssetImages.personDuoColorsIconSVG)),
                        AppGaps.hGap25,
                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        child: CustomIconButtonWidget(
                          onTap: () {},
                          fixedSize: const Size(53, 53),
                          borderRadiusRadiusValue: const Radius.circular(20),
                          backgroundColor: AppColors.primaryColor,
                          hasBorder: true,
                          border: Border.all(color: Colors.white, width: 3),
                          child: SvgPicture.asset(
                            AppAssetImages.cameraIconSVG,
                            color: Colors.white,
                          ),
                        )),
                  ],
                )
              ]),
              AppGaps.hGap50,
              /* <----- Gender text field -----> */
              CustomTextFormField(
                  isReadOnly: true,
                  labelPrefixIcon: SvgPicture.asset(
                    AppAssetImages.groupIconSVG,
                    color: AppColors.secondaryFontColor,
                    width: 12,
                  ),
                  labelText: 'Gender',
                  hintText: 'Select your gender',
                  suffixIcon: SizedBox(
                    height: 28,
                    child: PopupMenuButton<int>(
                      padding: EdgeInsets.zero,
                      position: PopupMenuPosition.under,
                      itemBuilder: (context) {
                        return [
                          const PopupMenuItem<int>(child: Text('Male')),
                          const PopupMenuItem<int>(child: Text('Female')),
                        ];
                      },
                      icon: SvgPicture.asset(AppAssetImages.arrowDownIconSVG,
                          color: AppColors.secondaryFontColor, width: 12),
                    ),
                  )),
              AppGaps.hGap30,
              /* <---- Birth date text field ----> */
              CustomTextFormField(
                labelPrefixIcon: SvgPicture.asset(
                    AppAssetImages.calenderIconSVG,
                    color: AppColors.secondaryFontColor),
                labelText: 'Date of birth',
                hintText: 'Type of your birth date',
              ),
              AppGaps.hGap30,
              /* <---- Address text field ----> */
              CustomTextFormField(
                minLines: 1,
                maxLines: 2,
                labelPrefixIcon: SvgPicture.asset(
                    AppAssetImages.locationIconSVG,
                    color: AppColors.secondaryFontColor),
                labelText: 'Address',
                hintText: 'Enter your address',
              ),
              AppGaps.hGap30,
              // Bottom extra spaces
              AppGaps.hGap30,
            ]),
      )),
      /* <-------- Bottom bar --------> */
      bottomNavigationBar: CustomScaffoldBottomBarWidget(
          child: CustomStretchedTextButtonWidget(
              buttonText: 'Complete',
              onTap: () {
                Navigator.pushNamed(context, AppPageNames.homeNavigatorScreen);
              })),
    );
  }
}

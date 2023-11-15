
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:talaqe/data/notification.dart';
import 'package:talaqe/widgets/core_widgets.dart';

import '../utils/constants/app_constants.dart';

/// Single notification entry widget from notification group
class SingleNotificationWidget extends StatelessWidget {
  final Notifications notification;
  const SingleNotificationWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);


  /// Get notification icon widget with icon, color and background color.
  Widget _getNotificationIconWidget() {
    final Color primaryColor;
    final Widget notificationIconWidget;
    switch (notification.type) {
      case 'city':
        primaryColor = AppColors.secondaryColor;
        notificationIconWidget = SvgPicture.asset(
            AppAssetImages.notificationDuoColorsIconSVG,
            width: 12.75,
            height: 15,
            color: primaryColor);
        break;
      case 'university':
        primaryColor = AppColors.color4;
        notificationIconWidget = SvgPicture.asset(
            AppAssetImages.alarmClockIconSVG,
            width: 14.11,
            height: 15,
            color: primaryColor);
        break;
      case 'account':
        primaryColor = AppColors.color5;
        notificationIconWidget = SvgPicture.asset(
            AppAssetImages.notificationDuoColorsIconSVG,
            width: 12.75,
            height: 15,
            color: primaryColor);
        break;
      default:
        primaryColor = AppColors.secondaryColor;
        notificationIconWidget = SvgPicture.asset(
            AppAssetImages.notificationDuoColorsIconSVG,
            width: 12.75,
            height: 15,
            color: primaryColor);
    }
    return CustomIconButtonWidget(
        fixedSize: const Size(32, 32),
        borderRadiusRadiusValue: const Radius.circular(10),
        backgroundColor: primaryColor.withOpacity(0.1),
        child: notificationIconWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getNotificationIconWidget(),
        AppGaps.wGap10,
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notification.title,
                  style: const TextStyle(fontSize: 16)),
              AppGaps.hGap8,
              RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context)
                        .style
                        .copyWith(fontSize: 12),
                    text: notification.text,

              ),

          ),
          ]
        ),
        )
      ],
    );
  }
}


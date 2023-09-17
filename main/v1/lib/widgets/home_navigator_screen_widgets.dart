import 'package:talaqe/utils/constants/app_colors.dart';
import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:talaqe/widgets/core_widgets.dart';
import 'package:flutter/material.dart';

class CustomBottomNavbarItemWidget extends StatelessWidget {
  final void Function() onTap;
  final bool isSelected;
  final String toolTipMessage;
  final Widget icon;
  final notification;
  const CustomBottomNavbarItemWidget({
    Key? key,
    required this.onTap,
    required this.isSelected,
    required this.icon,
    required this.toolTipMessage,
    this.notification=0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Get screen size
    final screenSize = MediaQuery.of(context).size;

    /// Small screen width for avoid button overlap
    double smallScreenWidth = 355;
    return Tooltip(
      message: toolTipMessage,
      textStyle: const TextStyle(
          fontSize: 16, color: AppColors.primaryColor, fontWeight: FontWeight.bold),
      child: CustomIconButtonWidget(
          notification:notification,
          backgroundColor: isSelected
              ? AppColors.primaryColor.withOpacity(0.1)
              : Colors.white,
          onTap: onTap,
          fixedSize: Size(screenSize.width < smallScreenWidth ? 48 : 55, 50),
          child: icon),
    );
  }
}

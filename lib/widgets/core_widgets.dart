import 'package:talaqe/utils/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';

/// Custom padded body widget for scaffold
class CustomScaffoldBodyWidget extends StatelessWidget {
  final Widget child;
  const CustomScaffoldBodyWidget({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppGaps.screenPaddingValue),
      child: child,
    );
  }
}

/// Custom padded bottom bar widget for scaffold
class CustomScaffoldBottomBarWidget extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  const CustomScaffoldBottomBarWidget(
      {Key? key, required this.child, this.backgroundColor, this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppGaps.bottomNavBarPadding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

/// Custom TextButton stretches the width of the screen
class CustomStretchedTextButtonWidget extends StatelessWidget {
  final String buttonText;
  final Color backgroundColor;
  final Color color;
  final bool hasBorder;
  final void Function()? onTap;
  const CustomStretchedTextButtonWidget({
    Key? key,
    this.onTap,
    required this.buttonText,
    this.backgroundColor = AppColors.primaryColor,
    this.color = Colors.white,
    this.hasBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                  foregroundColor: color,
                  backgroundColor: onTap == null
                      ? AppColors.secondaryFontColor.withOpacity(0.25)
                      : backgroundColor,
                  minimumSize: const Size(30, 60),
                  shape: RoundedRectangleBorder(
                      side: hasBorder
                          ? BorderSide(
                              color:
                                  AppColors.secondaryFontColor.withOpacity(0.2))
                          : BorderSide.none,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10)))),
              child: Text(buttonText,
                  style: onTap == null
                      ? const TextStyle(color: Colors.white)
                      : null)),
        ),
      ],
    );
  }
}

/// Custom TextButton stretches the width of the screen with custom child widget
class CustomStretchedButtonWidget extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color color;
  final bool hasBorder;
  final void Function()? onTap;
  const CustomStretchedButtonWidget({
    Key? key,
    this.onTap,
    required this.child,
    this.backgroundColor = AppColors.primaryColor,
    this.color = Colors.white,
    required this.hasBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                  foregroundColor: color,
                  backgroundColor: onTap == null
                      ? AppColors.primaryFontColor.withOpacity(0.25)
                      : backgroundColor,
                  minimumSize: const Size(30, 60),
                  shape: RoundedRectangleBorder(
                      side: hasBorder
                          ? BorderSide(
                              color:
                                  AppColors.secondaryFontColor.withOpacity(0.2))
                          : BorderSide.none,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10)))),
              child: child),
        ),
      ],
    );
  }
}

/// Custom toggle button configured from FlutterSwitch widget which is from
/// 'flutter_switch' package
class CustomToggleSwitchWidget extends StatelessWidget {
  final bool value;
  final void Function(bool) onToggle;
  const CustomToggleSwitchWidget({
    Key? key,
    required this.value,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      value: value,
      width: 45,
      height: 26,
      toggleSize: 14,
      padding: 5,
      activeColor: AppColors.primaryColor,
      onToggle: onToggle,
    );
  }
}

/// Custom TextFormField configured with Theme with box border.
class CustomBoxTextFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final Widget? labelPrefixIcon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPasswordTextField;
  final bool isReadOnly;
  final BoxConstraints prefixIconConstraints;
  final TextInputType? textInputType;
  final BoxConstraints suffixIconConstraints;
  final TextEditingController? controller;
  final int? minLines;
  final int maxLines;
  final bool isFilled;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final Color? backgroundColor;
  final Color? focusBorderColor;
  final void Function()? onTap;
  const CustomBoxTextFormField({
    Key? key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.isPasswordTextField = false,
    this.prefixIconConstraints = const BoxConstraints(maxHeight: 26 + 2),
    this.suffixIconConstraints =
        const BoxConstraints(maxHeight: 48, maxWidth: 48),
    this.isReadOnly = false,
    this.textInputType,
    this.controller,
    this.minLines,
    this.maxLines = 1,
    this.onTap,
    this.labelPrefixIcon,
    this.isFilled = false,
    this.hintTextStyle,
    this.backgroundColor,
    this.textStyle,
    this.focusBorderColor,
  }) : super(key: key);

  /// TextField widget
  Widget textFormFieldWidget() {
    return SizedBox(
      // height: (maxLines > 1 || (minLines ?? 1) > 1) ? null : 62,
      child: TextFormField(

        controller: controller,
        onTap: onTap,
        readOnly: isReadOnly,
        obscureText: isPasswordTextField,
        style: textStyle,
        keyboardType: textInputType,
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(

          hintText: hintText,
          hintStyle: hintTextStyle,
          fillColor: backgroundColor ?? Colors.white,
          filled: isFilled,
          prefix: prefixIcon != null ? AppGaps.wGap10 : null,
          prefixIconConstraints: prefixIconConstraints,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: prefixIcon,
                )
              : null,
          contentPadding: EdgeInsets.fromLTRB(
              prefixIcon != null ? 0 : 20, 17, suffixIcon != null ? 0 : 20, 17),
          suffixIconConstraints: suffixIconConstraints,
          suffix: AppGaps.wGap10,
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: suffixIcon,
                )
              : null,
          focusedBorder: focusBorderColor != null
              ? OutlineInputBorder(
                  borderRadius:
                      const BorderRadius.all(AppComponents.defaultBorderRadius),
                  borderSide: BorderSide(color: focusBorderColor!))
              : null,
          border: OutlineInputBorder(
              borderRadius:
                  const BorderRadius.all(AppComponents.defaultBorderRadius),
              borderSide: BorderSide(
                  color: AppColors.secondaryFontColor.withOpacity(0.2))),
          enabledBorder: OutlineInputBorder(
              borderRadius:
                  const BorderRadius.all(AppComponents.defaultBorderRadius),
              borderSide: BorderSide(
                  color: AppColors.secondaryFontColor.withOpacity(0.2))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If label text is not null, then show label as a separate Text widget
    // wrapped inside column widget.
    // Else, just return the TextFormField widget.
    if (labelText != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              labelPrefixIcon != null
                  ? Container(
                      alignment: Alignment.topLeft,
                      constraints: const BoxConstraints(minHeight: 10),
                      child: labelPrefixIcon)
                  : AppGaps.emptyGap,
              labelPrefixIcon != null ? AppGaps.wGap15 : AppGaps.emptyGap,
              // Label text
              Text(labelText!,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          AppGaps.hGap14,
          // Text field
          textFormFieldWidget(),
        ],
      );
    } else {
      // Text field
      return textFormFieldWidget();
    }
  }
}

/// Custom TextFormField configured with Theme.
class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final Widget? labelPrefixIcon;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPasswordTextField;
  final bool isReadOnly;
  final BoxConstraints prefixIconConstraints;
  final TextInputType? textInputType;
  final BoxConstraints suffixIconConstraints;
  final TextEditingController? controller;
  final int? minLines;
  final int maxLines;
  final void Function()? onTap;
  const CustomTextFormField({
    Key? key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.isPasswordTextField = false,
    this.prefixIconConstraints = const BoxConstraints(maxHeight: 26 + 2),
    this.suffixIconConstraints =
        const BoxConstraints(maxHeight: 48, maxWidth: 48),
    this.isReadOnly = false,
    this.textInputType,
    this.controller,
    this.minLines,
    this.maxLines = 1,
    this.onTap,
    this.labelPrefixIcon,
  }) : super(key: key);

  /// TextField widget
  Widget textFormFieldWidget() {
    return SizedBox(
      height: (maxLines > 1 || (minLines ?? 1) > 1) ? null : 62,
      child: TextFormField(
        controller: controller,
        onTap: onTap,
        readOnly: isReadOnly,
        obscureText: isPasswordTextField,
        keyboardType: textInputType,
        minLines: minLines,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          prefix: prefixIcon != null ? AppGaps.wGap10 : null,
          prefixIconConstraints: prefixIconConstraints,
          prefixIcon: prefixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: prefixIcon,
                )
              : null,
          contentPadding: const EdgeInsets.only(bottom: 10),
          suffixIconConstraints: suffixIconConstraints,
          suffix: AppGaps.wGap10,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If label text is not null, then show label as a separate Text widget
    // wrapped inside column widget.
    // Else, just return the TextFormField widget.
    if (labelText != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              labelPrefixIcon != null
                  ? Container(
                      alignment: Alignment.topLeft,
                      constraints: const BoxConstraints(minHeight: 10),
                      child: labelPrefixIcon)
                  : AppGaps.emptyGap,
              labelPrefixIcon != null ? AppGaps.wGap15 : AppGaps.emptyGap,
              // Label text
              Text(labelText!,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          AppGaps.hGap14,
          // Text field
          textFormFieldWidget(),
        ],
      );
    } else {
      // Text field
      return textFormFieldWidget();
    }
  }
}

/// Custom toggle button of tab widget with text as child widget
class CustomTextTabToggleButtonWidget extends StatelessWidget {
  final bool isSelected;
  final String text;
  final void Function()? onTap;
  final EdgeInsets? padding;
  const CustomTextTabToggleButtonWidget(
      {Key? key,
      required this.isSelected,
      required this.text,
      this.onTap,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      animationDuration: Duration.zero,
      color: isSelected ? AppColors.primaryColor : Colors.white,
      borderRadius: const BorderRadius.all(AppComponents.defaultBorderRadius),
      child: InkWell(
        borderRadius: const BorderRadius.all(AppComponents.defaultBorderRadius),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minHeight: 50),
          padding: padding,
          decoration: BoxDecoration(
            border: isSelected ? AppComponents.defaultBorder : null,
            borderRadius:
                const BorderRadius.all(AppComponents.defaultBorderRadius),
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color:
                    isSelected ? Colors.white : AppColors.secondaryFontColor),
          ),
        ),
      ),
    );
  }
}

/// Custom toggle button of tab widget with child widget
/// Need to handle active/inactive color manually
class CustomTabToggleButtonWidget extends StatelessWidget {
  final bool isSelected;
  final Widget child;
  final void Function()? onTap;
  final EdgeInsets? padding;
  const CustomTabToggleButtonWidget(
      {Key? key,
      required this.isSelected,
      required this.child,
      this.onTap,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      animationDuration: Duration.zero,
      color: isSelected ? AppColors.primaryColor : Colors.white,
      borderRadius: const BorderRadius.all(AppComponents.defaultBorderRadius),
      child: InkWell(
        borderRadius: const BorderRadius.all(AppComponents.defaultBorderRadius),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(minHeight: 50),
          padding: padding,
          decoration: BoxDecoration(
            border: isSelected ? AppComponents.defaultBorder : null,
            borderRadius:
                const BorderRadius.all(AppComponents.defaultBorderRadius),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Custom IconButton widget various attributes
class CustomIconButtonWidget extends StatelessWidget {
  final void Function()? onTap;
  final bool hasBorder;
  final BoxBorder? border;
  final Widget child;
  final Color backgroundColor;
  final Size fixedSize;
  final Radius borderRadiusRadiusValue;
  final bool isCircleShape;
  final int notification;
  const CustomIconButtonWidget(
      {Key? key,
      this.onTap,
      required this.child,
      this.backgroundColor = AppColors.backgroundColor,
      this.fixedSize = const Size(40, 40),
      this.borderRadiusRadiusValue = const Radius.circular(14),
      this.isCircleShape = false,
      this.hasBorder = false,
        this.notification=0,
      this.border})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fixedSize.height,
      width: fixedSize.width,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          shape: isCircleShape ? BoxShape.circle : BoxShape.rectangle,
          borderRadius:
              isCircleShape ? null : BorderRadius.all(borderRadiusRadiusValue),
          border: hasBorder ? border ?? AppComponents.defaultBorder : null),
      child: Material(
        color: backgroundColor,
        shape: isCircleShape ? const CircleBorder() : null,
        borderRadius:
            isCircleShape ? null : BorderRadius.all(borderRadiusRadiusValue),
        child:
        (notification==0)?InkWell(
          onTap: onTap,
          customBorder: isCircleShape ? const CircleBorder() : null,
          borderRadius: BorderRadius.all(borderRadiusRadiusValue),
          child: Center(child: child),
        ):InkWell(
          onTap: onTap,
          customBorder: isCircleShape ? const CircleBorder() : null,
          borderRadius: BorderRadius.all(borderRadiusRadiusValue),
          child:
          Stack(
            children: <Widget>[
              Center(child: child),
              Positioned(
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: AppColors.alertColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: Text(
                    '$notification',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        )
        ,
      ),
    );
  }
}

/// Custom large IconButton widget various attributes
class CustomLargeIconButtonWidget extends StatelessWidget {
  final void Function()? onTap;
  final bool hasBorder;
  final Widget child;
  final Color backgroundColor;
  final Radius borderRadiusRadiusValue;
  final bool isCircleShape;
  final bool hasShadow;
  final double? width;
  const CustomLargeIconButtonWidget(
      {Key? key,
      this.onTap,
      required this.child,
      this.backgroundColor = AppColors.backgroundColor,
      this.borderRadiusRadiusValue = AppComponents.largeBorderRadius,
      this.isCircleShape = false,
      this.hasShadow = false,
      this.hasBorder = false,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76.5,
      width: width ?? 76.5,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          shape: isCircleShape ? BoxShape.circle : BoxShape.rectangle,
          borderRadius:
              isCircleShape ? null : BorderRadius.all(borderRadiusRadiusValue),
          border: hasBorder ? AppComponents.defaultBorder : null),
      child: Material(
        color: backgroundColor,
        shape: isCircleShape ? const CircleBorder() : null,
        shadowColor: hasShadow ? Colors.black.withOpacity(0.4) : null,
        elevation: hasShadow ? 8 : 0,
        borderRadius:
            isCircleShape ? null : BorderRadius.all(borderRadiusRadiusValue),
        child: InkWell(
          onTap: onTap,
          customBorder: isCircleShape ? const CircleBorder() : null,
          borderRadius: BorderRadius.all(borderRadiusRadiusValue),
          child: Center(child: child),
        ),
      ),
    );
  }
}

/// Empty list icon and and text widget
class EmptyListMessageWidget extends StatelessWidget {
  final Widget iconWidget;
  final String text;
  const EmptyListMessageWidget({
    Key? key,
    required this.iconWidget,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: iconWidget,
        ),
        AppGaps.hGap50,
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        AppGaps.hGap50,
      ],
    );
  }
}

/// Raw list tile does not have a background color
class CustomRawListTileWidget extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final Radius? borderRadiusRadiusValue;
  const CustomRawListTileWidget({
    Key? key,
    required this.child,
    this.onTap,
    this.borderRadiusRadiusValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadiusRadiusValue != null
          ? BorderRadius.all(borderRadiusRadiusValue!)
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadiusRadiusValue != null
            ? BorderRadius.all(borderRadiusRadiusValue!)
            : null,
        child: child,
      ),
    );
  }
}

/// Custom list tile widget of white background color
class CustomListTileWidget extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Widget child;
  final EdgeInsets paddingValue;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  const CustomListTileWidget({
    Key? key,
    required this.child,
    this.onTap,
    this.paddingValue = const EdgeInsets.all(10),
    this.onLongPress,
    this.borderRadius =
        const BorderRadius.all(AppComponents.defaultBorderRadius),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          alignment: Alignment.topLeft,
          padding: paddingValue,
          decoration: BoxDecoration(borderRadius: borderRadius),
          child: child,
        ),
      ),
    );
  }
}

/// Tick toggle button
class CustomTickToggleButtonWidget extends StatelessWidget {
  final void Function()? onTap;
  final bool isActive;
  const CustomTickToggleButtonWidget({
    Key? key,
    this.onTap,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Material(
        color: isActive
            ? AppColors.primaryColor
            : AppColors.secondaryFontColor.withOpacity(0.2),
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(
            child: SvgPicture.asset(
              AppAssetImages.checkMarkTickIconSVG,
              width: 11.75,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Credit card widget with 3 shadows towards bottom
class PaymentCardWidget extends StatelessWidget {
  final Widget child;
  const PaymentCardWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 232,
      alignment: Alignment.topCenter,
      child: Container(
        height: 208,
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          // padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: child,
        ),
      ),
    );
  }
}

/// Slogan and subtitle text
class HighlightAndDetailTextWidget extends StatelessWidget {
  final String slogan;
  final String subtitle;
  final bool isSpaceShorter;
  const HighlightAndDetailTextWidget({
    Key? key,
    required this.slogan,
    required this.subtitle,
    this.isSpaceShorter = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(slogan,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge),
        isSpaceShorter ? AppGaps.hGap8 : AppGaps.hGap16,
        Text(subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryFontColor,
                )),
      ],
    );
  }
}

/// Custom text button with any widget child
class CustomButtonWidget extends StatelessWidget {
  final void Function()? onTap;
  final bool isSelected;
  final bool hasPadding;
  final Color unselectedColor;
  final Size? fixedSize;
  final Widget child;
  const CustomButtonWidget({
    Key? key,
    this.isSelected = false,
    required this.child,
    this.onTap,
    this.hasPadding = true,
    this.unselectedColor = Colors.white,
    this.fixedSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
          foregroundColor:
              isSelected ? Colors.white : AppColors.secondaryFontColor,
          fixedSize: fixedSize,
          backgroundColor:
              isSelected ? AppColors.primaryColor : unselectedColor,
          shape: RoundedRectangleBorder(
              side: isSelected
                  ? BorderSide.none
                  : BorderSide(color: AppColors.borderColor),
              borderRadius:
                  const BorderRadius.all(AppComponents.defaultBorderRadius)),
          padding: hasPadding
              ? const EdgeInsets.symmetric(horizontal: 20, vertical: 17)
              : EdgeInsets.zero,
          visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity)),
      child: child,
    );
  }
}

/// Custom TextButton widget which is very tight to child text
class CustomTightTextButtonWidget extends StatelessWidget {
  final void Function()? onTap;
  final Widget child;
  const CustomTightTextButtonWidget({
    Key? key,
    this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity)),
        child: child);
  }
}

/// This class contains functions that return a widget
class CoreWidgets {
  /// Custom app bar widget
  static AppBar appBarWidget(
      {required BuildContext screenContext,
      Widget? titleWidget,
      List<Widget>? actions,
      Color? backButtonBackgroundColor,
      bool hasBackButton = true}) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: hasBackButton
          ? Center(
              child: CustomIconButtonWidget(
                  hasBorder: true,
                  backgroundColor:
                      backButtonBackgroundColor ?? Colors.transparent,
                  onTap: () {
                    Navigator.pop(screenContext);
                  },
                  borderRadiusRadiusValue: AppComponents.defaultBorderRadius,
                  child:   const Icon(Icons.chevron_left,
                      color: Colors.black)),
            )
          : null,
      title: titleWidget,
      actions: actions,
    );
  }
}

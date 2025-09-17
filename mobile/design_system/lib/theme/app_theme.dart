import 'package:design_system/common/helper.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/theme/app_buttons.dart';
import 'package:design_system/theme/app_color_scheme.dart';
import 'package:design_system/theme/custom_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static ThemeData provideAppTheme(BuildContext buildContext) {
    // It can be changed based on the device
    final textTheme = AppTextStyles.getDefaultAppStyles().getThemeData();
    final colors = AppColorScheme.getDefaultColorScheme();
    final customColors = CustomColors.getCustomColors();
    final customTextStyles = CustomTextStyles.getCustomTextStyles(customColors);
    final appDimension = AppDimension.getDefaultDimensions();
    final buttonTheme = AppButtonsStyle.getDefaultButtonTheme(
      customColors,
      customTextStyles,
      colors,
    );

    return ThemeData(
      extensions: [customColors, customTextStyles, appDimension, buttonTheme],
      primaryColor: colors.primary,
      colorScheme: colors,
      dialogTheme: DialogTheme(
        backgroundColor: colors.surface.shade50,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide.none,
        ),
        titleTextStyle: customTextStyles.customOverline
            .copyWith(color: customColors.textColor!.getShade(400))
            .semibold(),
        contentTextStyle: textTheme.bodyMedium
            ?.copyWith(color: customColors.textColor!.getShade(300)),
      ).data,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: textTheme.bodyMedium
            ?.copyWith(color: customColors.textColor!.getShade(300)),
        filled: true,
        helperStyle: textTheme.bodySmall
            ?.copyWith(color: customColors.textColor!.getShade(200)),
        hintStyle: textTheme.bodyMedium
            ?.copyWith(color: customColors.textColor!.getShade(200)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 1.5,
            color: customColors.textColor!.getShade(200),
          ),
        ),
        fillColor: colors.surface.shade50,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 1.5,
            color: customColors.textColor!.getShade(200),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 1.5,
            color: customColors.danger!.getShade(300),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 2,
            color: colors.primary.shade500,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 1.5,
            color: customColors.textColor!.getShade(100),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            width: 2,
            color: customColors.danger!.getShade(400),
          ),
        ),
        errorStyle: textTheme.labelSmall?.copyWith(color: customColors.danger),
        errorMaxLines: 2,
        hoverColor: colors.primary.shade100,
        focusColor: colors.primary.shade500,
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: textTheme.bodyMedium?.copyWith(
          color: colors.primary.shade500,
        ),
        menuStyle: MenuStyle(
          maximumSize: WidgetStateProperty.resolveWith<Size?>(
            (Set<WidgetState> states) => Size(1.sw, 35.h * 6),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: colors.onSurface.shade200,
            ),
            borderRadius: BorderRadius.all(Radius.circular(4.r)),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: buttonTheme.filledButton,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: buttonTheme.outlineButton,
      ),
      textButtonTheme: TextButtonThemeData(
        style: buttonTheme.textButton,
      ),
      textTheme: textTheme.apply(
        bodyColor: CustomColors.getCustomColors().textColor,
        displayColor: CustomColors.getCustomColors().textColor!.getShade(500),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface.shade50,
        elevation: 2,
        shadowColor:
            Color.alphaBlend(colors.primary.withAlpha(25), Colors.white),
        titleTextStyle: TextStyle(
          color: customColors.textColor!.getShade(400),
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
        ),
        iconTheme: IconThemeData(
          color: customColors.textColor!.getShade(400),
        ),
        actionsIconTheme: IconThemeData(
          color: colors.primary.shade500,
        ),
      ),
      primaryTextTheme: textTheme,
      checkboxTheme: CheckboxThemeData(
        checkColor: getMaterialStatesColors(Colors.white),
        fillColor: getMaterialStatesColors(colors.primary.shade500),
        overlayColor: getMaterialStatesColors(
          Color.alphaBlend(colors.primary.withAlpha(25), Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.r),
        ),
        side: BorderSide(
          width: 2,
          color: customColors.textColor!.getShade(300),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: getMaterialStatesColors(colors.primary.shade500),
        overlayColor: getMaterialStatesColors(
          Color.alphaBlend(colors.primary.withAlpha(25), Colors.white),
        ),
      ),
    );
  }
}

extension ThemeExtensions on ThemeData {
  CustomColors get customColors =>
      extension<CustomColors>() ?? CustomColors.getCustomColors();

  AppDimension get dimensions =>
      extension<AppDimension>() ?? AppDimension.getDefaultDimensions();

  CustomTextStyles get customTextStyles =>
      extension<CustomTextStyles>() ??
      CustomTextStyles.getCustomTextStyles(CustomColors.getCustomColors());

  TextTheme get textStyles => primaryTextTheme;

  AppButtonsStyle get buttonsStyle =>
      extension<AppButtonsStyle>() ??
      AppButtonsStyle.getDefaultButtonTheme(
        CustomColors.getCustomColors(),
        CustomTextStyles.getCustomTextStyles(CustomColors.getCustomColors()),
        AppColorScheme.getDefaultColorScheme(),
      );
}

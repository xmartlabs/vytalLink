import 'package:design_system/extensions/color_extensions.dart';
import 'package:design_system/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VytalLinkCard extends StatelessWidget {
  const VytalLinkCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(24),
    this.borderRadius = 12.0,
    this.elevation = 10.0,
    this.backgroundColor,
    this.shadowColor,
    this.border,
    this.onTap,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double elevation;
  final Color? backgroundColor;
  final Color? shadowColor;
  final Border? border;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final defaultShadowColor =
        Theme.of(context).extension<CustomColors>()?.shadow ??
            const Color(0x1a000000);
    final Widget card = Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius.r),
        border: border,
        boxShadow: [
          BoxShadow(
            color: shadowColor ?? defaultShadowColor,
            offset: const Offset(0, 4),
            blurRadius: elevation,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius.r),
          child: card,
        ),
      );
    }

    return card;
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
    this.iconColor,
    this.onTap,
    this.padding = const EdgeInsets.all(32),
  });

  final IconData icon;
  final String title;
  final String description;
  final Color? iconColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return VytalLinkCard(
      padding: padding,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                (iconColor ?? primaryColor).withAlpha(25),
                Colors.white,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              size: 32.sp,
              color: iconColor ?? primaryColor,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.extension<CustomColors>()?.textColor?.getShade(400),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.extension<CustomColors>()?.textColor?.getShade(300),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({
    required this.title,
    required this.value,
    super.key,
    this.subtitle,
    this.icon,
    this.valueColor,
    this.onTap,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return VytalLinkCard(
      padding: EdgeInsets.all(24.w),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 24.sp,
              color: primaryColor,
            ),
            SizedBox(height: 16.h),
          ],
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.extension<CustomColors>()?.textColor?.getShade(300),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: valueColor ??
                  theme.extension<CustomColors>()?.textColor?.getShade(400),
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color:
                    theme.extension<CustomColors>()?.textColor?.getShade(300),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

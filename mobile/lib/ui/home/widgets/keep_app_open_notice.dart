import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';

class KeepAppOpenNotice extends StatelessWidget {
  final EdgeInsetsGeometry? margin;

  const KeepAppOpenNotice({
    this.margin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final notice = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.customColors.warning!.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.customColors.warning!.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: theme.customColors.warning,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localizations.home_note_keep_open,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.customColors.textColor!.getShade(400),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.localizations.home_helper_keep_open_reason,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.customColors.textColor!.getShade(300),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (margin == null) return notice;
    return Padding(
      padding: margin!,
      child: notice,
    );
  }
}

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';

class HomeValuePropHeader extends StatelessWidget {
  const HomeValuePropHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          VytalLinkCard(
            padding: const EdgeInsets.all(24),
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.05),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.2),
              width: 1.5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.home_value_prop_title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.home_value_prop_subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ValuePropLine(
                      icon: Icons.desktop_windows_rounded,
                      text: localizations.home_value_prop_point_1,
                    ),
                    const SizedBox(height: 8),
                    _ValuePropLine(
                      icon: Icons.key_rounded,
                      text: localizations.home_value_prop_point_2,
                    ),
                    if (Config.requireForegroundSession) ...[
                      const SizedBox(height: 8),
                      _ValuePropLine(
                        icon: Icons.watch_later_outlined,
                        text: localizations.home_value_prop_point_3,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 6,
            bottom: 6,
            child: Container(
              width: 3,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ValuePropLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ValuePropLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

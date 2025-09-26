import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/widgets/bold_tag_text.dart';
import 'package:flutter_template/ui/router/app_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HowItWorksSection extends StatelessWidget {
  final VoidCallback onViewGuide;

  const HowItWorksSection({
    required this.onViewGuide,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;
    final colorScheme = theme.colorScheme;
    return VytalLinkCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.listCheck,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.home_checklist_title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ChecklistItem(
            icon: FontAwesomeIcons.key,
            text: localizations.home_checklist_step_1,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _ChecklistItem(
            icon: FontAwesomeIcons.comments,
            text: localizations.home_checklist_step_2,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _ChecklistItem(
            icon: FontAwesomeIcons.boltLightning,
            text: localizations.home_checklist_step_3,
            theme: theme,
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                TextButton.icon(
                  onPressed: onViewGuide,
                  icon: const Icon(
                    FontAwesomeIcons.arrowUpRightFromSquare,
                    size: 14,
                  ),
                  label: Text(localizations.home_link_where_do_i_chat),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => context.navigateTo(const FaqRoute()),
                  icon: const Icon(
                    FontAwesomeIcons.circleQuestion,
                    size: 14,
                  ),
                  label: Text(localizations.home_link_faq),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.primary,
                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.home_helper_chat_runs_elsewhere,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (Config.requireForegroundSession) ...[
                        const SizedBox(height: 6),
                        Text(
                          localizations.home_note_keep_open,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          localizations.home_helper_keep_open_reason,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final ThemeData theme;

  const _ChecklistItem({
    required this.icon,
    required this.text,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 14,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: BoldTagText(
              text: text,
              baseStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      );
}

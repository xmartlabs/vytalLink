import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.theme.colorScheme.outline
                .withAlpha((0.2 * 255).toInt()),
          ),
          boxShadow: [
            BoxShadow(
              color: context.theme.colorScheme.shadow
                  .withAlpha((0.05 * 255).toInt()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.lightbulb,
                  color: context.theme.colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.how_it_works_title,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._buildSteps(context),
          ],
        ),
      );

  List<Widget> _buildSteps(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      _StepItem(
        number: '1',
        title: localizations.how_it_works_step1_title,
        description: localizations.how_it_works_step1_description,
        icon: FontAwesomeIcons.server,
        isLast: false,
      ),
      _StepItem(
        number: '2',
        title: localizations.how_it_works_step2_title,
        description: localizations.how_it_works_step2_description,
        icon: FontAwesomeIcons.robot,
        isLast: false,
      ),
      _StepItem(
        number: '3',
        title: localizations.how_it_works_step3_title,
        description: localizations.how_it_works_step3_description,
        icon: FontAwesomeIcons.comments,
        isLast: true,
      ),
    ];
  }
}

class _StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final IconData icon;
  final bool isLast;

  const _StepItem({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.isLast,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        number,
                        style: context.theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  if (!isLast) ...[
                    const SizedBox(height: 4),
                    Container(
                      width: 2,
                      height: 24,
                      color: context.theme.colorScheme.outline
                          .withAlpha((0.3 * 255).toInt()),
                    ),
                  ],
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          icon,
                          size: 16,
                          color: context.theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          title,
                          style: context.theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: context.theme.colorScheme.onSurfaceVariant,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isLast) const SizedBox(height: 8),
        ],
      );
}

import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/ui/ai_integration/widgets/expandable_section.dart';
import 'package:flutter_template/ui/ai_integration/widgets/setup_step.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/helpers/url_launcher_helper.dart';
import 'package:flutter_template/ui/widgets/bold_tag_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WhatIsChatGptSection extends StatelessWidget {
  const WhatIsChatGptSection({super.key});

  @override
  Widget build(BuildContext context) => ExpandableSection(
        icon: FontAwesomeIcons.circleInfo,
        title: context.localizations.chatgpt_what_is_title,
        isInitiallyExpanded: false,
        child: Text(
          context.localizations.chatgpt_what_is_description,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: context.theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
}

class ExamplesSection extends StatelessWidget {
  const ExamplesSection({super.key});

  @override
  Widget build(BuildContext context) => ExpandableSection(
        icon: FontAwesomeIcons.lightbulb,
        title: context.localizations.chatgpt_examples_title,
        isInitiallyExpanded: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localizations.chatgpt_examples_description,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            _ExampleQuestionsList(
              questions: [
                context.localizations.chatgpt_example_1,
                context.localizations.chatgpt_example_2,
                context.localizations.chatgpt_example_3,
                context.localizations.chatgpt_example_4,
                context.localizations.chatgpt_example_5,
                context.localizations.chatgpt_example_6,
              ],
            ),
          ],
        ),
      );
}

class HowToSetupSection extends StatelessWidget {
  const HowToSetupSection({super.key});

  @override
  Widget build(BuildContext context) => ExpandableSection(
        icon: FontAwesomeIcons.gear,
        title: context.localizations.chatgpt_setup_title,
        isInitiallyExpanded: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SetupStep(
              number: '1',
              title: context.localizations.chatgpt_step_1_title,
              description: context.localizations.chatgpt_step_1_description,
            ),
            const SizedBox(height: 24),
            SetupStep(
              number: '2',
              title: context.localizations.chatgpt_step_2_title,
              description: context.localizations.chatgpt_step_2_description,
            ),
            const SizedBox(height: 24),
            SetupStep(
              number: '3',
              title: context.localizations.chatgpt_step_3_title,
              description: context.localizations.chatgpt_step_3_description,
            ),
            const SizedBox(height: 24),
            SetupStep(
              number: '4',
              title: context.localizations.chatgpt_step_4_title,
              description: context.localizations.chatgpt_step_4_description,
            ),
          ],
        ),
      );
}

class ChatGptIntegrationHeroSection extends StatelessWidget {
  const ChatGptIntegrationHeroSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.theme.colorScheme.secondary.withValues(alpha: 0.05),
              context.theme.colorScheme.secondary.withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.theme.colorScheme.secondary,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  FontAwesomeIcons.comments,
                  color: context.theme.customColors.textColor!.getShade(100),
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.localizations.chatgpt_integration_hero_title,
              style: context.theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.localizations.chatgpt_integration_hero_subtitle,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}

class ChatGptDesktopNoticeSection extends StatelessWidget {
  const ChatGptDesktopNoticeSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.theme.colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: context.theme.colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.localizations.home_note_keep_open,
                    style: context.theme.textTheme.titleSmall?.copyWith(
                      color: context.theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  BoldTagText(
                    text: context
                        .localizations.chatgpt_helper_chat_runs_on_desktop,
                    baseStyle: context.theme.textTheme.bodySmall?.copyWith(
                      color: context.theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class ChatGptUseButtonSection extends StatelessWidget {
  const ChatGptUseButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    if (Config.requireForegroundSession) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => UrlLauncherHelper.launch(Config.gptIntegrationUrl),
        icon: const Icon(FontAwesomeIcons.comments, size: 20),
        label: Text(
          context.localizations.chatgpt_start_button,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.theme.colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _ExampleQuestionsList extends StatelessWidget {
  final List<String> questions;

  const _ExampleQuestionsList({
    required this.questions,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: questions
            .map(
              (question) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      context.theme.colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: context.theme.colorScheme.primary
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      FontAwesomeIcons.commentDots,
                      size: 14,
                      color: context.theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        question,
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: context.theme.colorScheme.onSurface,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      );
}

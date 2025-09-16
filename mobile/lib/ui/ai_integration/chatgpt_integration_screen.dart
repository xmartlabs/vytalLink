import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/ui/ai_integration/widgets/chatgpt_integration_sections.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class ChatGptIntegrationScreen extends StatelessWidget {
  const ChatGptIntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primary
                      .withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.comments,
                    color: context.theme.colorScheme.primary,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.localizations.chatgpt_integration_title,
                style: TextStyle(
                  color: context.theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          centerTitle: true,
          backgroundColor: context.theme.colorScheme.surface,
          elevation: 1,
          shadowColor:
              context.theme.colorScheme.shadow.withAlpha((0.1 * 255).toInt()),
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChatGptIntegrationHeroSection(),
                SizedBox(height: 32),
                WhatIsChatGptSection(),
                SizedBox(height: 24),
                HowToSetupSection(),
                SizedBox(height: 24),
                ExamplesSection(),
                SizedBox(height: 32),
                ChatGptUseButtonSection(),
              ],
            ),
          ),
        ),
      );
}

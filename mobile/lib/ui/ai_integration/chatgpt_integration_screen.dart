import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/ui/ai_integration/widgets/chatgpt_integration_sections.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/router/app_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class ChatGptIntegrationScreen extends StatelessWidget {
  const ChatGptIntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: context.theme.colorScheme.onSurface,
            onPressed: () => context.router.maybePop(),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.comments,
                color: context.theme.colorScheme.onSurface,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(context.localizations.chatgpt_integration_title),
            ],
          ),
          centerTitle: true,
          backgroundColor: context.theme.colorScheme.surface,
          elevation: 2,
          shadowColor:
              context.theme.colorScheme.primary.withValues(alpha: 0.08),
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

  void _openFaq(BuildContext context) => context.router.push(const FaqRoute());
}

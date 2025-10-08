import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/gen/assets.gen.dart';
import 'package:flutter_template/ui/ai_integration/widgets/chatgpt_integration_sections.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';

@RoutePage()
class ChatGptIntegrationScreen extends StatefulWidget {
  const ChatGptIntegrationScreen({super.key});

  @override
  State<ChatGptIntegrationScreen> createState() =>
      _ChatGptIntegrationScreenState();
}

class _ChatGptIntegrationScreenState extends State<ChatGptIntegrationScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
              Assets.icons.chatgpt.svg(
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  context.theme.colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
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
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(24),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ChatGptIntegrationHeroSection(),
                SizedBox(height: 12),
                ChatGptDesktopNoticeSection(),
                SizedBox(height: 24),
                WhatIsChatGptSection(),
                SizedBox(height: 24),
                HowToSetupSection(),
                SizedBox(height: 24),
                ExamplesSection(),
              ],
            ),
          ),
        ),
      );
}

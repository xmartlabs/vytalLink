import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/ui/ai_integration/widgets/mcp_integration_sections.dart';
import 'package:flutter_template/ui/faq/faq_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';

@RoutePage()
class McpIntegrationScreen extends StatelessWidget {
  const McpIntegrationScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FontAwesomeIcons.server,
                color: context.theme.colorScheme.onSurface,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(context.localizations.mcp_integration_title),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: context.theme.colorScheme.onSurface,
            onPressed: () => context.router.maybePop(),
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
                McpHeroCardSection(),
                SizedBox(height: 24),
                ClaudeBundleSection(),
                SizedBox(height: 24),
                SupportedClientsSection(),
                SizedBox(height: 24),
                WhatIsMcpSection(),
                SizedBox(height: 24),
                HowToSetupSection(),
                SizedBox(height: 24),
                WhatYouCanDoSection(),
              ],
            ),
          ),
        ),
      );

  void _openFaq(BuildContext context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const FaqScreen()),
      );
}

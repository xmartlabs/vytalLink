import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/ui/ai_integration/widgets/mcp_integration_sections.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color:
                      context.theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.server,
                    color: context.theme.colorScheme.primary,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                context.localizations.mcp_integration_title,
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
                McpHeroCardSection(),
                SizedBox(height: 32),
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
}

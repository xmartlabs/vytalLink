import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/ui/ai_integration/widgets/client_card.dart';
import 'package:flutter_template/ui/ai_integration/widgets/expandable_section.dart';
import 'package:flutter_template/ui/ai_integration/widgets/section_card.dart';
import 'package:flutter_template/ui/ai_integration/widgets/setup_step.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/helpers/url_launcher_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String _setupMcpCommand =
    'npm install -g @xmartlabs/vytallink-mcp-server';
const String _exampleConfigJson =
    '{\n  "mcpServers": {\n    "vytalLink": {\n      "command": "npx",\n      "args": [\n        "@xmartlabs/vytallink-mcp-server"\n      ]\n    }\n  }\n}';

class WhatIsMcpSection extends StatelessWidget {
  const WhatIsMcpSection({super.key});

  @override
  Widget build(BuildContext context) => ExpandableSection(
        icon: FontAwesomeIcons.circleInfo,
        title: context.localizations.mcp_what_is_title,
        isInitiallyExpanded: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localizations.mcp_what_is_description,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            _FeatureList(
              features: [
                context.localizations.mcp_feature_1,
                context.localizations.mcp_feature_2,
                context.localizations.mcp_feature_3,
                context.localizations.mcp_feature_4,
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
        title: context.localizations.mcp_setup_title,
        isInitiallyExpanded: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localizations.mcp_setup_intro,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SetupStep(
              number: '1',
              title: context.localizations.mcp_step_1_title,
              description: '${context.localizations.mcp_step_1_description}\n\n'
                  '${context.localizations.mcp_setup_nodejs_requirement}',
              codeSnippet: _setupMcpCommand,
              actionButton: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => UrlLauncherHelper.launch(
                    Config.setupMcpDocumentationUri,
                  ),
                  icon: const Icon(
                    FontAwesomeIcons.arrowUpRightFromSquare,
                    size: 14,
                  ),
                  label: Text(context.localizations.mcp_setup_guide_button),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SetupStep(
              number: '2',
              title: context.localizations.mcp_step_2_title,
              description: context.localizations.mcp_step_2_description,
              actionButton: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      context.localizations.example_config_title,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: context.theme.colorScheme.primary
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: SelectableText(
                      _exampleConfigJson,
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SetupStep(
              number: '3',
              title: context.localizations.mcp_step_3_title,
              description: context.localizations.mcp_step_3_description,
            ),
          ],
        ),
      );
}

class WhatYouCanDoSection extends StatelessWidget {
  const WhatYouCanDoSection({super.key});

  @override
  Widget build(BuildContext context) => ExpandableSection(
        icon: FontAwesomeIcons.star,
        title: context.localizations.mcp_examples_title,
        isInitiallyExpanded: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localizations.mcp_examples_description,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            _UseCaseList(
              useCases: [
                context.localizations.mcp_example_1,
                context.localizations.mcp_example_2,
                context.localizations.mcp_example_3,
                context.localizations.mcp_example_4,
              ],
            ),
          ],
        ),
      );
}

class _FeatureList extends StatelessWidget {
  final List<String> features;

  const _FeatureList({
    required this.features,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: features.map((feature) => Text('- $feature')).toList(),
      );
}

class _UseCaseList extends StatelessWidget {
  final List<String> useCases;

  const _UseCaseList({
    required this.useCases,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: useCases.map((useCase) => Text('- $useCase')).toList(),
      );
}

class SupportedClientsSection extends StatelessWidget {
  const SupportedClientsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) => SectionCard(
        icon: FontAwesomeIcons.laptopCode,
        title: context.localizations.mcp_supported_clients_title,
        content: Column(
          children: [
            Stack(
              children: [
                ClientCard(
                  icon: FontAwesomeIcons.brain,
                  name: context.localizations.mcp_claude_desktop_name,
                  description:
                      context.localizations.mcp_claude_desktop_description,
                  color: context.theme.colorScheme.primary,
                  onTap: () => UrlLauncherHelper.launch(
                    Config.claudeBundleSetupUri,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: context.theme.customColors.shadow!,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      context.localizations.mcp_recommended_badge,
                      style: context.theme.textTheme.labelSmall?.copyWith(
                        color: context.theme.customColors.textColor!
                            .getShade(100),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _DevelopmentToolsCard(),
            const SizedBox(height: 12),
            ClientCard(
              icon: FontAwesomeIcons.plugCircleCheck,
              name: context.localizations.mcp_any_client_name,
              description: context.localizations.mcp_any_client_description,
              color: context.theme.colorScheme.primary,
              onTap: null,
              showLinkIcon: false,
            ),
          ],
        ),
      );
}

class ClaudeBundleSection extends StatelessWidget {
  const ClaudeBundleSection({super.key});

  @override
  Widget build(BuildContext context) => SectionCard(
        icon: FontAwesomeIcons.boltLightning,
        title: context.localizations.mcp_bundle_section_title,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localizations.mcp_bundle_section_description,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () =>
                    UrlLauncherHelper.launch(Config.claudeBundleSetupUri),
                icon: const Icon(FontAwesomeIcons.arrowUpRightFromSquare),
                label: Text(
                  context.localizations.mcp_bundle_guide_button,
                ),
              ),
            ),
          ],
        ),
      );
}

class McpHeroCardSection extends StatelessWidget {
  const McpHeroCardSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.theme.colorScheme.primary.withValues(alpha: 0.05),
              context.theme.colorScheme.primary.withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: context.theme.colorScheme.primary,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  FontAwesomeIcons.server,
                  color: context.theme.customColors.textColor!.getShade(100),
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.localizations.mcp_integration_hero_title,
              style: context.theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: context.theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              context.localizations.mcp_integration_hero_subtitle,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}

class _DevelopmentToolsCard extends StatelessWidget {
  const _DevelopmentToolsCard({super.key});

  @override
  Widget build(BuildContext context) => ClientCard(
        icon: FontAwesomeIcons.code,
        name: context.localizations.mcp_development_tools_name,
        description: '${context.localizations.mcp_cursor_name} & '
            '${context.localizations.mcp_vscode_name} - '
            '${context.localizations.mcp_development_tools_description}',
        color: context.theme.colorScheme.primary,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              final primaryColor = context.theme.colorScheme.primary;
              return Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.localizations.mcp_choose_development_tool,
                      style: context.theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FontAwesomeIcons.terminal,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      title: Text(context.localizations.mcp_cursor_name),
                      subtitle:
                          Text(context.localizations.mcp_cursor_description),
                      trailing: const Icon(
                        FontAwesomeIcons.arrowUpRightFromSquare,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        UrlLauncherHelper.launch(Config.cursorDownloadUrl);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          FontAwesomeIcons.laptopCode,
                          color: primaryColor,
                          size: 20,
                        ),
                      ),
                      title: Text(context.localizations.mcp_vscode_name),
                      subtitle:
                          Text(context.localizations.mcp_vscode_description),
                      trailing: const Icon(
                        FontAwesomeIcons.arrowUpRightFromSquare,
                        size: 16,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        UrlLauncherHelper.launch(Config.vscodeDownloadUrl);
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          );
        },
      );
}

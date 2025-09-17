import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:flutter_template/ui/router/app_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String chatGptHeroTag = "chatgpt-hero";
const String mcpHeroTag = "mcp-hero";

class AiIntegrationCard extends StatelessWidget {
  const AiIntegrationCard({super.key});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 24, bottom: 24),
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.theme.colorScheme.primary
                        .withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(-2, -2),
                      child: Icon(
                        FontAwesomeIcons.robot,
                        color: context.theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.ai_integration_title,
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.ai_integration_subtitle,
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: context.theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _IntegrationOption(
                    icon: FontAwesomeIcons.comments,
                    title: AppLocalizations.of(context)!.ai_integration_chatgpt,
                    subtitle: AppLocalizations.of(context)!
                        .ai_integration_chatgpt_subtitle,
                    color: const Color(0xFF10A37F),
                    heroTag: chatGptHeroTag,
                    onTap: () =>
                        context.router.push(const ChatGptIntegrationRoute()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _IntegrationOption(
                    icon: FontAwesomeIcons.server,
                    title: AppLocalizations.of(context)!.ai_integration_mcp,
                    subtitle: AppLocalizations.of(context)!
                        .ai_integration_mcp_subtitle,
                    color: const Color(0xFF6366F1),
                    heroTag: mcpHeroTag,
                    onTap: () =>
                        context.router.push(const McpIntegrationRoute()),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _IntegrationOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String heroTag;
  final VoidCallback onTap;

  const _IntegrationOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.heroTag,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withAlpha((0.05 * 255).toInt()),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withAlpha((0.2 * 255).toInt()),
            ),
          ),
          child: Column(
            children: [
              Hero(
                tag: heroTag,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: color,
                      size: 22,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: context.theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.theme.colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: context.theme.colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                FontAwesomeIcons.arrowUpRightFromSquare,
                size: 12,
                color: color,
              ),
            ],
          ),
        ),
      );
}

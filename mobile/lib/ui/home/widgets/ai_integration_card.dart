import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/router/app_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_template/gen/assets.gen.dart';

class AiIntegrationCard extends StatelessWidget {
  const AiIntegrationCard({super.key});

  @override
  Widget build(BuildContext context) => VytalLinkCard(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(24),
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
                        .withValues(alpha: 0.1),
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
                        context.localizations.ai_integration_title,
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        context.localizations.ai_integration_subtitle,
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
                    title: context.localizations.ai_integration_chatgpt,
                    subtitle:
                        context.localizations.ai_integration_chatgpt_subtitle,
                    color: context.theme.colorScheme.secondary.getShade(500),
                    leadingIconBuilder: (color) => Assets.icons.chatgpt.svg(
                      width: 22,
                      height: 22,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                    onTap: () =>
                        context.router.push(const ChatGptIntegrationRoute()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _IntegrationOption(
                    icon: FontAwesomeIcons.server,
                    title: context.localizations.ai_integration_mcp,
                    subtitle: context.localizations.ai_integration_mcp_subtitle,
                    color: context.theme.colorScheme.primary.getShade(500),
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
  final VoidCallback onTap;
  final Widget Function(Color color)? leadingIconBuilder;

  const _IntegrationOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    this.leadingIconBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: leadingIconBuilder != null
                      ? leadingIconBuilder!(color)
                      : Icon(
                          icon,
                          color: color,
                          size: 22,
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

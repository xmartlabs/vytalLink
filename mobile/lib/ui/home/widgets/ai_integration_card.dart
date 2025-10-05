import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/model/mcp_connection_state.dart';
import 'package:flutter_template/gen/assets.gen.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/home/helpers/chatgpt_quick_action_helper.dart';
import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:flutter_template/ui/router/app_router.dart';

class AiIntegrationCard extends StatelessWidget {
  final McpServerStatus status;
  final BridgeCredentials? bridgeCredentials;
  final Future<BridgeCredentials?> Function()? connectCallback;

  const AiIntegrationCard({
    required this.status,
    required this.bridgeCredentials,
    this.connectCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    return VytalLinkCard(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localizations.ai_integration_title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.localizations.home_ai_card_intro,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.localizations.home_ai_card_guide_header,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.localizations.home_ai_card_blog_gpt,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.localizations.home_ai_card_blog_claude,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          _AiOptionSection(
            accentColor: colorScheme.primary,
            icon: Icon(
              Icons.desktop_windows,
              color: colorScheme.primary,
              size: 22,
            ),
            title: context.localizations.home_ai_card_desktop_title,
            description: context.localizations.home_ai_card_desktop_description,
            hint: context.localizations.home_ai_card_desktop_hint,
            badgeLabel: context.localizations.mcp_recommended_badge,
            actions: [
              AppButton.filled(
                label: context.localizations.home_dialog_chatgpt_view_guide,
                icon: Assets.icons.chatgpt.svg(
                  width: AppButtonDefaults.iconSize,
                  height: AppButtonDefaults.iconSize,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () =>
                    context.router.push(const ChatGptIntegrationRoute()),
              ),
              AppButton.outlined(
                label: context.localizations.home_dialog_claude_view_guide,
                icon: Assets.icons.claude.svg(
                  width: AppButtonDefaults.iconSize,
                  height: AppButtonDefaults.iconSize,
                  colorFilter: ColorFilter.mode(
                    colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () =>
                    context.router.push(const McpIntegrationRoute()),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _AiOptionSection(
            accentColor: colorScheme.primary,
            icon: Icon(
              Icons.phone_iphone,
              color: colorScheme.primary,
              size: 22,
            ),
            title: context.localizations.home_ai_card_mobile_title,
            description: context.localizations.home_ai_card_mobile_description,
            hint: context.localizations.home_ai_card_mobile_hint,
            actions: [
              AppButton.filled(
                label: context.localizations.chatgpt_open_custom_gpt,
                icon: Assets.icons.chatgpt.svg(
                  width: AppButtonDefaults.iconSize,
                  height: AppButtonDefaults.iconSize,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
                onPressed: () => launchChatGptQuickAction(
                  context: context,
                  credentials: bridgeCredentials,
                  connectCallback: connectCallback,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AiOptionSection extends StatelessWidget {
  final Color accentColor;
  final Widget icon;
  final String title;
  final String description;
  final String hint;
  final String? badgeLabel;
  final List<Widget> actions;

  const _AiOptionSection({
    required this.accentColor,
    required this.icon,
    required this.title,
    required this.description,
    required this.hint,
    required this.actions,
    this.badgeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: icon),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (badgeLabel != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badgeLabel!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                              letterSpacing: 0.3,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._intersperse(actions, const SizedBox(height: 8)),
        const SizedBox(height: 10),
        Text(
          hint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  static List<Widget> _intersperse(List<Widget> items, Widget separator) {
    if (items.isEmpty) return const [];
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      result.add(items[i]);
      if (i != items.length - 1) {
        result.add(separator);
      }
    }
    return result;
  }
}

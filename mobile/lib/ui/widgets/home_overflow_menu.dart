import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/router/app_router.dart';
import 'package:flutter_template/ui/web/web_page_screen.dart';
import 'package:flutter_template/gen/assets.gen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef _MenuItemData = ({
  _HomeOverflowAction value,
  String label,
  IconData? icon,
  Widget? leading,
});

enum _HomeOverflowAction {
  chatGpt,
  mcp,
  faq,
  privacy,
  terms,
  contact,
  about,
}

class HomeOverflowMenu extends StatelessWidget {
  const HomeOverflowMenu({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 2),
        child: SizedBox(
          width: 40,
          height: 40,
          child: PopupMenuButton<_HomeOverflowAction>(
            tooltip: MaterialLocalizations.of(context).showMenuTooltip,
            icon: const Icon(Icons.more_vert_rounded),
            offset: const Offset(-6, 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: context.theme.colorScheme.surface,
            elevation: 8,
            shadowColor: context.theme.shadowColor.withValues(alpha: 0.2),
            itemBuilder: (context) => _buildItems(context),
            onSelected: (action) => _handleAction(context, action),
          ),
        ),
      );

  List<PopupMenuEntry<_HomeOverflowAction>> _buildItems(BuildContext context) =>
      [
        ..._buildAiIntegrationItems(context),
        const PopupMenuDivider(height: 8),
        ..._buildSupportItems(context),
      ];

  List<PopupMenuEntry<_HomeOverflowAction>> _buildAiIntegrationItems(
    BuildContext context,
  ) {
    final theme = context.theme;
    final loc = context.localizations;

    return [
      _buildMenuItem(
        context,
        (
          value: _HomeOverflowAction.chatGpt,
          label: loc.ai_integration_chatgpt,
          icon: null,
          leading: Assets.icons.chatgpt.svg(
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      _buildMenuItem(
        context,
        (
          value: _HomeOverflowAction.mcp,
          label: loc.ai_integration_mcp,
          icon: FontAwesomeIcons.server,
          leading: null,
        ),
      ),
    ];
  }

  List<PopupMenuEntry<_HomeOverflowAction>> _buildSupportItems(
    BuildContext context,
  ) {
    final loc = context.localizations;

    return [
      _buildMenuItem(
        context,
        (
          value: _HomeOverflowAction.faq,
          label: loc.home_link_faq,
          icon: FontAwesomeIcons.circleQuestion,
          leading: null,
        ),
      ),
      _buildMenuItem(
        context,
        (
          value: _HomeOverflowAction.privacy,
          label: loc.support_privacy,
          icon: FontAwesomeIcons.shieldHalved,
          leading: null,
        ),
      ),
      _buildMenuItem(
        context,
        (
          value: _HomeOverflowAction.terms,
          label: loc.support_terms,
          icon: FontAwesomeIcons.fileContract,
          leading: null,
        ),
      ),
      _buildMenuItem(
        context,
        (
          value: _HomeOverflowAction.contact,
          label: loc.support_contact,
          icon: FontAwesomeIcons.envelope,
          leading: null,
        ),
      ),
      _buildMenuItem(
        context,
        (
          value: _HomeOverflowAction.about,
          label: loc.support_about,
          icon: FontAwesomeIcons.circleInfo,
          leading: null,
        ),
      ),
    ];
  }

  PopupMenuItem<_HomeOverflowAction> _buildMenuItem(
    BuildContext context,
    _MenuItemData data,
  ) {
    final theme = context.theme;

    return PopupMenuItem<_HomeOverflowAction>(
      value: data.value,
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: data.leading ??
                Icon(
                  data.icon,
                  size: 18,
                  color: theme.colorScheme.onSurface,
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              data.label,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    _HomeOverflowAction action,
  ) async {
    switch (action) {
      case _HomeOverflowAction.chatGpt:
        await context.navigateTo(const ChatGptIntegrationRoute());
        break;
      case _HomeOverflowAction.mcp:
        await context.navigateTo(const McpIntegrationRoute());
        break;
      case _HomeOverflowAction.faq:
        await context.navigateTo(const FaqRoute());
        break;
      case _HomeOverflowAction.privacy:
        await _openWebUrl(
          context,
          Config.supportPrivacyUri,
          context.localizations.support_privacy,
        );
        break;
      case _HomeOverflowAction.terms:
        await _openWebUrl(
          context,
          Config.supportTermsUri,
          context.localizations.support_terms,
        );
        break;
      case _HomeOverflowAction.contact:
        await _openWebUrl(
          context,
          Config.supportContactUri,
          context.localizations.support_contact,
        );
        break;
      case _HomeOverflowAction.about:
        await _openWebUrl(
          context,
          Config.aboutUri,
          context.localizations.support_about,
        );
        break;
    }
  }

  Future<void> _openWebUrl(
    BuildContext context,
    String url,
    String title,
  ) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => WebPageScreen(url: url, title: title),
        ),
      );
}

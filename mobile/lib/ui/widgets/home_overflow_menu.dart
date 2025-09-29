import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/router/app_router.dart';
import 'package:flutter_template/ui/web/web_page_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_template/gen/assets.gen.dart';

class HomeOverflowMenu extends StatelessWidget {
  const HomeOverflowMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final loc = context.localizations;

    void openWebUrl(String url, String title) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WebPageScreen(url: url, title: title),
          ),
        );

    MenuItemButton item({
      required String label,
      required VoidCallback onPressed,
      IconData? icon,
      Widget? leading,
    }) =>
        MenuItemButton(
          leadingIcon: leading ??
              Icon(
                icon,
                size: 18,
                color: theme.colorScheme.onSurface,
              ),
          onPressed: onPressed,
          child: Text(label, overflow: TextOverflow.ellipsis),
        );

    return MenuAnchor(
      style: const MenuStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        ),
        elevation: WidgetStatePropertyAll(8),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      builder: (context, controller, _) => IconButton(
        icon: const Icon(Icons.more_vert_rounded),
        onPressed: () =>
            controller.isOpen ? controller.close() : controller.open(),
      ),
      menuChildren: [
        item(
          leading: Assets.icons.chatgpt.svg(
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
          label: loc.ai_integration_chatgpt,
          onPressed: () => context.navigateTo(const ChatGptIntegrationRoute()),
        ),
        item(
          icon: FontAwesomeIcons.server,
          label: loc.ai_integration_mcp,
          onPressed: () => context.navigateTo(const McpIntegrationRoute()),
        ),
        const Divider(height: 8),
        item(
          icon: FontAwesomeIcons.circleQuestion,
          label: loc.home_link_faq,
          onPressed: () => context.navigateTo(const FaqRoute()),
        ),
        item(
          icon: FontAwesomeIcons.shieldHalved,
          label: loc.support_privacy,
          onPressed: () =>
              openWebUrl(Config.supportPrivacyUri, loc.support_privacy),
        ),
        item(
          icon: FontAwesomeIcons.fileContract,
          label: loc.support_terms,
          onPressed: () =>
              openWebUrl(Config.supportTermsUri, loc.support_terms),
        ),
        item(
          icon: FontAwesomeIcons.envelope,
          label: loc.support_contact,
          onPressed: () =>
              openWebUrl(Config.supportContactUri, loc.support_contact),
        ),
        item(
          icon: FontAwesomeIcons.circleInfo,
          label: loc.support_about,
          onPressed: () => openWebUrl(Config.aboutUri, loc.support_about),
        ),
      ],
    );
  }
}

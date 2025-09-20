import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:flutter_template/ui/home/widgets/server_action_button_widget.dart';

class AnimatedServerCard extends StatelessWidget {
  final McpServerStatus status;
  final String errorMessage;
  final Animation<double> pulseAnimation;
  final VoidCallback? onStartPressed;

  const AnimatedServerCard({
    required this.pulseAnimation,
    required this.status,
    required this.errorMessage,
    this.onStartPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) => VytalLinkCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: pulseAnimation,
                  builder: (context, child) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getServerIconColor(context, status)
                          .withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: status == McpServerStatus.running
                          ? [
                              BoxShadow(
                                color: _getServerIconColor(context, status)
                                    .withAlpha((0.3 * 255).toInt()),
                                offset: const Offset(0, 0),
                                blurRadius: 10 * pulseAnimation.value,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                    child: Transform.scale(
                      scale: status == McpServerStatus.running
                          ? pulseAnimation.value
                          : 1.0,
                      child: AnimatedRotation(
                        duration: const Duration(seconds: 2),
                        turns: status == McpServerStatus.starting ||
                                status == McpServerStatus.reconnecting ||
                                status == McpServerStatus.stopping
                            ? 1
                            : 0,
                        child: Icon(
                          _getServerIcon(status),
                          size: 32,
                          color: _getServerIconColor(context, status),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getServerStatusTitle(context, status),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: context.theme.customColors.textColor!
                              .getShade(400),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getServerDescriptionText(context, status),
                        style: TextStyle(
                          fontSize: 14,
                          color: context.theme.customColors.textColor!
                              .getShade(300),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                if (status == McpServerStatus.running)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.theme.customColors.success!
                          .withAlpha((0.1 * 255).toInt()),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: context.theme.customColors.success!
                            .withAlpha((0.3 * 255).toInt()),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: context.theme.customColors.success,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppLocalizations.of(context)!.home_online_status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: context.theme.customColors.success,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ServerActionButtonWidget(
              errorMessage: errorMessage,
              status: status,
              onStartPressed: onStartPressed,
            ),
          ],
        ),
      );

  String _getServerStatusTitle(BuildContext context, McpServerStatus status) {
    switch (status) {
      case McpServerStatus.idle:
        return AppLocalizations.of(context)!.home_status_offline;
      case McpServerStatus.starting:
        return AppLocalizations.of(context)!.home_status_starting;
      case McpServerStatus.reconnecting:
        return AppLocalizations.of(context)!.home_status_starting;
      case McpServerStatus.running:
        return AppLocalizations.of(context)!.home_status_running;
      case McpServerStatus.stopping:
        return AppLocalizations.of(context)!.home_status_stopping;
      case McpServerStatus.error:
        return AppLocalizations.of(context)!.home_status_error;
    }
  }

  IconData _getServerIcon(McpServerStatus status) {
    switch (status) {
      case McpServerStatus.idle:
        return Icons.cloud_off;
      case McpServerStatus.starting:
        return Icons.cloud_sync;
      case McpServerStatus.reconnecting:
        return Icons.cloud_sync;
      case McpServerStatus.running:
        return Icons.cloud_done;
      case McpServerStatus.stopping:
        return Icons.cloud_sync;
      case McpServerStatus.error:
        return Icons.cloud_off;
    }
  }

  Color _getServerIconColor(BuildContext context, McpServerStatus status) {
    switch (status) {
      case McpServerStatus.idle:
        return context.theme.customColors.textColor!.getShade(300);
      case McpServerStatus.starting:
        return context.theme.colorScheme.primary;
      case McpServerStatus.reconnecting:
        return context.theme.colorScheme.primary;
      case McpServerStatus.running:
        return context.theme.customColors.success!;
      case McpServerStatus.stopping:
        return context.theme.colorScheme.primary;
      case McpServerStatus.error:
        return context.theme.customColors.danger!;
    }
  }

  String _getServerDescriptionText(
    BuildContext context,
    McpServerStatus status,
  ) {
    switch (status) {
      case McpServerStatus.idle:
        return context.localizations.home_description_offline;
      case McpServerStatus.starting:
        return context.localizations.home_description_starting;
      case McpServerStatus.reconnecting:
        return context.localizations.home_description_starting;
      case McpServerStatus.running:
        return context.localizations.home_description_running;
      case McpServerStatus.stopping:
        return context.localizations.home_description_stopping;
      case McpServerStatus.error:
        return context.localizations.home_description_error;
    }
  }
}

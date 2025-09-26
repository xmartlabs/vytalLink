import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:flutter_template/ui/home/widgets/keep_app_open_notice.dart';
import 'package:flutter_template/ui/home/widgets/server_action_button_widget.dart';
import 'package:flutter_template/ui/router/app_router.dart';

class AnimatedServerCard extends StatelessWidget {
  final McpServerStatus status;
  final String errorMessage;
  final Animation<double> pulseAnimation;
  final VoidCallback? onStartPressed;
  final String connectionWord;
  final String connectionPin;

  const AnimatedServerCard({
    required this.pulseAnimation,
    required this.status,
    required this.errorMessage,
    this.onStartPressed,
    this.connectionWord = '',
    this.connectionPin = '',
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
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: status == McpServerStatus.running
                          ? [
                              BoxShadow(
                                color: _getServerIconColor(context, status)
                                    .withValues(alpha: 0.3),
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
                          fontSize: 20,
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
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: context.theme.customColors.success!
                            .withValues(alpha: 0.3),
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
                          context.localizations.home_online_status,
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
            if (status == McpServerStatus.running) const KeepAppOpenNotice(),
            if (status == McpServerStatus.running) const SizedBox(height: 16),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: status == McpServerStatus.running &&
                      connectionWord.isNotEmpty &&
                      connectionPin.isNotEmpty
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                key: const ValueKey('credentials-container'),
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _InlineCredentials(
                    word: connectionWord,
                    pin: connectionPin,
                    onCopy: (value) => _copyToClipboard(context, value),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            ServerActionButtonWidget(
              errorMessage: errorMessage,
              status: status,
              onStartPressed: onStartPressed,
              onChatGptPressed: () => context.router.popAndPush(
                const AuthenticatedSectionRoute(
                  children: [ChatGptIntegrationRoute()],
                ),
              ),
              onClaudePressed: () => context.router.popAndPush(
                const AuthenticatedSectionRoute(
                  children: [McpIntegrationRoute()],
                ),
              ),
            ),
          ],
        ),
      );

  void _copyToClipboard(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            context.localizations.home_toast_copy_success,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: context.theme.customColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  String _getServerStatusTitle(BuildContext context, McpServerStatus status) {
    switch (status) {
      case McpServerStatus.idle:
        return context.localizations.home_status_offline;
      case McpServerStatus.starting:
        return context.localizations.home_status_starting;
      case McpServerStatus.running:
        return context.localizations.home_status_running;
      case McpServerStatus.stopping:
        return context.localizations.home_status_stopping;
      case McpServerStatus.error:
        return context.localizations.home_status_error;
    }
  }

  IconData _getServerIcon(McpServerStatus status) {
    switch (status) {
      case McpServerStatus.idle:
        return Icons.cloud_off;
      case McpServerStatus.starting:
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
      case McpServerStatus.running:
        return context.localizations.home_description_running;
      case McpServerStatus.stopping:
        return context.localizations.home_description_stopping;
      case McpServerStatus.error:
        return context.localizations.home_description_error;
    }
  }
}

class _InlineCredentials extends StatelessWidget {
  final String word;
  final String pin;
  final ValueChanged<String> onCopy;

  const _InlineCredentials({
    required this.word,
    required this.pin,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final localizations = context.localizations;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _CredentialColumn(
              label: localizations.credentials_word_label,
              value: word,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _CredentialColumn(
              label: localizations.credentials_pin_label,
              value: pin,
            ),
          ),
          IconButton(
            onPressed: () => onCopy('$word | $pin'),
            icon: Icon(
              Icons.copy_rounded,
              color: theme.colorScheme.primary,
            ),
            tooltip: localizations.home_toast_copy_success,
          ),
        ],
      ),
    );
  }
}

class _CredentialColumn extends StatelessWidget {
  final String label;
  final String value;

  const _CredentialColumn({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.1,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

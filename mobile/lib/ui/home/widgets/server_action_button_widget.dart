import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServerActionButtonWidget extends StatelessWidget {
  final String errorMessage;
  final McpServerStatus status;
  final VoidCallback? onStartPressed;
  final VoidCallback? onChatGptPressed;
  final VoidCallback? onClaudePressed;

  const ServerActionButtonWidget({
    required this.errorMessage,
    required this.status,
    this.onStartPressed,
    this.onChatGptPressed,
    this.onClaudePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: _buildStateContent(context),
      );

  Widget _buildStateContent(BuildContext context) {
    switch (status) {
      case McpServerStatus.idle:
        return _StartButton(
          key: const ValueKey('start'),
          onPressed: onStartPressed,
        );
      case McpServerStatus.starting:
        return _LoadingButton(
          key: const ValueKey('starting'),
          label: context.localizations.home_button_starting,
        );
      case McpServerStatus.running:
        return _RunningButtons(
          key: const ValueKey('running'),
          onChatGptPressed: onChatGptPressed,
          onClaudePressed: onClaudePressed,
        );
      case McpServerStatus.stopping:
        return _LoadingButton(
          key: const ValueKey('stopping'),
          label: context.localizations.home_button_stopping,
        );
      case McpServerStatus.error:
        return _ErrorButton(
          key: const ValueKey('error'),
          errorMessage: errorMessage,
        );
    }
  }
}

class _ErrorButton extends StatelessWidget {
  final String errorMessage;

  const _ErrorButton({
    required this.errorMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          if (errorMessage.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    context.theme.customColors.danger!.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      context.theme.customColors.danger!.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: context.theme.customColors.danger,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorMessage,
                      style: TextStyle(
                        color: context.theme.customColors.danger,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.read<HomeCubit>().startMCPServer(),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: Text(context.localizations.connection_error_retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.customColors.danger,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor:
                    context.theme.customColors.danger!.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      );
}

class _LoadingButton extends StatelessWidget {
  final String label;

  const _LoadingButton({
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: null,
          icon: const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.theme.customColors.warning,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 2,
          ),
        ),
      );
}

class _RunningButtons extends StatelessWidget {
  final VoidCallback? onChatGptPressed;
  final VoidCallback? onClaudePressed;

  const _RunningButtons({
    required this.onChatGptPressed,
    required this.onClaudePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              if (onChatGptPressed == null) return;
              _showChatDialog(
                context,
                (
                  title: context.localizations.home_dialog_chatgpt_title,
                  message: context.localizations.home_dialog_chatgpt_body,
                  actionLabel:
                      context.localizations.home_dialog_chatgpt_view_guide,
                  onAction: () => onChatGptPressed?.call(),
                ),
              );
            },
            icon: const Icon(FontAwesomeIcons.comments, size: 16),
            label: Text(context.localizations.home_button_chatgpt),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor:
                  context.theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              if (onClaudePressed == null) return;
              _showChatDialog(
                context,
                (
                  title: context.localizations.home_dialog_claude_title,
                  message: context.localizations.home_dialog_claude_body,
                  actionLabel:
                      context.localizations.home_dialog_claude_view_guide,
                  onAction: () => onClaudePressed?.call(),
                ),
              );
            },
            icon: const Icon(FontAwesomeIcons.cloud, size: 16),
            label: Text(context.localizations.home_button_claude),
            style: OutlinedButton.styleFrom(
              foregroundColor: context.theme.customColors.info,
              side: BorderSide(
                color: context.theme.customColors.info!,
                width: 1.5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _StopButton(),
        ],
      );

  void _showChatDialog(BuildContext context, _ActionDialogSpec spec) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: spec.title,
        content: spec.message,
        contentWidget: _buildKeepOpenNotice(context),
        cancelButtonText: context.localizations.error_button_ok,
        actionButtonText: spec.actionLabel,
        onActionPressed: () {
          Navigator.of(dialogContext).pop();
          Future.microtask(spec.onAction);
        },
      ),
    );
  }

  Widget _buildKeepOpenNotice(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.customColors.warning!.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.customColors.warning!.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: theme.customColors.warning,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localizations.home_note_keep_open,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.customColors.textColor!.getShade(400),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  context.localizations.home_helper_keep_open_reason,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.customColors.textColor!.getShade(300),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

typedef _ActionDialogSpec = ({
  String title,
  String message,
  String actionLabel,
  VoidCallback onAction,
});

class _StartButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _StartButton({
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: const Icon(FontAwesomeIcons.play, size: 16),
          label: Text(context.localizations.home_button_start_server),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor:
                context.theme.colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
      );
}

class _StopButton extends StatelessWidget {
  const _StopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => context.read<HomeCubit>().stopMCPServer(),
          icon: const Icon(FontAwesomeIcons.stop, size: 16),
          label: Text(context.localizations.home_button_stop_server),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.theme.customColors.danger,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor:
                context.theme.customColors.danger!.withValues(alpha: 0.3),
          ),
        ),
      );
}

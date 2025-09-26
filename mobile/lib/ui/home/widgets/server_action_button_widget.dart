import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/gen/assets.gen.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:flutter_template/ui/home/widgets/keep_app_open_notice.dart';
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showStartChatDialog(context),
              icon: const Icon(FontAwesomeIcons.commentDots, size: 16),
              label: Text(context.localizations.home_button_start_chat),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor:
                    context.theme.colorScheme.primary.withValues(alpha: 0.3),
                textStyle: context.theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _StopButton(),
        ],
      );

  void _showStartChatDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: context.localizations.home_dialog_start_chat_title,
        content: context.localizations.home_dialog_start_chat_body,
        contentWidget: _StartChatDialogContent(
          onChatGptPressed: onChatGptPressed,
          onClaudePressed: onClaudePressed,
          onInstructionTap: _handleInstructionTap,
        ),
        showCloseIcon: true,
        onClosePressed: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }

  void _handleInstructionTap(
    BuildContext dialogContext,
    VoidCallback? action,
  ) {
    Navigator.of(dialogContext).pop();
    if (action == null) return;
    Future.microtask(action);
  }
}

class _StartChatDialogContent extends StatelessWidget {
  final VoidCallback? onChatGptPressed;
  final VoidCallback? onClaudePressed;
  final void Function(BuildContext context, VoidCallback? action)
      onInstructionTap;

  const _StartChatDialogContent({
    required this.onChatGptPressed,
    required this.onClaudePressed,
    required this.onInstructionTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = _dialogButtonTextStyle(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const KeepAppOpenNotice(),
        const SizedBox(height: 20),
        _ChatGptInstructionButton(
          onPressed: onChatGptPressed != null
              ? () => onInstructionTap(context, onChatGptPressed)
              : null,
          textStyle: textStyle,
        ),
        const SizedBox(height: 14),
        _ClaudeInstructionButton(
          onPressed: onClaudePressed != null
              ? () => onInstructionTap(context, onClaudePressed)
              : null,
          textStyle: textStyle,
        ),
      ],
    );
  }

  TextStyle? _dialogButtonTextStyle(BuildContext context) =>
      context.theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 14,
      );
}

class _ChatGptInstructionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final TextStyle? textStyle;

  const _ChatGptInstructionButton({
    required this.onPressed,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Assets.icons.chatgpt.svg(
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
          label: Text(
            context.localizations.home_dialog_chatgpt_view_guide,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.theme.colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            shadowColor:
                context.theme.colorScheme.primary.withValues(alpha: 0.3),
            textStyle: textStyle,
          ),
        ),
      );
}

class _ClaudeInstructionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final TextStyle? textStyle;

  const _ClaudeInstructionButton({
    required this.onPressed,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Assets.icons.claude.svg(
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              context.theme.customColors.info!,
              BlendMode.srcIn,
            ),
          ),
          label: Text(
            context.localizations.home_dialog_claude_view_guide,
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.theme.customColors.info,
            side: BorderSide(
              color: context.theme.customColors.info!,
              width: 1.5,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: textStyle,
          ),
        ),
      );
}

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
            textStyle: context.theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
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
        child: OutlinedButton.icon(
          onPressed: () => context.read<HomeCubit>().stopMCPServer(),
          icon: const Icon(FontAwesomeIcons.stop, size: 16),
          label: Text(context.localizations.home_button_stop_server),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.theme.customColors.danger,
            side: BorderSide(
              color: context.theme.customColors.danger!,
              width: 1.5,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: context.theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      );
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_template/gen/assets.gen.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:flutter_template/ui/home/widgets/keep_app_open_notice.dart';
import 'package:flutter_template/ui/widgets/bold_tag_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServerActionButtonWidget extends StatelessWidget {
  final String? errorMessage;
  final McpServerStatus status;
  final AsyncCallback? onStartPressed;
  final VoidCallback? onChatGptQuickAction;
  final VoidCallback? onChatGptDesktopPressed;

  const ServerActionButtonWidget({
    required this.errorMessage,
    required this.status,
    this.onStartPressed,
    this.onChatGptQuickAction,
    this.onChatGptDesktopPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Widget stateView;
    switch (status) {
      case McpServerStatus.idle:
        stateView = _StartButton(
          key: const ValueKey('start'),
          onPressed: onStartPressed,
        );
        break;
      case McpServerStatus.starting:
        stateView = _LoadingButton(
          key: const ValueKey('starting'),
          label: context.localizations.home_button_starting,
        );
        break;
      case McpServerStatus.running:
        stateView = _RunningButtons(
          key: const ValueKey('running'),
          onChatGptQuickAction: onChatGptQuickAction,
          onChatGptDesktopPressed: onChatGptDesktopPressed,
        );
        break;
      case McpServerStatus.stopping:
        stateView = _LoadingButton(
          key: const ValueKey('stopping'),
          label: context.localizations.home_button_stopping,
        );
        break;
      case McpServerStatus.error:
        stateView = _ErrorButton(
          key: const ValueKey('error'),
          errorMessage: errorMessage ?? '',
        );
        break;
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: stateView,
    );
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
          AppButton.filled(
            label: context.localizations.connection_error_retry,
            icon: const Icon(
              Icons.refresh_rounded,
              size: AppButtonDefaults.iconSize,
            ),
            tone: AppButtonTone.danger,
            onPressed: () => context.read<HomeCubit>().startMCPServer(),
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
        child: AppButton.filled(
          label: label,
          tone: AppButtonTone.warning,
          onPressed: null,
          isLoading: true,
        ),
      );
}

class _RunningButtons extends StatelessWidget {
  final VoidCallback? onChatGptQuickAction;
  final VoidCallback? onChatGptDesktopPressed;

  const _RunningButtons({
    required this.onChatGptQuickAction,
    required this.onChatGptDesktopPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton.filled(
            label: context.localizations.home_button_start_chat,
            icon: const Icon(
              FontAwesomeIcons.commentDots,
              size: AppButtonDefaults.iconSize,
            ),
            onPressed: () => _showStartChatDialog(context),
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
          onChatGptQuickAction: onChatGptQuickAction,
          onChatGptDesktopPressed: onChatGptDesktopPressed,
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
  final VoidCallback? onChatGptQuickAction;
  final VoidCallback? onChatGptDesktopPressed;
  final void Function(BuildContext context, VoidCallback? action)
      onInstructionTap;

  const _StartChatDialogContent({
    required this.onChatGptQuickAction,
    required this.onChatGptDesktopPressed,
    required this.onInstructionTap,
  });

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const KeepAppOpenNotice(),
          const SizedBox(height: 12),
          Text(
            context.localizations.home_dialog_chatgpt_intro,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.theme.colorScheme.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          _DialogBullet(
            text: context.localizations.home_dialog_chatgpt_mobile_bullet,
          ),
          const SizedBox(height: 4),
          _DialogBullet(
            text: context.localizations.home_dialog_chatgpt_desktop_bullet,
          ),
          const SizedBox(height: 16),
          _ChatGptMobileButton(
            onPressed: () => onInstructionTap(context, onChatGptQuickAction),
          ),
          const SizedBox(height: 10),
          _ChatGptDesktopButton(
            onPressed: () => onInstructionTap(context, onChatGptDesktopPressed),
          ),
        ],
      );
}

class _ChatGptMobileButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _ChatGptMobileButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => AppButton.filled(
        label: context.localizations.home_dialog_chatgpt_mobile_title,
        icon: Assets.icons.chatgpt.svg(
          width: AppButtonDefaults.iconSize,
          height: AppButtonDefaults.iconSize,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        onPressed: onPressed,
      );
}

class _ChatGptDesktopButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _ChatGptDesktopButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => AppButton.outlined(
        label: context.localizations.home_dialog_chatgpt_desktop_title,
        icon:
            const Icon(Icons.desktop_windows, size: AppButtonDefaults.iconSize),
        onPressed: onPressed,
      );
}

class _DialogBullet extends StatelessWidget {
  final String text;

  const _DialogBullet({
    required this.text,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(
              Icons.circle,
              size: 6,
              color: context.theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: BoldTagText(
              text: text,
              baseStyle: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
      );
}

class _StartButton extends StatelessWidget {
  final AsyncCallback? onPressed;

  const _StartButton({
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AppButton.filled(
        label: context.localizations.home_button_start_server,
        icon: const Icon(
          FontAwesomeIcons.play,
          size: AppButtonDefaults.iconSize,
        ),
        onPressed: onPressed,
      );
}

class _StopButton extends StatelessWidget {
  const _StopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) => AppButton.outlined(
        label: context.localizations.home_button_stop_server,
        icon: const Icon(
          FontAwesomeIcons.stop,
          size: AppButtonDefaults.iconSize,
        ),
        tone: AppButtonTone.danger,
        onPressed: () => context.read<HomeCubit>().stopMCPServer(),
      );
}

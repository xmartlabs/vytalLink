import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter_template/gen/assets.gen.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:flutter_template/ui/home/widgets/keep_app_open_notice.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServerActionButtonWidget extends StatelessWidget {
  final String errorMessage;
  final McpServerStatus status;
  final VoidCallback? onStartPressed;
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
          errorMessage: errorMessage,
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
          const SizedBox(height: 16),
          Text(
            context.localizations.home_dialog_chatgpt_intro,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.theme.colorScheme.onSurface,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 12),
          _DialogBullet(
            text: context.localizations.home_dialog_chatgpt_mobile_bullet,
          ),
          const SizedBox(height: 6),
          _DialogBullet(
            text: context.localizations.home_dialog_chatgpt_desktop_bullet,
          ),
          const SizedBox(height: 20),
          _ChatGptMobileButton(
            onPressed: () =>
                onInstructionTap(context, onChatGptQuickAction),
          ),
          const SizedBox(height: 14),
          _ChatGptDesktopButton(
            onPressed: () =>
                onInstructionTap(context, onChatGptDesktopPressed),
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
            context.localizations.home_dialog_chatgpt_mobile_title,
          ),
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
      );
}

class _ChatGptDesktopButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _ChatGptDesktopButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: const Icon(Icons.desktop_windows, size: 18),
          label: Text(
            context.localizations.home_dialog_chatgpt_desktop_title,
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: context.theme.colorScheme.primary,
            side: BorderSide(
              color: context.theme.colorScheme.primary.withValues(alpha: 0.6),
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
            child: Text(
              text,
              style: context.theme.textTheme.bodySmall?.copyWith(
                color: context.theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
        ],
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

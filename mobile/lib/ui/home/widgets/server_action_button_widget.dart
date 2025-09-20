import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ServerActionButtonWidget extends StatelessWidget {
  final String errorMessage;
  final McpServerStatus status;
  final VoidCallback? onStartPressed;

  const ServerActionButtonWidget({
    required this.errorMessage,
    required this.status,
    this.onStartPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case McpServerStatus.idle:
        return _StartButton(onPressed: onStartPressed);
      case McpServerStatus.starting:
        return _LoadingButton(
          label: context.localizations.home_button_starting,
        );
      case McpServerStatus.reconnecting:
        return _LoadingButton(
          label: context.localizations.home_button_starting,
        );
      case McpServerStatus.running:
        return const _StopButton();
      case McpServerStatus.stopping:
        return _LoadingButton(
          label: context.localizations.home_button_stopping,
        );
      case McpServerStatus.error:
        return _ErrorButton(errorMessage: errorMessage);
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
                color: context.theme.customColors.danger!
                    .withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.theme.customColors.danger!
                      .withAlpha((0.3 * 255).toInt()),
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
                shadowColor: context.theme.customColors.danger!
                    .withAlpha((0.3 * 255).toInt()),
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
            shadowColor: context.theme.customColors.danger!
                .withAlpha((0.3 * 255).toInt()),
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
            shadowColor: context.theme.colorScheme.primary
                .withAlpha((0.3 * 255).toInt()),
          ),
        ),
      );
}

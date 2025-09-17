import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/home/widgets/credentials_card_widget.dart';

class AnimatedCredentialCard extends StatelessWidget {
  final String connectionWord;
  final String connectionCode;

  const AnimatedCredentialCard({
    required this.connectionWord,
    required this.connectionCode,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnimatedSize(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: connectionCode.isNotEmpty && connectionWord.isNotEmpty
            ? Column(
                children: [
                  _AnimatedCredentialsCard(
                    connectionWord: connectionWord,
                    connectionPin: connectionCode,
                  ),
                  const SizedBox(height: 24),
                ],
              )
            : const SizedBox.shrink(),
      );
}

class _AnimatedCredentialsCard extends StatelessWidget {
  final String connectionWord;
  final String connectionPin;

  const _AnimatedCredentialsCard({
    required this.connectionWord,
    required this.connectionPin,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutBack,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: VytalLinkCard(
                padding: const EdgeInsets.all(24),
                backgroundColor: context.theme.colorScheme.primary
                    .withAlpha((0.08 * 255).toInt()),
                border: Border.all(
                  color: context.theme.colorScheme.primary
                      .withAlpha((0.3 * 255).toInt()),
                  width: 2,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: context.theme.colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .connection_section_title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: context.theme.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.info_outline,
                            size: 20,
                            color: context.theme.colorScheme.primary
                                .withAlpha((0.7 * 255).toInt()),
                          ),
                          onPressed: () => _showCredentialsInfo(context),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CredentialsCardWidget(
                      connectionWord: connectionWord,
                      connectionPin: connectionPin,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  void _showCredentialsInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.localizations.connection_credentials_info_title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        content: Text(
          context.localizations.connection_credentials_info_message,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.error_button_ok),
          ),
        ],
      ),
    );
  }
}

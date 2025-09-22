import 'package:design_system/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:design_system/design_system.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SetupStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final String? codeSnippet;
  final Widget? actionButton;

  const SetupStep({
    required this.number,
    required this.title,
    required this.description,
    this.codeSnippet,
    this.actionButton,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: context.theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: context.theme.customColors.textColor!.getShade(100),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
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
                  title,
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (codeSnippet != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: context.theme.colorScheme.primary,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            codeSnippet!,
                            style: context.theme.textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                              color: context.theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              _copyToClipboard(context, codeSnippet!),
                          icon: const Icon(
                            FontAwesomeIcons.copy,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (actionButton != null) ...[
                  const SizedBox(height: 12),
                  actionButton!,
                ],
              ],
            ),
          ),
        ],
      );

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.localizations.copied_to_clipboard),
        duration: const Duration(seconds: 2),
        backgroundColor: context.theme.colorScheme.primary,
      ),
    );
  }
}

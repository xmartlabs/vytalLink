import 'package:design_system/design_system.dart';
import 'package:design_system/extensions/color_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/l10n/app_localizations.dart';

class HealthPermissionsDialog extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  const HealthPermissionsDialog({
    required this.onAccept,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.health_permissions_dialog_title,
          style: context.theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.health_permissions_dialog_message,
          style: context.theme.textTheme.bodyMedium,
        ),
        actionsAlignment: MainAxisAlignment.spaceAround,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onCancel,
                  child: Text(
                    AppLocalizations.of(context)!
                        .health_permissions_dialog_cancel,
                    style: context.theme.customTextStyles.buttonMedium.copyWith(
                      color:
                          context.theme.customColors.textColor!.getShade(300),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FilledButton(
                  onPressed: onAccept,
                  child: Text(
                    AppLocalizations.of(context)!
                        .health_permissions_dialog_accept,
                    style: context.theme.customTextStyles.buttonMedium.copyWith(
                      color:
                          context.theme.customColors.textColor!.getShade(100),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  static Future<bool?> show(BuildContext context) => showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => HealthPermissionsDialog(
          onAccept: () => Navigator.of(context).pop(true),
          onCancel: () => Navigator.of(context).pop(false),
        ),
      );
}

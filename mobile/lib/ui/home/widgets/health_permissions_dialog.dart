import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';

class HealthPermissionsDialog extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  const HealthPermissionsDialog({
    required this.onAccept,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) => AppDialog(
        title: context.localizations.health_permissions_dialog_title,
        content: context.localizations.health_permissions_dialog_message,
        cancelButtonText:
            context.localizations.health_permissions_dialog_cancel,
        actionButtonText:
            context.localizations.health_permissions_dialog_accept,
        onCancelPressed: onCancel,
        onActionPressed: onAccept,
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

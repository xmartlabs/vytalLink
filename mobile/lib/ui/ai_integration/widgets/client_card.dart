import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:design_system/design_system.dart';

class ClientCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String description;
  final Color color;
  final VoidCallback? onTap;
  final bool showLinkIcon;
  final Widget? leadingIcon;

  const ClientCard({
    required this.icon,
    required this.name,
    required this.description,
    required this.color,
    this.onTap,
    this.showLinkIcon = true,
    this.leadingIcon,
    super.key,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: _buildLeadingIcon()),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      description,
                      style: context.theme.textTheme.bodySmall?.copyWith(
                        color: context.theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (showLinkIcon)
                Icon(
                  FontAwesomeIcons.arrowUpRightFromSquare,
                  size: 16,
                  color: color,
                ),
            ],
          ),
        ),
      );

  Widget _buildLeadingIcon() {
    if (leadingIcon != null) return leadingIcon!;

    final isCodeIcon =
        icon == FontAwesomeIcons.code || icon == FontAwesomeIcons.laptopCode;
    final base = Icon(icon, color: color, size: 22);
    return isCodeIcon
        ? Transform.translate(offset: const Offset(-2, 0), child: base)
        : base;
  }
}

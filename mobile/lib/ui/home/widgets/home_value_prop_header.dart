import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/common/config.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/widgets/bold_tag_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeValuePropHeader extends StatelessWidget {
  final VoidCallback? onDismiss;

  const HomeValuePropHeader({this.onDismiss, super.key});

  @override
  Widget build(BuildContext context) {
    const card = _ValuePropContainer(
      child: _ValuePropContent(),
    );
    if (onDismiss == null) {
      return card;
    }

    return Stack(
      children: [
        card,
        Positioned.fill(
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              splashRadius: 18,
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              onPressed: onDismiss,
            ),
          ),
        ),
      ],
    );
  }
}

class _ValuePropContainer extends StatelessWidget {
  final Widget child;

  const _ValuePropContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.08),
            colorScheme.secondary.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ValuePropContent extends StatelessWidget {
  const _ValuePropContent();

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ValuePropHeaderSection(),
          SizedBox(height: 20),
          _ValuePropPoints(),
        ],
      );
}

class _ValuePropHeaderSection extends StatelessWidget {
  const _ValuePropHeaderSection();

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final localizations = context.localizations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.home_value_prop_title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          localizations.home_value_prop_subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ValuePropPoints extends StatelessWidget {
  const _ValuePropPoints();

  @override
  Widget build(BuildContext context) {
    final localizations = context.localizations;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ValuePropLine(
          icon: FontAwesomeIcons.desktop,
          text: localizations.home_value_prop_point_1,
        ),
        const SizedBox(height: 12),
        _ValuePropLine(
          icon: FontAwesomeIcons.key,
          text: localizations.home_value_prop_point_2,
        ),
        if (Config.requireForegroundSession) ...[
          const SizedBox(height: 12),
          _ValuePropLine(
            icon: FontAwesomeIcons.clock,
            text: localizations.home_value_prop_point_3,
          ),
        ],
      ],
    );
  }
}

class _ValuePropLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ValuePropLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.15),
                colorScheme.secondary.withValues(alpha: 0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: BoldTagText(
            text: text,
            baseStyle: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

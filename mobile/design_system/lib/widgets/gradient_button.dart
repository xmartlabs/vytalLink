import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientButton extends StatefulWidget {
  const GradientButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.gradient,
    this.borderRadius = 25.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.elevation = 4.0,
    this.shadowColor,
    this.enabled = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Gradient? gradient;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final Color? shadowColor;
  final bool enabled;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation * 1.5,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enabled && widget.onPressed != null) {
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.enabled && widget.onPressed != null) {
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.enabled && widget.onPressed != null) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadowColor = widget.shadowColor ??
        Color.alphaBlend(theme.colorScheme.primary.withAlpha(76), Colors.white);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.enabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                gradient: widget.enabled
                    ? (widget.gradient ??
                        LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ))
                    : null,
                color: widget.enabled ? null : theme.disabledColor,
                borderRadius: BorderRadius.circular(widget.borderRadius.r),
                boxShadow: widget.enabled
                    ? [
                        BoxShadow(
                          color: shadowColor,
                          offset: const Offset(0, 4),
                          blurRadius: _elevationAnimation.value * 2,
                          spreadRadius: 0,
                        ),
                      ]
                    : null,
              ),
              child: DefaultTextStyle(
                style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ) ??
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                child: widget.child,
              ),
            ),
          ),
      ),
    );
  }
}

class VytalLinkButton extends StatelessWidget {
  const VytalLinkButton({
    required this.onPressed,
    required this.child,
    super.key,
    this.borderRadius = 25.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.enabled = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GradientButton(
      onPressed: onPressed,
      borderRadius: borderRadius,
      padding: padding,
      enabled: enabled,
      gradient: LinearGradient(
        colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shadowColor: Color.alphaBlend(
        theme.colorScheme.primary.withAlpha(76),
        Colors.white,
      ),
      child: child,
    );
  }
}

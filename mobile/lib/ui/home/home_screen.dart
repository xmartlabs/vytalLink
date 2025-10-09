import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_template/core/model/mcp_connection_state.dart';
import 'package:flutter_template/core/service/once_service.dart';
import 'package:flutter_template/ui/extensions/context_extensions.dart';
import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:flutter_template/ui/home/widgets/ai_integration_card.dart';
import 'package:flutter_template/ui/home/widgets/animated_server_card.dart';
import 'package:flutter_template/ui/home/widgets/home_value_prop_header.dart';
import 'package:flutter_template/ui/home/widgets/how_it_works_section.dart';
import 'package:flutter_template/ui/router/app_router.dart';
import 'package:flutter_template/ui/section/error_handler/global_event_handler_cubit.dart';
import 'package:flutter_template/ui/widgets/home_overflow_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => HomeCubit(context.read<GlobalEventHandlerCubit>()),
        child: const _HomeContentScreen(),
      );
}

class _HomeContentScreen extends StatefulWidget {
  const _HomeContentScreen();

  @override
  State<_HomeContentScreen> createState() => _HomeContentScreenState();
}

class _HomeContentScreenState extends State<_HomeContentScreen>
    with TickerProviderStateMixin {
  static const _showHealthPermissionsAlertKey = 'showHealthPermissionsAlert';

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _serverCardKey = GlobalKey();
  final GlobalKey _aiGuideCardKey = GlobalKey();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _showValuePropHeader = true;

  Future<bool?> _showHealthConnectRequiredAlert() => showDialog<bool>(
        context: context,
        builder: (dialogContext) => AppDialog(
          title: context.localizations.health_connect_required_alert_title,
          content: context.localizations.health_connect_required_alert_message,
          cancelButtonText:
              context.localizations.health_connect_required_alert_cancel,
          actionButtonText:
              context.localizations.health_connect_required_alert_install,
          onCancelPressed: () => dialogContext.router.maybePop(false),
          onActionPressed: () => dialogContext.router.maybePop(true),
        ),
      );

  Future<bool?> _showHealthPermissionsAlert() => showDialog<bool>(
        context: context,
        builder: (dialogContext) => AppDialog(
          title: context.localizations.health_permissions_alert_title,
          content: context.localizations.health_permissions_alert_message,
          cancelButtonText:
              context.localizations.health_permissions_alert_cancel,
          actionButtonText:
              context.localizations.health_permissions_alert_accept,
          onCancelPressed: () => dialogContext.router.maybePop(false),
          onActionPressed: () => dialogContext.router.maybePop(true),
        ),
      );

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            previous.bridgeCredentials != current.bridgeCredentials,
        listener: (context, state) {
          if (state.bridgeCredentials != null) {
            _scrollToServerCard();
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    context.localizations.home_toast_credentials_ready,
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: context.theme.customColors.success,
                ),
              );
          }
        },
        builder: (context, state) => Scaffold(
          backgroundColor: context.theme.colorScheme.surface,
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  FontAwesomeIcons.heartPulse,
                  color: context.theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  context.localizations.app_name,
                  style: TextStyle(
                    color: context.theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            backgroundColor: context.theme.colorScheme.surface,
            elevation: 2,
            shadowColor:
                context.theme.colorScheme.primary.withValues(alpha: 0.1),
            actions: const [
              HomeOverflowMenu(),
              SizedBox(width: 2),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        sizeFactor: animation,
                        axisAlignment: -1,
                        child: child,
                      ),
                    ),
                    child: _showValuePropHeader
                        ? HomeValuePropHeader(
                            key: const ValueKey('home-hero'),
                            onDismiss: _dismissValuePropHeader,
                          )
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(height: _showValuePropHeader ? 16 : 4),
                  AnimatedServerCard(
                    key: _serverCardKey,
                    status: state.status,
                    errorMessage: state.errorMessage,
                    pulseAnimation: _pulseAnimation,
                    onChatGptDesktop: _scrollToAiGuideCard,
                    bridgeCredentials: state.bridgeCredentials,
                    connectCallback: startServer,
                  ),
                  const SizedBox(height: 16),
                  HowItWorksSection(
                    onViewGuide: () =>
                        context.navigateTo(const ChatGptIntegrationRoute()),
                  ),
                  const SizedBox(height: 16),
                  KeyedSubtree(
                    key: _aiGuideCardKey,
                    child: AiIntegrationCard(
                      status: state.status,
                      bridgeCredentials: state.bridgeCredentials,
                      connectCallback: startServer,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      );

  Future<BridgeCredentials?> startServer() async {
    final cubit = context.read<HomeCubit>();
    final currentState = cubit.state;
    final existingCredentials = currentState.bridgeCredentials;
    if (existingCredentials != null) return existingCredentials;

    if (await cubit.isHealthConnectInstallationRequired()) {
      final shouldInstall = await _showHealthConnectRequiredAlert();
      if (shouldInstall ?? false) {
        await cubit.installHealthConnect();
      }
      return null;
    }

    final hasPermissions = await cubit.hasAllHealthPermissions();
    if (!hasPermissions &&
        !await OnceService.beenDone(_showHealthPermissionsAlertKey)) {
      final accepted = await _showHealthPermissionsAlert();
      if (accepted != true) return null;
    }

    final started = await cubit.checkAndStartServer();
    if (started) {
      await OnceService.markDone(_showHealthPermissionsAlertKey);
    }
    return cubit.state.bridgeCredentials;
  }

  void _dismissValuePropHeader() {
    setState(() {
      _showValuePropHeader = false;
    });
  }

  void _scrollToServerCard() {
    if (!_showValuePropHeader) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _serverCardKey.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0,
      );
    });
  }

  void _scrollToAiGuideCard() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _aiGuideCardKey.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0,
      );
    });
  }
}

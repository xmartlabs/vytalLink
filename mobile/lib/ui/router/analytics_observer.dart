import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/common/analytics_manager.dart';

class AnalyticsObserver extends AutoRouterObserver {
  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    AnalyticsManager.logScreenView(route.name).ignore();
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    AnalyticsManager.logScreenView(route.name).ignore();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name == null) return;
    AnalyticsManager.logScreenView(route.settings.name ?? 'unknown').ignore();
  }
}

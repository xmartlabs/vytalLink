// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    AuthenticatedSectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const AuthenticatedSectionRouter(),
      );
    },
    ChatGptIntegrationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ChatGptIntegrationScreen(),
      );
    },
    HomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HomeScreen(),
      );
    },
    McpIntegrationRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const McpIntegrationScreen(),
      );
    },
    OnboardingRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const OnboardingScreen(),
      );
    },
    UnauthenticatedSectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UnauthenticatedSectionRouter(),
      );
    },
  };
}

/// generated route for
/// [AuthenticatedSectionRouter]
class AuthenticatedSectionRoute extends PageRouteInfo<void> {
  const AuthenticatedSectionRoute({List<PageRouteInfo>? children})
      : super(
          AuthenticatedSectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'AuthenticatedSectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ChatGptIntegrationScreen]
class ChatGptIntegrationRoute extends PageRouteInfo<void> {
  const ChatGptIntegrationRoute({List<PageRouteInfo>? children})
      : super(
          ChatGptIntegrationRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatGptIntegrationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [McpIntegrationScreen]
class McpIntegrationRoute extends PageRouteInfo<void> {
  const McpIntegrationRoute({List<PageRouteInfo>? children})
      : super(
          McpIntegrationRoute.name,
          initialChildren: children,
        );

  static const String name = 'McpIntegrationRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
      : super(
          OnboardingRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [UnauthenticatedSectionRouter]
class UnauthenticatedSectionRoute extends PageRouteInfo<void> {
  const UnauthenticatedSectionRoute({List<PageRouteInfo>? children})
      : super(
          UnauthenticatedSectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'UnauthenticatedSectionRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

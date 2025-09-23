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
    FaqRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const FaqScreen(),
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
    SectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SectionRouter(),
      );
    },
    UnauthenticatedSectionRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const UnauthenticatedSectionRouter(),
      );
    },
    WebRouteRoute.name: (routeData) {
      final args = routeData.argsAs<WebRouteRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WebPageScreen(
          url: args.url,
          key: args.key,
          title: args.title,
        ),
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
/// [FaqScreen]
class FaqRoute extends PageRouteInfo<void> {
  const FaqRoute({List<PageRouteInfo>? children})
      : super(
          FaqRoute.name,
          initialChildren: children,
        );

  static const String name = 'FaqRoute';

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
/// [SectionRouter]
class SectionRoute extends PageRouteInfo<void> {
  const SectionRoute({List<PageRouteInfo>? children})
      : super(
          SectionRoute.name,
          initialChildren: children,
        );

  static const String name = 'SectionRoute';

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

/// generated route for
/// [WebPageScreen]
class WebRouteRoute extends PageRouteInfo<WebRouteRouteArgs> {
  WebRouteRoute({
    required String url,
    Key? key,
    String? title,
    List<PageRouteInfo>? children,
  }) : super(
          WebRouteRoute.name,
          args: WebRouteRouteArgs(
            url: url,
            key: key,
            title: title,
          ),
          initialChildren: children,
        );

  static const String name = 'WebRouteRoute';

  static const PageInfo<WebRouteRouteArgs> page =
      PageInfo<WebRouteRouteArgs>(name);
}

class WebRouteRouteArgs {
  const WebRouteRouteArgs({
    required this.url,
    this.key,
    this.title,
  });

  final String url;

  final Key? key;

  final String? title;

  @override
  String toString() {
    return 'WebRouteRouteArgs{url: $url, key: $key, title: $title}';
  }
}

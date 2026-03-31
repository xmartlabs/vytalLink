import 'package:design_system/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_template/l10n/app_localizations.dart';
import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:flutter_template/ui/home/widgets/ai_integration_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'shows installed-plugin and fallback sections together',
    (tester) async {
      await tester.pumpWidget(
        const _TestApp(
          child: AiIntegrationCard(
            status: McpServerStatus.idle,
            bridgeCredentials: null,
          ),
        ),
      );

      expect(
        find.byKey(const Key('ai-installed-plugin-section')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('ai-word-pin-fallback-section')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('ai-installed-plugin-primary-action')),
        findsOneWidget,
      );
      expect(find.byKey(const Key('ai-desktop-guide-action')), findsOneWidget);
    },
  );
}

class _TestApp extends StatelessWidget {
  final Widget child;

  const _TestApp({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Theme(
              data: AppTheme.provideAppTheme(context),
              child: Scaffold(
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      );
}

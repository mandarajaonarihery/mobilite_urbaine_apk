import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:all_pnud/providers/auth_provider.dart';
import 'package:all_pnud/providers/theme_provider.dart';
import 'package:all_pnud/providers/locale_provider.dart';
import 'package:all_pnud/router/app_router.dart';
import 'package:all_pnud/theme/theme.dart';
import 'package:all_pnud/l10n/app_localizations.dart';
import 'package:all_pnud/screens/onboarding_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyAppStarter());
}

class MyAppStarter extends StatelessWidget {
  const MyAppStarter({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider(const Locale('en'))),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final GoRouter router = AppRouter.getRouter(context);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'Portail PNUD',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.themeMode,
      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      themeAnimationDuration: Duration.zero,
      themeAnimationCurve: Curves.linear,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) {
        // Affiche le splash / onboarding avant le router principal
        return  SplashOrOnboardingWrapper(child: child);
      },
    );
  }
}

// --------------------
// Widget qui gère l’onboarding
// --------------------
class SplashOrOnboardingWrapper extends StatefulWidget {
  final Widget? child;
  const SplashOrOnboardingWrapper({this.child, super.key});

  @override
  State<SplashOrOnboardingWrapper> createState() => _SplashOrOnboardingWrapperState();
}

class _SplashOrOnboardingWrapperState extends State<SplashOrOnboardingWrapper> {
  bool _showOnboarding = true;

  void _finishOnboarding() {
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return AGVMOnboardingScreen(onFinished: _finishOnboarding);
    }
    return widget.child!;
  }
}

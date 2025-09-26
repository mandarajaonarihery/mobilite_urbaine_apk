import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:all_pnud/providers/theme_provider1.dart';

class ScaffoldWithShell extends StatelessWidget {
  final Widget child;

  const ScaffoldWithShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('menu'.tr()),
        actions: [
          // Toggle theme
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              // bascule le thème
              bool isDark = themeProvider.themeMode != ThemeMode.dark;
              themeProvider.toggleTheme(isDark);
            },
          ),

          // Changement de langue
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) async {
              // Change la locale via EasyLocalization
              final newLocale = Locale(value);
              await context.setLocale(newLocale);

              // Optionnel : mettre à jour le ThemeProvider si tu veux un rebuild global
              themeProvider.changeLocale(context, newLocale);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'fr', child: Text('Français')),
              PopupMenuItem(value: 'en', child: Text('English')),
              PopupMenuItem(value: 'mg', child: Text('Malagasy')),
            ],
          ),
        ],
      ),
      body: child,
    );
  }
}

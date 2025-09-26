import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:all_pnud/providers/theme_provider.dart';
import 'package:all_pnud/providers/locale_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Paramètres")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- Switch Thème ---
            ListTile(
              title: const Text("Mode sombre"),
              trailing: Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ),

            const Divider(height: 32),

            // --- Switch Langue ---
            ListTile(
              title: const Text("Langue"),
              subtitle: Text(
                localeProvider.locale.languageCode == 'fr'
                    ? 'Français'
                    : 'Malagasy / Anglais',
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  localeProvider.toggleLocale();
                },
                child: const Text("Changer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

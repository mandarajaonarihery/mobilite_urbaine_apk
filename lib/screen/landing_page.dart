import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:all_pnud/providers/theme_provider.dart';
import 'package:all_pnud/providers/locale_provider.dart';
import 'package:all_pnud/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // Couleurs de la charte graphique
  static const Color primaryColor = Color(0xFF098E00);
  static const Color titleColor = Color(0xFF131313);
  static const Color paragraphColor = Color(0xFF505050);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    // Adapte les couleurs pour le mode sombre
    final currentTitleColor = isDarkMode ? Colors.white : titleColor;
    final currentParagraphColor = isDarkMode ? Colors.grey[400] : paragraphColor;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  localizations.landingTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: currentTitleColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildMainActionCard(context),
              const SizedBox(height: 40),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  localizations.featuresTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: currentTitleColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.directions_bus_filled,
                      title: localizations.feature1Title,
                      description: localizations.feature1Desc,
                      imagePath: 'assets/images/ARRET.jpg',
                    ),
                    const SizedBox(height: 20),
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.location_city,
                      title: localizations.feature2Title,
                      description: localizations.feature2Desc,
                      imagePath: 'assets/images/Antananarivo.jpg',
                    ),
                     const SizedBox(height: 20),
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.payments,
                      title: localizations.feature3Title,
                      description: localizations.feature3Desc,
                      imagePath: 'assets/images/agent.jpg',
                    ),
                    const SizedBox(height: 20),
                    // --- CARTE AJOUTÉE ICI ---
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.pin_drop_outlined,
                      title: localizations.feature4Title, // Nouvelle clé de traduction
                      description: localizations.feature4Desc, // Nouvelle clé de traduction
                      imagePath: 'assets/images/carte.jpg', // Nouvelle image à ajouter
                    ),
                  ],
                ),
              ),
               const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainActionCard(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final currentParagraphColor = isDarkMode ? Colors.grey[400] : paragraphColor;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(Icons.business, color: primaryColor, size: 40),
            const SizedBox(height: 16),
            Text(
              localizations.landingWelcome,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: currentParagraphColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // --- BOUTON MODIFIÉ ICI ---
            ElevatedButton(
              onPressed: () => context.go('/map'), // Redirige vers la carte
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                localizations.seeMap, // Nouvelle clé de traduction
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
             const SizedBox(height: 12),
             // --- BOUTON MODIFIÉ ICI ---
             TextButton(
               onPressed: () => context.go('/login'), // Redirige vers le login
               child: Text(
                localizations.landingLogin,
                style: const TextStyle(fontSize: 16, color: primaryColor, fontWeight: FontWeight.bold),
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/app_logo.png', height: 45, errorBuilder: (context, error, stackTrace) => const Icon(Icons.apps, size: 35)),
              const SizedBox(width: 15),
              Image.asset('assets/images/pnud.png', height: 45, errorBuilder: (context, error, stackTrace) => const Icon(Icons.public, size: 35)),
            ],
          ),
          Row(
            children: [
              PopupMenuButton<Locale>(
                icon: const Icon(Icons.language),
                onSelected: (Locale locale) => localeProvider.setLocale(locale),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: Locale('fr'), child: Text('Français')),
                  const PopupMenuItem(value: Locale('mg'), child: Text('Malagasy')),
                ],
              ),
              IconButton(
                icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: themeProvider.themeMode == ThemeMode.dark ? 'Mode clair' : 'Mode sombre',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required String imagePath,
  }) {
     final theme = Theme.of(context);
     final bool isDarkMode = theme.brightness == Brightness.dark;
     final currentTitleColor = isDarkMode ? Colors.white : titleColor;
     final currentParagraphColor = isDarkMode ? Colors.grey[400] : paragraphColor;

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            imagePath,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey, size: 50)),
                );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 30, color: primaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: currentTitleColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(color: currentParagraphColor, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


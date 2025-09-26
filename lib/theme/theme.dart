import 'package:flutter/material.dart';

// --------------------
// Couleurs principales
// --------------------
class AppColors {
  // Light Mode
  static const Color lightBackground = Color(0xFFF8F8F8);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightPrimaryText = Color(0xFF131313);
  static const Color lightSecondaryText = Color(0xFF5D5D5D);
  static const Color lightParagraph = Color(0xFF098E00);
  static const Color lightTertiary = Color(0xFFE98C21);
  static const Color lightSuccess = Color(0xFF00C21C);
  static const Color lightError = Color(0xFFFF1313);
  static const Color lightInfo = Color(0xFF6653E5);
  static const Color lightWarning = Color(0xFFE8B018);
  static const Color lightLink = Color(0xFF1D70B8);
  static const Color lightLinkHover = Color(0xFF003078);
  static const Color lightLinkVisited = Color(0xFF4C2C92);
  static const Color lightButtonNormal = Color(0xFF098E00);
  static const Color lightButtonHover = Color(0xFF008713);
  static const Color lightButtonDisabled = Color(0xFF003078);
  static const Color lightIcon = Color(0xFF00C21C);

  // Dark Mode
  static const Color darkBackground = Color(0xFF1A2530);
  static const Color darkCard = Color(0xFF2C3E50);
  static const Color darkPrimaryText = Color(0xFFF8F9FA);
  static const Color darkSecondaryText = Color(0xFFAAB0B8);
  static const Color darkParagraph = Color(0xFF00C21C);
  static const Color darkTertiary = Color(0xFFE98C21);
  static const Color darkSuccess = Color(0xFF29FF48);
  static const Color darkError = Color(0xFFFF1313);
  static const Color darkInfo = Color(0xFF6653E5);
  static const Color darkWarning = Color(0xFFE8B018);
  static const Color darkLink = Color(0xFF1D70B8);
  static const Color darkLinkHover = Color(0xFF003078);
  static const Color darkLinkVisited = Color(0xFF4C2C92);
  static const Color darkButtonNormal = Color(0xFF098E00);
  static const Color darkButtonHover = Color(0xFF008713);
  static const Color darkButtonDisabled = Color(0xFF003078);
  static const Color darkIcon = Color(0xFF00C21C);
}

// --------------------
// Typographie
// --------------------
class AppTextStyles {
  static const String fontFamily = 'Manrope';

  // Titres
  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w800, // ExtraBold
    fontSize: 32,
    color: AppColors.lightPrimaryText,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w800,
    fontSize: 24,
    color: AppColors.lightSecondaryText,
  );

  // Paragraphes
  static const TextStyle paragraph = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.lightParagraph,
  );

  static const TextStyle link = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.lightLink,
    decoration: TextDecoration.underline,
  );
}

// --------------------
// Styles de boutons
// --------------------
class AppButtonStyles {
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: AppColors.lightButtonNormal,
    foregroundColor: Colors.white,
    textStyle: const TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static ButtonStyle success = ElevatedButton.styleFrom(
    backgroundColor: AppColors.lightSuccess,
    foregroundColor: Colors.white,
  );

  static ButtonStyle error = ElevatedButton.styleFrom(
    backgroundColor: AppColors.lightError,
    foregroundColor: Colors.white,
  );
}

// --------------------
// Thème principal unifié
// --------------------
class AppThemes {
  // Palette de couleurs inspirée de Madagascar
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color accentGreen = Color(0xFF66BB6A);
  static const Color softGreen = Color(0xFFE8F5E8);
  static const Color goldAccent = Color(0xFFFFD700); // Or pour rappeler les couleurs malgaches
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color greyMedium = Color(0xFF757575);
  
  // Gradients thématiques Madagascar
  static const LinearGradient madagascarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2E7D32),
      Color(0xFF4CAF50),
      Color(0xFF66BB6A),
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  static const LinearGradient mobilityGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1B5E20),
      Color(0xFF2E7D32),
      Color(0xFF4CAF50),
    ],
  );

  static const LinearGradient landingGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8F5E8), Colors.white],
  );

  // Styles de texte pour onboarding
  static const TextStyle onboardingTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.2,
    height: 1.3,
    shadows: [
      Shadow(
        offset: Offset(0, 2),
        blurRadius: 8,
        color: Color(0x40000000),
      ),
    ],
  );
  
  static const TextStyle onboardingSubtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Color(0xFFE8F5E8),
    letterSpacing: 0.5,
    height: 1.5,
  );

  // Styles pour landing page
  static const TextStyle landingTitle = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1B5E20),
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle landingSubtitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Color(0xFF424242),
    letterSpacing: 0.3,
    height: 1.5,
  );

  static const TextStyle landingFeatureTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFF1B5E20),
    letterSpacing: 0.2,
  );

  static const TextStyle landingFeatureDesc = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Color(0xFF616161),
    height: 1.4,
  );

  // Thème Light (une seule déclaration)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.green,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: Colors.white,
      cardColor: AppColors.lightCard,
      
      // Configuration des textes
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        bodyLarge: AppTextStyles.paragraph,
      ),
      
      // Configuration AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1B5E20)),
        titleTextStyle: TextStyle(
          color: Color(0xFF1B5E20),
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Configuration des boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryGreen.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      
      // Configuration des cartes - Correction du type
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: AppColors.lightCard,
      ),
      
      // Configuration des icônes
      iconTheme: const IconThemeData(color: AppColors.lightIcon),
    );
  }

  // Thème Dark (une seule déclaration)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: lightGreen,
      scaffoldBackgroundColor: const Color(0xFF0D1F0F),
      cardColor: AppColors.darkCard,
      
      // Configuration des textes pour le mode sombre
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 32,
          color: AppColors.darkPrimaryText,
        ),
        displayMedium: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontWeight: FontWeight.w800,
          fontSize: 24,
          color: AppColors.darkSecondaryText,
        ),
        bodyLarge: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: AppColors.darkParagraph,
        ),
      ),
      
      // Configuration AppBar pour le mode sombre
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D1F0F),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      // Configuration des boutons pour le mode sombre
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightGreen,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: lightGreen.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      
      // Configuration des cartes pour le mode sombre
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: AppColors.darkCard,
      ),
      
      // Configuration des icônes pour le mode sombre
      iconTheme: const IconThemeData(color: AppColors.darkIcon),
    );
  }
}

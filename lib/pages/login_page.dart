import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:all_pnud/providers/auth_provider.dart';
import 'package:all_pnud/providers/theme_provider.dart';
import 'package:all_pnud/providers/locale_provider.dart';
import 'package:all_pnud/l10n/app_localizations.dart';

class ModernLoginScreen extends StatefulWidget {
  const ModernLoginScreen({Key? key}) : super(key: key);

  @override
  _ModernLoginScreenState createState() => _ModernLoginScreenState();
}

class _ModernLoginScreenState extends State<ModernLoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (success && mounted) {
        context.goNamed('mobilite_urbaine');
      } else if (mounted) {
        _showSnackBar(
          AppLocalizations.of(context)!.loginFailed,
          Colors.red,
        );
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('${AppLocalizations.of(context)!.error}: $e', Colors.red);
      }
    } finally {
      if(mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == const Color(0xFF00C21C) ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = const Color(0xFF00C21C);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            _buildMinimalBackground(isDarkMode, primaryColor),
            _buildHeader(context), // MODIFIÉ ICI pour utiliser le nouveau header
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildLoginContent(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MODIFIÉ ICI : Ce widget remplace _buildTopHeader par la version que vous avez suggérée
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
              // CHEMIN CORRIGÉ ICI
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
  
   Widget _buildMinimalBackground(bool isDarkMode, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode
              ? [const Color(0xFF030712), const Color(0xFF0A0F1C)]
              : [Colors.white, const Color(0xFFFAFDFA)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  primaryColor.withOpacity(isDarkMode ? 0.1 : 0.05),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -150, left: -150,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  primaryColor.withOpacity(isDarkMode ? 0.08 : 0.03),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContent(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLoginHeader(context),
            const SizedBox(height: 40),
            _buildEmailField(context),
            const SizedBox(height: 24),
            _buildPasswordField(context),
            const SizedBox(height: 32),
            _buildLoginButton(context),
            const SizedBox(height: 32),
            _buildDemoInfo(context),
          ],
        ),
      ),
    );
  }

   Widget _buildLoginHeader(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = const Color(0xFF00C21C);
    final textColor = isDarkMode ? const Color(0xFFEBEBEB) : const Color(0xFF131313);

    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [primaryColor, primaryColor.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: const Icon(Icons.directions_transit_filled, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 32),
        Text(
          localizations.loginWelcome,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: textColor, letterSpacing: -1),
        ),
        const SizedBox(height: 8),
        Text(
          localizations.loginSubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: textColor.withOpacity(0.6), fontWeight: FontWeight.w400, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = const Color(0xFF00C21C);
    final textColor = isDarkMode ? const Color(0xFFEBEBEB) : const Color(0xFF131313);
    final inputBgColor = isDarkMode ? const Color(0xFF131313) : const Color(0xFFF8F9FA);

    return TextFormField(
      controller: _emailController,
      style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: localizations.emailLabel,
        labelStyle: TextStyle(color: textColor.withOpacity(0.6), fontWeight: FontWeight.w500),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(16),
          child: Icon(Icons.alternate_email_rounded, color: primaryColor, size: 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        filled: true,
        fillColor: inputBgColor,
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) => (value == null || value.isEmpty) ? localizations.emailValidation : null,
    );
  }

   Widget _buildPasswordField(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = const Color(0xFF00C21C);
    final textColor = isDarkMode ? const Color(0xFFEBEBEB) : const Color(0xFF131313);
    final inputBgColor = isDarkMode ? const Color(0xFF131313) : const Color(0xFFF8F9FA);

    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: localizations.passwordLabel,
        labelStyle: TextStyle(color: textColor.withOpacity(0.6), fontWeight: FontWeight.w500),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(16),
          child: Icon(Icons.lock_outline_rounded, color: primaryColor, size: 20),
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: textColor.withOpacity(0.5), size: 20),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
        filled: true,
        fillColor: inputBgColor,
      ),
      validator: (value) => (value == null || value.isEmpty) ? localizations.passwordValidation : null,
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    final primaryColor = const Color(0xFF00C21C);
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
        child: _isLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
            : Text(localizations.loginButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }

  Widget _buildDemoInfo(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final primaryColor = const Color(0xFF00C21C);
    final textColor = isDarkMode ? const Color(0xFFEBEBEB) : const Color(0xFF131313);
    final subtleAccent = primaryColor.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: subtleAccent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: primaryColor, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              localizations.demoInfo,
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}


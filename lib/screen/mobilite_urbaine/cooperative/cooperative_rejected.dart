import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class CooperativeRejectedScreen extends StatefulWidget {
  const CooperativeRejectedScreen({Key? key}) : super(key: key);

  @override
  State<CooperativeRejectedScreen> createState() => _CooperativeRejectedScreenState();
}

class _CooperativeRejectedScreenState extends State<CooperativeRejectedScreen>
    with TickerProviderStateMixin {
  bool _isDarkMode = false;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // Fade pour l'entrée
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    // Pulse pour l'icône
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Slide pour les cartes
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // Palette de couleurs
  Color get _backgroundColor => _isDarkMode ? const Color(0xFF030712) : Colors.white;
  Color get _primaryColor => const Color(0xFF00C21C);
  Color get _textColor => _isDarkMode ? const Color(0xFFEBEBEB) : const Color(0xFF131313);
  Color get _cardColor => _isDarkMode ? const Color(0xFF131313) : const Color(0xFFEBEBEB);
  Color get _rejectedColor => const Color(0xFFE53E3E); // Rouge plus doux
  Color get _warningColor => const Color(0xFFED8936); // Orange pour l'espoir

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          // Background avec effet de profondeur
          _buildBackground(),
          
          // Header moderne
          _buildModernHeader(),
          
          // Toggle theme
          _buildThemeToggle(),
          
          // Contenu principal
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _buildMainContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _isDarkMode
              ? [
                  const Color(0xFF030712),
                  const Color(0xFF0A0F1C),
                ]
              : [
                  Colors.white,
                  const Color(0xFFFAF5F5), // Teinte très légère de rouge
                ],
        ),
      ),
      child: Stack(
        children: [
          // Cercles décoratifs
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _rejectedColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _warningColor.withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_rejectedColor, _rejectedColor.withOpacity(0.8)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: _rejectedColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              // Bouton retour moderne
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              
              // Titre et sous-titre
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Demande Rejetée',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ne vous découragez pas !',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Icône d'information
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Positioned(
      top: 140,
      right: 24,
      child: GestureDetector(
        onTap: _toggleTheme,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isDarkMode ? _cardColor.withOpacity(0.8) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _rejectedColor.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isDarkMode ? Colors.black26 : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            _isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            color: _textColor.withOpacity(0.7),
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          
          // Icône principale animée
          _buildAnimatedIcon(),
          
          const SizedBox(height: 32),
          
          // Message principal
          SlideTransition(
            position: _slideAnimation,
            child: _buildMainMessageCard(),
          ),
          
          const SizedBox(height: 24),
          
          // Carte des prochaines étapes
          SlideTransition(
            position: _slideAnimation,
            child: _buildNextStepsCard(),
          ),
          
          const SizedBox(height: 24),
          
          // Carte de support
          SlideTransition(
            position: _slideAnimation,
            child: _buildSupportCard(),
          ),
          
          const SizedBox(height: 32),
          
          // Boutons d'action
          SlideTransition(
            position: _slideAnimation,
            child: _buildActionButtons(),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  _rejectedColor.withOpacity(0.2),
                  _rejectedColor.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
              border: Border.all(
                color: _rejectedColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.refresh_rounded,
              size: 60,
              color: _rejectedColor,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainMessageCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: _isDarkMode ? _cardColor.withOpacity(0.9) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _rejectedColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode ? Colors.black26 : Colors.black.withOpacity(0.08),
            blurRadius: 30,
            spreadRadius: 0,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          // Badge de statut
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _rejectedColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _rejectedColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _rejectedColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'DEMANDE REJETÉE',
                  style: TextStyle(
                    color: _rejectedColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Message principal
          Text(
            'Votre demande n\'a pas été approuvée',
            style: TextStyle(
              color: _textColor,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Message d'encouragement
          Text(
            'Ce n\'est qu\'un début ! Chaque refus vous rapproche de la réussite. Analysez les retours et revenez plus fort.',
            style: TextStyle(
              color: _textColor.withOpacity(0.7),
              fontSize: 16,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepsCard() {
    final steps = [
      {
        'icon': Icons.search_outlined,
        'title': 'Analysez les raisons',
        'desc': 'Identifiez les points à améliorer',
      },
      {
        'icon': Icons.edit_outlined,
        'title': 'Corrigez votre dossier',
        'desc': 'Mettez à jour les informations manquantes',
      },
      {
        'icon': Icons.send_outlined,
        'title': 'Resoumettez',
        'desc': 'Tentez à nouveau votre chance',
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _isDarkMode ? _cardColor.withOpacity(0.9) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _warningColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode ? Colors.black12 : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: _warningColor,
                size: 24,
              ),
              const SizedBox(width: 10),
              Flexible(
               child: Text(
                'Prochaines étapes recommandées',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              )
              
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Liste des étapes
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;
            
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _warningColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        step['icon'] as IconData,
                        size: 18,
                        color: _warningColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['title'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step['desc'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              color: _textColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _warningColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _warningColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (!isLast)
                  Container(
                    margin: const EdgeInsets.only(left: 18, top: 12, bottom: 12),
                    width: 2,
                    height: 20,
                    color: _warningColor.withOpacity(0.2),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSupportCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _isDarkMode ? _cardColor.withOpacity(0.9) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _primaryColor.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: _isDarkMode ? Colors.black12 : Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.support_agent_outlined,
                color: _primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Besoin d\'aide ?',
                style: TextStyle(
                  color: _textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Notre équipe est là pour vous accompagner dans cette démarche. N\'hésitez pas à nous contacter pour obtenir des conseils personnalisés.',
            style: TextStyle(
              color: _textColor.withOpacity(0.7),
              fontSize: 15,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                color: _primaryColor,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'support@mobilite.com',
                style: TextStyle(
                  color: _primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Bouton principal - Nouvelle demande
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
            onTap: () {
  // Navigation vers le formulaire d'inscription
  context.goNamed('cooperative_register');
},
              child: const Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Soumettre une nouvelle demande',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Bouton secondaire - Contacter le support
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
                onTap: () => context.go('cooperative_register'),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat_outlined,
                      color: _primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Contacter le support',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
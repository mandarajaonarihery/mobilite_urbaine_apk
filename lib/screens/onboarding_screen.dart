import 'package:flutter/material.dart';
import 'dart:math' as math;

class AGVMOnboardingScreen extends StatefulWidget {
  final VoidCallback onFinished;
  const AGVMOnboardingScreen({required this.onFinished, super.key});

  @override
  State<AGVMOnboardingScreen> createState() => _AGVMOnboardingScreenState();
}

class _AGVMOnboardingScreenState extends State<AGVMOnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  
  // Contrôleurs d'animation simplifiés
  late AnimationController _mainController;
  late AnimationController _backgroundController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _backgroundAnimation;

  final List<OnboardingStep> _steps = [
    OnboardingStep(
      title: "Connecté à\ I-zotra",
      subtitle: "Découvrez une mobilité intelligente qui transforme vos déplacements quotidiens dans la capitale",
       imagePath: 'assets/images/app_logo.png',
      primaryColor: const Color(0xFF098E00),
      accentColor: const Color(0xFF00C21C),
      features: [
       "🏙️ Cartographie intelligente",
        "📍 Navigation précise", 
        "⚡ Connexion temps réel"
      ],
    ),
    OnboardingStep(
      title: "Transport\nInnovant",
      subtitle: "Une technologie de pointe au service de votre mobilité quotidienne avec des solutions durables",
      icon: Icons.directions_transit_filled_rounded,
      primaryColor: const Color(0xFF00C21C),
      accentColor: const Color(0xFF098E00),
      features: [
       "🚌 Réseau optimisé",
        "💡 IA prédictive",
        "🔄 Synchronisation parfaite"
      ],
    ),
    OnboardingStep(
      title: "Communauté\nDurable",
      subtitle: "Rejoignez une communauté engagée pour un transport écologique et un avenir plus vert à Madagascar",
      icon: Icons.eco_rounded,
      primaryColor: const Color(0xFF098E00),
      accentColor: const Color(0xFFE98C21),
      features: [
        "🌱 Impact positif",
        "🤝 Engagement collectif",
        "🌍 Futur durable"
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    ));

    _backgroundAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_backgroundController);
  }

  void _startAnimations() {
    _mainController.forward();
    _backgroundController.repeat();
  }

  void _resetAnimations() {
    _mainController.reset();
    _mainController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _backgroundController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentStep = _steps[_currentIndex];
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              currentStep.primaryColor.withOpacity(0.1),
              const Color(0xFFF8F8F8),
              currentStep.accentColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildBackground(size, currentStep),
            _buildContent(),
            _buildTopButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(Size size, OnboardingStep step) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return CustomPaint(
          size: size,
          painter: BackgroundPatternPainter(
            _backgroundAnimation.value,
            step.primaryColor,
            step.accentColor,
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          _resetAnimations();
        },
        itemCount: _steps.length,
        itemBuilder: (context, index) {
          return _buildStepPage(_steps[index]);
        },
      ),
    );
  }

  Widget _buildStepPage(OnboardingStep step) {
  // Enveloppez la colonne avec SingleChildScrollView pour éviter le débordement
  return Padding(
    padding: const EdgeInsets.all(24.0),
    child: SingleChildScrollView( // <--- AJOUTÉ ICI
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          
          // Icône principale
          _buildMainIcon(step),
          
          const SizedBox(height: 40),
          
          // Titre
          _buildTitle(step.title),
          
          const SizedBox(height: 20),
          
          // Sous-titre
          _buildSubtitle(step.subtitle),
          
          const SizedBox(height: 40),
          
          // Features
          _buildFeatures(step.features),
          
          const SizedBox(height: 40), // Remplacer Spacer par un SizedBox pour mieux fonctionner avec SingleChildScrollView
          
          // Contrôles
          _buildControls(),
          
          const SizedBox(height: 30),
        ],
      ),
    ),
  );
}
Widget _buildMainIcon(OnboardingStep step) {
  return AnimatedBuilder(
    animation: _scaleAnimation,
    builder: (context, child) {
      return Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                step.accentColor.withOpacity(0.2),
                step.primaryColor.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: step.primaryColor.withOpacity(0.3),
              width: 2,
            ),
          ),
          // 👇 C'est cette logique qu'il faut ajouter 👇
          child: step.imagePath != null
              // Si un chemin d'image est fourni, on affiche l'Image
              ? Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Image.asset(step.imagePath!),
                )
              // Sinon, on affiche l'Icone
              : Icon(
                  step.icon,
                  size: 60,
                  color: step.primaryColor,
                ),
        ),
      );
    },
  );
}
  Widget _buildTitle(String title) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFF131313),
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        subtitle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Color(0xFF5D5D5D),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildFeatures(List<String> features) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: features.map((feature) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _steps[_currentIndex].accentColor.withOpacity(0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _steps[_currentIndex].primaryColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              feature,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF131313),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTopButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      right: 24,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: TextButton(
          onPressed: widget.onFinished,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF5D5D5D),
            backgroundColor: Colors.white.withOpacity(0.9),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Passer',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Indicateurs
            Row(
              children: List.generate(_steps.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 8),
                  width: _currentIndex == index ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? _steps[_currentIndex].primaryColor
                        : _steps[_currentIndex].primaryColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            
            // Bouton suivant
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _steps[_currentIndex].primaryColor,
                      _steps[_currentIndex].accentColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _steps[_currentIndex].primaryColor.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _nextPage,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentIndex == _steps.length - 1
                                ? 'Commencer'
                                : 'Suivant',
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _currentIndex == _steps.length - 1
                                ? Icons.check_circle_rounded
                                : Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Classes de données simplifiées
class OnboardingStep {
  final String title;
  final String subtitle;
  final IconData? icon; 
  final String? imagePath;
  final Color primaryColor;
  final Color accentColor;
  final List<String> features;
OnboardingStep({
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.accentColor,
    required this.features,
    this.icon,
    this.imagePath,
  }) : assert(icon != null || imagePath != null, 
              'Vous devez fournir soit un "icon", soit un "imagePath"');
}

// Custom Painter simplifié
class BackgroundPatternPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color accentColor;

  BackgroundPatternPainter(this.progress, this.primaryColor, this.accentColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Cercles flottants simples
    for (int i = 0; i < 6; i++) {
      final offset = progress + (i * 0.5);
      final x = size.width * 0.8 + math.sin(offset) * 30;
      final y = size.height * 0.2 + i * 80 + math.cos(offset * 0.7) * 20;
      
      paint.color = primaryColor.withOpacity(0.1);
      canvas.drawCircle(
        Offset(x, y),
        20 - (i * 2),
        paint,
      );
    }

    // Points de connexion
    for (int i = 0; i < 12; i++) {
      final x = (i * 40.0) % size.width;
      final y = size.height * 0.7 + math.sin(progress * 2 + i * 0.5) * 15;
      
      paint.color = accentColor.withOpacity(0.15);
      canvas.drawCircle(Offset(x, y), 3, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
// lib/screen/mobilite_urbaine/mobilite_urbaine_screen.dart

import 'package:all_pnud/services/chauffeur_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:all_pnud/providers/auth_provider.dart';
import 'package:all_pnud/services/cooperative_service.dart';
import 'package:all_pnud/services/vehicule_service.dart';

class MobiliteUrbaineScreen extends StatefulWidget {
  const MobiliteUrbaineScreen({Key? key}) : super(key: key);

  @override
  State<MobiliteUrbaineScreen> createState() => _MobiliteUrbaineScreenState();
}

class _MobiliteUrbaineScreenState extends State<MobiliteUrbaineScreen>
    with TickerProviderStateMixin {
void _navigateToCooperativeSection() async {
    // Dialogue de loading moderne
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blue.withOpacity(0.7)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Chargement de votre espace...",
                style: TextStyle(
                  color: darkText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final citizenId = authProvider.decodedToken?['id_citizen'];
      final token = authProvider.token;

      if (citizenId != null && token != null) {
       final cooperative = await _cooperativeService.getCooperativeByCitizenId(citizenId);
        
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          
          if (cooperative != null) {
            if (cooperative.status == 'VALIDE') {
              context.goNamed('cooperative',extra: {'cooperativeId': cooperative.id});
            } else if (cooperative.status == 'EN_ATTENTE') {
              context.goNamed('cooperative_pending',extra: cooperative.toJson(),); // ou la Map<String,dynamic> correspondante);

            } else {
              context.goNamed('cooperative_rejected');
            }
          } else {
            context.goNamed('cooperative_register');
          }
        }
      } else {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          context.goNamed('dashboard');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        context.goNamed('dashboard');
      }
    }
  }

  void _navigateToProprietaireSection() async {
    // Dialogue de loading moderne
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [greenAccent, greenAccent.withOpacity(0.7)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Chargement de votre espace...",
                style: TextStyle(
                  color: darkText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final citizenId = authProvider.decodedToken?['id_citizen'];
      final token = authProvider.token;

      if (citizenId != null && token != null) {
        final vehicules = await _vehiculeService.getVehiculesByCitizenId(citizenId, token);
        print('citizenId: $citizenId, token: $token, vehicules: $vehicules');


        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          if (vehicules.isNotEmpty) {
            context.goNamed('proprietaire_dashboard');
          } else {
            context.goNamed('proprietaire_register_vehicule');
          }
        }
      } else {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
          context.goNamed('dashboard');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        context.goNamed('dashboard');
      }
    }
  }


void _navigateToChauffeurSection() async {
  // Boîte de chargement
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Vérification de votre profil..."),
          ],
        ),
      ),
    ),
  );

  try {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final citizenId = authProvider.decodedToken?['id_citizen'];
    final token = authProvider.token;

    if (citizenId != null && token != null) {
      final chauffeurService = ChauffeurService();
      final chauffeur = await chauffeurService.getChauffeurByCitizenIdEnriched(citizenId);

      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();

        if (chauffeur != null) {
          // ✅ Chauffeur existe → dashboard
          context.goNamed('chauffeur_dashboard', extra: {'chauffeur': chauffeur});
        } else {
          // 🚀 Chauffeur n’existe pas → enregistrement
          context.goNamed('chauffeur_register');
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        context.goNamed('dashboard');
      }
    }
  } catch (e) {
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      context.goNamed('dashboard');
    }
  }
}


      
  final CooperativeService _cooperativeService = CooperativeService();
  final VehiculeService _vehiculeService = VehiculeService();

  // Animations
  late AnimationController _headerAnimationController;
  late AnimationController _cardAnimationController;
  late AnimationController _floatingAnimationController;
  late AnimationController _particleAnimationController;
  
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _particleAnimation;

  // Palette de couleurs - Thème clair
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color darkText = Color(0xFF131313);
  static const Color greenAccent = Color(0xFF00C21C);
  static const Color lightGray = Color(0xFFEBEBEB);
  static const Color cardBackground = Colors.white;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _floatingAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _particleAnimationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _headerFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.elasticOut,
    ));

    _cardScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.elasticOut,
    ));

    _floatingAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(
      parent: _floatingAnimationController,
      curve: Curves.easeInOut,
    ));

    _particleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_particleAnimationController);
  }

  void _startAnimations() {
    _headerAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _cardAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _cardAnimationController.dispose();
    _floatingAnimationController.dispose();
    _particleAnimationController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        // Gradient de base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFF0F8FF),
                Color(0xFFE8F5E8),
                lightBackground,
              ],
            ),
          ),
        ),
        
        // Particules flottantes
        AnimatedBuilder(
          animation: _particleAnimationController,
          builder: (context, child) {
            return Stack(
              children: List.generate(15, (index) {
                final progress = (_particleAnimation.value + index * 0.1) % 1.0;
                final size = MediaQuery.of(context).size;
                
                return Positioned(
                  left: (index * 80.0 + progress * 100) % size.width,
                  top: 50 + (index * 40.0 + progress * 200) % (size.height - 200),
                  child: Opacity(
                    opacity: (0.3 - (index * 0.02)).clamp(0.1, 0.3),
                    child: Container(
                      width: 3 + (index % 4),
                      height: 3 + (index % 4),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            greenAccent.withOpacity(0.6),
                            greenAccent.withOpacity(0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSpectacularHeader() {
    return SlideTransition(
      position: _headerSlideAnimation,
      child: FadeTransition(
        opacity: _headerFadeAnimation,
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              // Badge du projet avec glow
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      greenAccent.withOpacity(0.2),
                      greenAccent.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: greenAccent.withOpacity(0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: greenAccent.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: greenAccent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: greenAccent.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "PROJET MOBILITÉ URBAINE",
                      style: TextStyle(
                        color: greenAccent.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Icône principale avec effet holographique
              AnimatedBuilder(
                animation: _floatingAnimationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatingAnimation.value),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            greenAccent.withOpacity(0.4),
                            greenAccent.withOpacity(0.2),
                            greenAccent.withOpacity(0.05),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4, 0.7, 1.0],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: greenAccent.withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.location_city,
                        size: 50,
                        color: greenAccent,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 24),
              
              // Titre principal avec effet néon
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    darkText,
                    greenAccent.withOpacity(0.8),
                    greenAccent,
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ).createShader(bounds),
                child: const Text(
                  "MOBILITÉ\nURBAINE",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    height: 1.1,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Text(
                "Plateforme digitale pour une mobilité urbaine intelligente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: darkText.withOpacity(0.7),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFuturisticCard({
    required String title,
    required String description,
    required IconData icon,
    required List<String> features,
    required VoidCallback onTap,
    required String imageUrl,
    required Color accentColor,
    int delayIndex = 0,
  }) {
    return AnimatedBuilder(
      animation: _cardAnimationController,
      builder: (context, child) {
        final slideAnimation = Tween<Offset>(
          begin: Offset(0, 0.5 + (delayIndex * 0.1)),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _cardAnimationController,
          curve: Interval(
  (delayIndex * 0.2).clamp(0.0, 1.0),
  (0.8 + (delayIndex * 0.2)).clamp(0.0, 1.0),
  curve: Curves.elasticOut,
),
        ));

        return SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(
            scale: _cardScaleAnimation,
            child: Container(
              margin: EdgeInsets.only(
                bottom: 24,
                left: 16,
                right: 16,
                top: delayIndex == 0 ? 8 : 0,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          cardBackground,
                          cardBackground.withOpacity(0.95),
                          lightBackground,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: accentColor.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 12),
                        ),
                        BoxShadow(
                          color: accentColor.withOpacity(0.1),
                          blurRadius: 25,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header avec image
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                              child: Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      accentColor.withOpacity(0.8),
                                      accentColor.withOpacity(0.6),
                                    ],
                                  ),
                                ),
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            accentColor.withOpacity(0.3),
                                            accentColor.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                      child: Icon(
                                        icon,
                                        size: 50,
                                        color: accentColor,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            
                            // Overlay avec icône
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  icon,
                                  color: accentColor,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        // Contenu
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Titre avec badge
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: darkText,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: accentColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "ACTIF",
                                      style: TextStyle(
                                        color: accentColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Description
                              Text(
                                description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: darkText.withOpacity(0.7),
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              
                              const SizedBox(height: 16),
                              
                              // Features
                              ...features.map((feature) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [accentColor, accentColor.withOpacity(0.7)],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: darkText.withOpacity(0.8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )).toList(),
                              
                              const SizedBox(height: 20),
                              
                              // Bouton d'action
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [accentColor, accentColor.withOpacity(0.8)],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: accentColor.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: ElevatedButton(
                                        onPressed: onTap,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              "Accéder",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            AnimatedBuilder(
                                              animation: _floatingAnimationController,
                                              builder: (context, child) {
                                                return Transform.translate(
                                                  offset: Offset(_floatingAnimation.value * 0.1, 0),
                                                  child: const Icon(
                                                    Icons.arrow_forward_rounded,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: darkText),
         onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
    '/', 
    (route) => false,
  ), // redirige vers la racine
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: darkText),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildSpectacularHeader(),
                  
                  // Cards des espaces
                  _buildFuturisticCard(
                    title: "Espace Coopérative",
                    description: "Gérez votre coopérative de transport, suivez les véhicules affiliés et optimisez vos opérations.",
                    icon: Icons.business,
                    features: [
                      "Gestion des véhicules affiliés",
                      "Tableau de bord analytique",
                      "Suivi des revenus",
                      "Gestion des chauffeurs",
                    ],
                    imageUrl: "https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=400&h=120&fit=crop",
                    accentColor: Colors.blue,
                    onTap: _navigateToCooperativeSection,
                    delayIndex: 0,
                  ),
                  
                  _buildFuturisticCard(
                    title: "Espace Propriétaire",
                    description: "Enregistrez vos véhicules, gérez vos licences et suivez le statut de vos demandes.",
                    icon: Icons.person,
                    features: [
                      "Enregistrement de véhicules",
                      "Demandes de licences",
                      "Suivi des documents",
                      "Historique des transactions",
                    ],
                    imageUrl: "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400&h=120&fit=crop",
                    accentColor: greenAccent,
                    onTap: _navigateToProprietaireSection,
                    delayIndex: 1,
                  ),
                  
                                _buildFuturisticCard(
                  title: "Espace Chauffeur",
                  description: "Accédez à vos courses, suivez vos revenus et gérez vos disponibilités.",
                  icon: Icons.drive_eta,
                  features: [
                    "Gestion des courses",
                    "Suivi des revenus",
                    "Historique des trajets",
                    "Gestion des disponibilités",
                  ],
                  imageUrl: "https://images.unsplash.com/photo-1517142089942-ba376ce32a2e?w=400&h=120&fit=crop",
                  accentColor: Colors.redAccent,
                  onTap: _navigateToChauffeurSection,
                  delayIndex: 2,
                ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  
}
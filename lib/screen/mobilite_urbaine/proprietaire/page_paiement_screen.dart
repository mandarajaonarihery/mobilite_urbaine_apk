import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:all_pnud/models/vehicule.dart';
import 'package:all_pnud/services/affectation_service.dart';
import 'package:all_pnud/services/licence_service.dart';
import 'package:all_pnud/providers/auth_provider.dart';

// Couleurs de la charte graphique AGVM
class AppColors {
  static const Color primary = Color(0xFF098E00);
  static const Color secondary = Color(0xFF00C21C);
  static const Color darkText = Color(0xFF131313);
  static const Color mediumText = Color(0xFF5D5D5D);
  static const Color tertiary = Color(0xFFE98C21);
  static const Color error = Color(0xFFDF3434);
  static const Color purple = Color(0xFF442EDF);
  static const Color background = Color(0xFFF8F8F8);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF00C21C);
  static const Color errorAction = Color(0xFFFF1313);
  static const Color info = Color(0xFF6653E5);
  static const Color warning = Color(0xFFE8B018);
  static const Color linkColor = Color(0xFF1d70b8);
  static const Color linkHover = Color(0xFF003078);
  static const Color buttonHover = Color(0xFF008713);
  static const Color buttonDisabled = Color(0xFF003078);
}

class PagePaiementScreen extends StatefulWidget {
  final String motif;
  final String typePaiement; // "licence", "amende", "adhesion"
  final Vehicule? vehicule;
  final void Function(String operateur)? onPaymentSuccess;

  const PagePaiementScreen({
    Key? key,
    required this.motif,
    required this.typePaiement,
    this.vehicule,
    this.onPaymentSuccess,
  }) : super(key: key);

  @override
  State<PagePaiementScreen> createState() => _PagePaiementScreenState();
}

class _PagePaiementScreenState extends State<PagePaiementScreen> with TickerProviderStateMixin {
  String? _selectedOperator;
  final AffectationService _affectationService = AffectationService();
  bool _isPaying = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int get montant {
    switch (widget.typePaiement) {
      case 'licence':
        return 100000;
      case 'amende':
        return 30000;
      case 'adhesion':
        return widget.vehicule?.affectation?.cooperative?.droitAdhesion ?? 0;
      default:
        return 0;
    }
  }

  String get montantFormate {
    return montant.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }

  IconData get typeIcon {
    switch (widget.typePaiement) {
      case 'licence':
        return Icons.card_membership;
      case 'amende':
        return Icons.warning;
      case 'adhesion':
        return Icons.group_add;
      default:
        return Icons.payment;
    }
  }

  Color get typeColor {
    switch (widget.typePaiement) {
      case 'licence':
        return AppColors.primary;
      case 'amende':
        return AppColors.warning;
      case 'adhesion':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  Future<void> _processPayment() async {
    if (_selectedOperator == null) return;

    setState(() => _isPaying = true);

    bool success = false;

    try {
      switch (widget.typePaiement) {
        case 'adhesion':
          final affectationId = widget.vehicule?.affectation?.id;
          if (affectationId != null) {
            success = await _affectationService.payerAffectation(affectationId);
          }
          break;

        case 'licence':
          final vehicule = widget.vehicule;
          if (vehicule != null && vehicule.immatriculation != null) {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            final token = authProvider.token ?? '';
            final municipalityId =
                int.tryParse(authProvider.decodedToken?['municipality_id'] ?? '0') ?? 0;

            if (municipalityId > 0 && token.isNotEmpty) {
              success = await LicenceService().finalizeLicence(
                immatriculation: vehicule.immatriculation!,
                municipalityId: municipalityId,
                token: token,
              );
            } else {
              throw Exception('Token ou municipalityId invalide');
            }
          }
          break;

        case 'amende':
          success = true; // Simulation
          break;

        default:
          throw Exception('Type de paiement inconnu');
      }

      if (success) {
        if (widget.onPaymentSuccess != null) {
          widget.onPaymentSuccess!(_selectedOperator!);
        }
        _showSuccessDialog();
      } else {
        _showErrorSnackBar('Échec du paiement');
      }
    } catch (e) {
      _showErrorSnackBar('Erreur: ${e.toString()}');
    } finally {
      setState(() => _isPaying = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Paiement réussi !',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Votre paiement de $montantFormate Ar via $_selectedOperator a été effectué avec succès',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.mediumText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.errorAction,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildOperatorCard({
    required String name,
    required String value,
    required String logo,
    required Color primaryColor,
    required Color accentColor,
  }) {
    final isSelected = _selectedOperator == value;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _selectedOperator = value),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected 
                  ? primaryColor.withOpacity(0.1)
                  : AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      logo,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Paiement mobile sécurisé',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.mediumText,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? primaryColor : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? primaryColor : AppColors.mediumText,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        title: const Text(
          'Paiement',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.darkText,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec informations du paiement
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          typeIcon,
                          color: typeColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.motif,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$montantFormate Ar',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: typeColor,
                          ),
                        ),
                      ),
                      if (widget.vehicule?.immatriculation != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.mediumText.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.directions_car, 
                                color: AppColors.mediumText, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                widget.vehicule!.immatriculation!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mediumText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Section choix opérateur
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.info.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.phone_android,
                              color: AppColors.info,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Choisissez votre opérateur',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sélectionnez votre moyen de paiement mobile préféré',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.mediumText,
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildOperatorCard(
                        name: 'Telma Money',
                        value: 'Telma',
                        logo: 'T',
                        primaryColor: const Color(0xFF0066CC),
                        accentColor: const Color(0xFF004499),
                      ),

                      _buildOperatorCard(
                        name: 'Orange Money',
                        value: 'Orange',
                        logo: 'O',
                        primaryColor: const Color(0xFFFF6600),
                        accentColor: const Color(0xFFE55A00),
                      ),

                      _buildOperatorCard(
                        name: 'Airtel Money',
                        value: 'Airtel',
                        logo: 'A',
                        primaryColor: const Color(0xFFED1C24),
                        accentColor: const Color(0xFFD01820),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Bouton de paiement
                Container(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: (_selectedOperator == null || _isPaying)
                        ? null
                        : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedOperator == null 
                          ? AppColors.buttonDisabled 
                          : AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: AppColors.buttonDisabled.withOpacity(0.6),
                    ),
                    child: _isPaying
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Paiement en cours...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.payment, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Continuer vers le paiement',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Informations de sécurité
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.security,
                        color: AppColors.success,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Paiement sécurisé',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkText,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Vos données bancaires sont protégées par un cryptage de niveau bancaire',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.mediumText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
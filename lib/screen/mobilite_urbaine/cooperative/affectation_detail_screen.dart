// lib/screen/mobilite_urbaine/cooperative/affectation_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:all_pnud/models/affectation.dart';
import 'package:all_pnud/services/affectation_service.dart';

class AffectationDetailScreen extends StatefulWidget {
  final Affectation affectation;

  const AffectationDetailScreen({Key? key, required this.affectation})
      : super(key: key);

  @override
  _AffectationDetailScreenState createState() =>
      _AffectationDetailScreenState();
}

class _AffectationDetailScreenState extends State<AffectationDetailScreen>
    with TickerProviderStateMixin {
  final AffectationService _affectationService = AffectationService();
  late Affectation _currentAffectation;
  bool _isDarkMode = false;
  bool _isUpdating = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _currentAffectation = widget.affectation;
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Color get _backgroundColor =>
      _isDarkMode ? const Color(0xFF030712) : Colors.white;
  Color get _primaryColor => const Color(0xFF00C21C);
  Color get _textColor =>
      _isDarkMode ? const Color(0xFFEBEBEB) : const Color(0xFF131313);
  Color get _cardColor =>
      _isDarkMode ? const Color(0xFF131313) : const Color(0xFFEBEBEB);
  Color get _inputBgColor =>
      _isDarkMode ? const Color(0xFF131313) : const Color(0xFFF8F9FA);

  Color get _statusColor {
    final status = _currentAffectation.statusCoop ?? 'Non renseigné';
    switch (status) {
      case 'valide':
        return _primaryColor;
      case 'en attente':
        return Colors.orange;
      case 'rejete':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _showCustomSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          _buildBackground(),
          _buildModernHeader(),
          _buildThemeToggle(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 120),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildMainContent(),
                ),
              ),
            ),
          ),
          if (_currentAffectation.statusCoop == 'en attente')
            _buildFloatingActionButtons(),
          if (_isUpdating) _buildLoadingOverlay(),
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
              ? [const Color(0xFF030712), const Color(0xFF0A0F1C)]
              : [Colors.white, const Color(0xFFFAFDFA)],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    final status = _currentAffectation.statusCoop ?? 'Non renseigné';

    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [_statusColor, _statusColor.withOpacity(0.8)]),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Détails Affectation',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${_currentAffectation.id ?? 'N/A'}',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.9), fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(_getStatusIcon(status), color: Colors.white, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle() {
    return Positioned(
      top: 160,
      right: 24,
      child: GestureDetector(
        onTap: _toggleTheme,
        child: Icon(
          _isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          color: _textColor.withOpacity(0.7),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildVehicleCard(),
          const SizedBox(height: 20),
          _buildDriverCard(),
          const SizedBox(height: 20),
          _buildAffectationCard(),
          if (_currentAffectation.chauffeur?.permisImage != null)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: _buildImageCard(),
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildVehicleCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Informations Véhicule'),
          const SizedBox(height: 24),
          _buildDetailRow(Icons.confirmation_number, 'Immatriculation',
              _currentAffectation.vehicule?.immatriculation ?? 'Non renseigné'),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.email_outlined, 'Email Propriétaire',
              _currentAffectation.vehicule?.emailProprietaire ??
                  'Non renseigné'),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.info_outline, 'Statut du Véhicule',
              _currentAffectation.vehicule?.status ?? 'Non renseigné'),
        ],
      ),
    );
  }

  Widget _buildDriverCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Informations Chauffeur'),
          const SizedBox(height: 24),
          _buildDetailRow(Icons.phone_outlined, 'Téléphone',
              _currentAffectation.chauffeur?.numPhonChauffeur ??
                  'Non renseigné'),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.badge_outlined, 'Numéro Permis',
              _currentAffectation.chauffeur?.numPermisChauffeur ??
                  'Non renseigné'),
          const SizedBox(height: 16),
          _buildDetailRow(Icons.directions_car_outlined, 'Catégorie Permis',
              _currentAffectation.chauffeur?.categoriPermis ?? 'Non renseigné'),
        ],
      ),
    );
  }

  Widget _buildAffectationCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Statut de l\'Affectation'),
          const SizedBox(height: 24),
          _buildDetailRow(
              _getStatusIcon(
                  _currentAffectation.statusCoop ?? 'Non renseigné'),
              'Statut Coopérative',
              _currentAffectation.statusCoop ?? 'Non renseigné',
              statusColor: _statusColor),
          const SizedBox(height: 16),
          _buildDetailRow(
              Icons.calendar_today_outlined,
              'Date de création',
              _currentAffectation.createdAt?.substring(0, 10) ??
                  'Non renseigné'),
        ],
      ),
    );
  }

  Widget _cardContainer({required Widget child}) {
    return Container(
        decoration: BoxDecoration(
          color: _isDarkMode ? _cardColor.withOpacity(0.9) : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(padding: const EdgeInsets.all(24), child: child));
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {Color? statusColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: statusColor ?? _primaryColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 14,
                      color: _textColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value,
                  style: TextStyle(
                      fontSize: 16,
                      color: statusColor ?? _textColor,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard() {
    final fullImageUrl =
        "https://gateway.tsirylab.com/serviceflotte/${_currentAffectation.chauffeur?.permisImage}";

    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Image du Permis'),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              fullImageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey.withOpacity(0.1),
                child: const Center(
                    child: Icon(Icons.error_outline, size: 50, color: Colors.grey)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons() {
    return Positioned(
      bottom: 30,
      left: 24,
      right: 24,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                setState(() => _isUpdating = true);
                final success = await _affectationService
                    .rejeterAffectation(_currentAffectation.id!);
                setState(() => _isUpdating = false);
                if (success) {
                  setState(() => _currentAffectation =
                      _currentAffectation.copyWith(statusCoop: 'rejete'));
                  _showCustomSnackBar(
                      'Affectation rejetée.', Colors.red, Icons.cancel);
                } else {
                  _showCustomSnackBar(
                      'Erreur lors du rejet.', Colors.red, Icons.error);
                }
              },
              child: const Text('Rejeter'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _primaryColor),
              onPressed: () async {
                setState(() => _isUpdating = true);
                final success = await _affectationService
                    .validerAffectation(_currentAffectation.id!);
                setState(() => _isUpdating = false);
                if (success) {
                  setState(() => _currentAffectation =
                      _currentAffectation.copyWith(statusCoop: 'valide'));
                  _showCustomSnackBar('Affectation validée avec succès.',
                      _primaryColor, Icons.check_circle);
                } else {
                  _showCustomSnackBar(
                      'Erreur lors de la validation.', Colors.red, Icons.error);
                }
              },
              child: const Text('Valider'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'valide':
        return Icons.check_circle;
      case 'en attente':
        return Icons.access_time;
      case 'rejete':
        return Icons.cancel;
      default:
        return Icons.help_outline;
    }
  }
}

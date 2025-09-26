import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:all_pnud/models/vehicule.dart';
import 'package:all_pnud/services/file_service.dart';

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

class VehiculeDetailScreen extends StatelessWidget {
  final Vehicule vehicule;

  const VehiculeDetailScreen({Key? key, required this.vehicule})
      : super(key: key);

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'valide':
        return AppColors.success;
      case 'en_attente':
        return AppColors.warning;
      case 'refuse':
        return AppColors.errorAction;
      case 'validepaye':
        return AppColors.success;
      case 'validenonpaye':
        return AppColors.warning;
      default:
        return AppColors.mediumText;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'valide':
        return Icons.check_circle;
      case 'en_attente':
        return Icons.schedule;
      case 'refuse':
        return Icons.cancel;
      case 'validepaye':
        return Icons.verified;
      case 'validenonpaye':
        return Icons.pending_actions;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildInfoCard({
    required String title,
    required List<Widget> children,
    IconData? icon,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
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
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    IconData? icon,
    Color? valueColor,
    FontWeight? valueFontWeight,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.mediumText, size: 18),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.mediumText,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: valueFontWeight ?? FontWeight.w500,
                color: valueColor ?? AppColors.darkText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    final color = _getStatusColor(status);
    final icon = _getStatusIcon(status);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            status ?? 'N/A',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.primary,
          foregroundColor: foregroundColor ?? Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(dynamic doc) {
    final imageUrl = FileService.getPreviewUrl(doc.fichierRecto ?? '');
    final statusColor = _getStatusColor(doc.status);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade100,
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.description,
                    color: AppColors.mediumText,
                    size: 30,
                  ),
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
                  doc.type ?? 'Document',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    doc.status ?? 'N/A',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final affectation = vehicule.affectation;
    final immatriculation = vehicule.immatriculation ?? 'N/A';

    // Conditions dynamiques
    final bool canPayAdhesion = affectation != null &&
        (affectation.statusCoop?.toLowerCase() == 'validenonpaye');

    final bool canAskLicence = affectation != null &&
        (affectation.statusCoop?.toLowerCase() == 'validepaye') &&
        (vehicule.licence == null || vehicule.status?.toLowerCase() != 'valide');

    final bool canPayLicence = affectation != null &&
        (affectation.statusCoop?.toLowerCase() == 'validepaye') &&
        vehicule.licence != null &&
        (vehicule.licence!.statusPaiement?.toLowerCase() == 'non_paye');

    final bool canPayAmende = vehicule.infraction != null &&
        (vehicule.infraction!.payee == false);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        title: Text(
          'Véhicule $immatriculation',
          style: const TextStyle(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec plaque d'immatriculation
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
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.darkText,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: Text(
                      immatriculation,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStatusBadge(vehicule.status),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Informations générales
            _buildInfoCard(
              title: 'Informations générales',
              icon: Icons.info_outline,
              iconColor: AppColors.info,
              children: [
                _buildInfoRow(
                  label: 'Type de transport',
                  value: vehicule.typeTransport?.nom ?? 'N/A',
                  icon: Icons.category,
                ),
                _buildInfoRow(
                  label: 'Statut',
                  value: vehicule.status ?? 'N/A',
                  valueColor: _getStatusColor(vehicule.status),
                  valueFontWeight: FontWeight.w600,
                  icon: Icons.flag,
                ),
                if (vehicule.status?.toLowerCase() != 'valide' && 
                    (vehicule.motifRefus?.isNotEmpty ?? false))
                  _buildInfoRow(
                    label: 'Motif de refus',
                    value: vehicule.motifRefus!,
                    valueColor: AppColors.errorAction,
                    valueFontWeight: FontWeight.w600,
                    icon: Icons.error,
                  ),
                if (vehicule.dateDescente != null &&
                    vehicule.statusDateDescente?.toLowerCase() != 'fait')
                  _buildInfoRow(
                    label: 'Date d\'inspection',
                    value: DateTime.parse(vehicule.dateDescente!)
                        .toLocal()
                        .toString()
                        .split(" ")[0],
                    valueColor: AppColors.warning,
                    valueFontWeight: FontWeight.w600,
                    icon: Icons.calendar_today,
                  ),
              ],
            ),

            // Documents
            if (vehicule.documents != null && vehicule.documents!.isNotEmpty)
              _buildInfoCard(
                title: 'Documents',
                icon: Icons.folder_open,
                iconColor: AppColors.tertiary,
                children: [
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: vehicule.documents!.length,
                      itemBuilder: (context, index) {
                        final doc = vehicule.documents![index];
                        return _buildDocumentCard(doc);
                      },
                    ),
                  ),
                ],
              ),

            // Affectation / Coopérative
            if (affectation != null && affectation.cooperative != null)
              _buildInfoCard(
                title: 'Coopérative',
                icon: Icons.business,
                iconColor: AppColors.purple,
                children: [
                  _buildInfoRow(
                    label: 'Nom',
                    value: affectation.cooperative!.nameCooperative ?? 'N/A',
                    icon: Icons.business_center,
                  ),
                  _buildInfoRow(
                    label: 'Statut coopérative',
                    value: affectation.statusCoop ?? 'N/A',
                    valueColor: _getStatusColor(affectation.statusCoop),
                    valueFontWeight: FontWeight.w600,
                    icon: Icons.verified,
                  ),
                  _buildInfoRow(
                    label: 'Droit d\'adhésion',
                    value: '${affectation.cooperative!.droitAdhesion} Ar',
                    valueColor: AppColors.primary,
                    valueFontWeight: FontWeight.w700,
                    icon: Icons.monetization_on,
                  ),
                ],
              ),

            // Section Actions
            if (canPayAdhesion || canAskLicence || canPayLicence || canPayAmende)
              _buildInfoCard(
                title: 'Actions disponibles',
                icon: Icons.touch_app,
                iconColor: AppColors.secondary,
                children: [
                  if (canPayAdhesion)
                    _buildActionButton(
                      label: 'Payer adhésion coopérative',
                      icon: Icons.payment,
                      backgroundColor: AppColors.warning,
                      onPressed: () {
                        context.pushNamed('page_paiement', extra: {
                          'typePaiement': 'adhesion',
                          'motif':
                              'Paiement adhésion coopérative pour $immatriculation',
                          'vehicule': vehicule,
                        });
                      },
                    ),

                  if (canAskLicence)
                    _buildActionButton(
                      label: 'Faire une demande de licence',
                      icon: Icons.assignment,
                      backgroundColor: AppColors.info,
                      onPressed: () {
                        context.pushNamed('demande_licence', extra: vehicule);
                      },
                    ),

                  if (canPayLicence)
                    _buildActionButton(
                      label: 'Payer la licence',
                      icon: Icons.payment,
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        context.pushNamed('page_paiement', extra: {
                          'typePaiement': 'licence',
                          'motif': 'Paiement de la licence pour $immatriculation',
                          'vehicule': vehicule,
                        });
                      },
                    ),

                  if (canPayAmende)
                    _buildActionButton(
                      label: 'Payer l\'amende',
                      icon: Icons.payment,
                      backgroundColor: AppColors.errorAction,
                      onPressed: () {
                        context.pushNamed('page_paiement', extra: {
                          'typePaiement': 'amende',
                          'motif': 'Paiement amende pour $immatriculation',
                          'vehicule': vehicule,
                        });
                      },
                    ),
                ],
              ),

            // Informations supplémentaires si infraction
            if (vehicule.infraction != null)
              _buildInfoCard(
                title: 'Infraction',
                icon: Icons.warning,
                iconColor: AppColors.errorAction,
                children: [
                  _buildInfoRow(
                    label: 'Statut paiement',
                    value: vehicule.infraction!.payee == true ? 'Payée' : 'Non payée',
                    valueColor: vehicule.infraction!.payee == true 
                        ? AppColors.success 
                        : AppColors.errorAction,
                    valueFontWeight: FontWeight.w600,
                    icon: Icons.gavel,
                  ),
                ],
              ),

            // Informations licence si disponible
            if (vehicule.licence != null)
              _buildInfoCard(
                title: 'Licence',
                icon: Icons.card_membership,
                iconColor: AppColors.linkColor,
                children: [
                  if (vehicule.licence!.statusApprobation != null)
                    _buildInfoRow(
                      label: 'Statut approbation',
                      value: vehicule.licence!.statusApprobation!,
                      valueColor: _getStatusColor(vehicule.licence!.statusApprobation),
                      valueFontWeight: FontWeight.w600,
                      icon: Icons.approval,
                    ),
                  if (vehicule.licence!.statusPaiement != null)
                    _buildInfoRow(
                      label: 'Statut paiement',
                      value: vehicule.licence!.statusPaiement!,
                      valueColor: _getStatusColor(vehicule.licence!.statusPaiement),
                      valueFontWeight: FontWeight.w600,
                      icon: Icons.payment,
                    ),
                ],
              ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
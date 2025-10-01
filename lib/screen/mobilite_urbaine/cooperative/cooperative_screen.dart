import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:all_pnud/services/cooperative_service.dart';
import 'package:all_pnud/services/affectation_service.dart';
import 'package:all_pnud/models/affectation.dart';
import 'package:all_pnud/models/affectation_summary.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:all_pnud/models/ligne.dart';
import 'package:all_pnud/services/ligne_service.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardCooperativeScreen extends StatefulWidget {
  final int cooperativeId;
  const DashboardCooperativeScreen({Key? key, required this.cooperativeId})
      : super(key: key);

  @override
  State<DashboardCooperativeScreen> createState() =>
      _DashboardCooperativeScreenState();
}

class _DashboardCooperativeScreenState
    extends State<DashboardCooperativeScreen> {
  late Future<List<Affectation>> _affectationsFuture;
  late Future<List<Ligne>> _lignesFuture;
  final AffectationService _affectationService = AffectationService();
  final LigneService _ligneService = LigneService();

  String _filtreStatus = 'all';
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _affectationsFuture =
        _affectationService.getAffectationsByCooperative(widget.cooperativeId.toString());
    _lignesFuture =
        _ligneService.getLignesByCooperative(widget.cooperativeId.toString());
  }

  Widget _buildSummary(List<Affectation> affectations) {
    final uniqueVehicles = affectations
        .map((a) => a.vehicule?.immatriculation ?? 'N/A')
        .toSet()
        .length;
    final uniqueDrivers =
        affectations.map((a) => a.chauffeur?.id ?? -1).toSet().length;

    final totalValid =
        affectations.where((a) => a.statusCoop == 'valide').length;
    final totalPending =
        affectations.where((a) => a.statusCoop == 'en attente').length;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Résumé des affectations',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800, // ExtraBold
              color: const Color(0xFF131313),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.directions_car,
                  label: 'Véhicules',
                  value: uniqueVehicles.toString(),
                  color: const Color(0xFF098E00),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.person,
                  label: 'Chauffeurs',
                  value: uniqueDrivers.toString(),
                  color: const Color(0xFF098E00),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  label: 'Validés',
                  value: totalValid.toString(),
                  color: const Color(0xFF00C21C),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.access_time,
                  label: 'En attente',
                  value: totalPending.toString(),
                  color: const Color(0xFFE8B018),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800, // ExtraBold
              color: const Color(0xFF131313),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w400, // Regular
              color: const Color(0xFF5D5D5D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffectationsList(List<Affectation> affectations) {
    if (affectations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: const Color(0xFF5D5D5D).withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune affectation',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF5D5D5D),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: affectations.length,
      itemBuilder: (context, index) {
        final affectation = affectations[index];
        final status = affectation.statusCoop ?? 'Non renseigné';
        final isValid = status.toLowerCase() == 'valide';

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                context.goNamed('affectation_detail', extra: affectation);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icône de statut
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isValid
                            ? const Color(0xFF00C21C).withOpacity(0.1)
                            : const Color(0xFFE8B018).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isValid ? Icons.check_circle : Icons.access_time,
                        color: isValid
                            ? const Color(0xFF00C21C)
                            : const Color(0xFFE8B018),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Informations
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            affectation.vehicule?.immatriculation ?? 'N/A',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w800, // ExtraBold
                              color: const Color(0xFF131313),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 14,
                                color: const Color(0xFF5D5D5D),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  affectation.chauffeur?.numPhonChauffeur ??
                                      'Non renseigné',
                                  style: GoogleFonts.manrope(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400, // Regular
                                    color: const Color(0xFF5D5D5D),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Badge de statut
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isValid
                            ? const Color(0xFF00C21C).withOpacity(0.1)
                            : const Color(0xFFE8B018).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isValid
                              ? const Color(0xFF00C21C)
                              : const Color(0xFFE8B018),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Filtrer par statut',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800, // ExtraBold
              color: const Color(0xFF131313),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('Tous', 'all', Icons.list),
              _buildFilterOption('Validés', 'valide', Icons.check_circle),
              _buildFilterOption('En attente', 'en attente', Icons.access_time),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String title, String value, IconData icon) {
    final isSelected = _filtreStatus == value;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF098E00).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF098E00)
              : const Color(0xFF5D5D5D).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: RadioListTile<String>(
        title: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? const Color(0xFF098E00)
                  : const Color(0xFF5D5D5D),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF098E00)
                    : const Color(0xFF131313),
              ),
            ),
          ],
        ),
        value: value,
        groupValue: _filtreStatus,
        activeColor: const Color(0xFF098E00),
        onChanged: (newValue) {
          setState(() => _filtreStatus = newValue!);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Background colour
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF131313)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Dashboard Coopérative',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800, // ExtraBold
            color: const Color(0xFF131313),
          ),
        ),
        centerTitle: true,
        actions: [
          // Bouton filtre
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _filtreStatus != 'all'
                  ? const Color(0xFF098E00).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                Icons.filter_list,
                color: _filtreStatus != 'all'
                    ? const Color(0xFF098E00)
                    : const Color(0xFF131313),
              ),
              onPressed: _showFilterDialog,
            ),
          ),
          // Bouton carte/liste
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: _showMap
                  ? const Color(0xFF098E00).withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: Icon(
                _showMap ? Icons.list : Icons.map,
                color: _showMap
                    ? const Color(0xFF098E00)
                    : const Color(0xFF131313),
              ),
              onPressed: () => setState(() => _showMap = !_showMap),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Section résumé
          FutureBuilder<List<Affectation>>(
            future: _affectationsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: 240,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: Color(0xFF098E00),
                  ),
                );
              }
              return _buildSummary(snapshot.data!);
            },
          ),
          // Divider
          Container(
            height: 8,
            color: const Color(0xFFF8F8F8),
          ),
          // Section carte/liste
          Expanded(
            child: _showMap
                ? FutureBuilder<List<Ligne>>(
                    future: _lignesFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF098E00),
                          ),
                        );
                      }

                      final lignes = snapshot.data!;
                      final initialCenter = lignes.isNotEmpty &&
                              lignes.first.trace.isNotEmpty
                          ? LatLng(
                              lignes.first.trace[0][0],
                              lignes.first.trace[0][1],
                            )
                          : LatLng(-21.4413, 47.0941);

                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: initialCenter,
                            initialZoom: 15,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            PolylineLayer(
                              polylines: lignes
                                  .map(
                                    (ligne) => Polyline(
                                      points: ligne.trace
                                          .map((coord) =>
                                              LatLng(coord[0], coord[1]))
                                          .toList(),
                                      color: const Color(0xFF098E00),
                                      strokeWidth: 4,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : FutureBuilder<List<Affectation>>(
                    future: _affectationsFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF098E00),
                          ),
                        );
                      }
                      final filtered = _filtreStatus == 'all'
                          ? snapshot.data!
                          : snapshot.data!
                              .where((a) => a.statusCoop == _filtreStatus)
                              .toList();
                      return _buildAffectationsList(filtered);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
// lib/screen/mobilite_urbaine/cooperative/cooperative_screen.dart

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
        _affectationService.getAffectationsByCooperative(widget.cooperativeId);
    _lignesFuture =
        _ligneService.getLignesByCooperative(widget.cooperativeId);
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

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Résumé des affectations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Véhicules: $uniqueVehicles'),
          Text('Chauffeurs: $uniqueDrivers'),
          Text('Validés: $totalValid'),
          Text('En attente: $totalPending'),
        ],
      ),
    );
  }
Widget _buildAffectationsList(List<Affectation> affectations) {
  return ListView.builder(
    itemCount: affectations.length,
    itemBuilder: (context, index) {
      final affectation = affectations[index];
      final status = affectation.statusCoop ?? 'Non renseigné';

      return ListTile(
        leading: Icon(
          status.toLowerCase() == 'valide'
              ? Icons.check_circle
              : Icons.access_time,
          color: status.toLowerCase() == 'valide'
              ? Colors.green
              : Colors.orange,
        ),
        title: Text(
          'Véhicule: ${affectation.vehicule?.immatriculation ?? ''}',
        ), // ← ICI virgule indispensable
        subtitle: Text(
          'Chauffeur: ${affectation.chauffeur?.numPhonChauffeur ?? ''}',
        ),
        trailing: Text(status),
        onTap: () {
          context.goNamed('affectation_detail', extra: affectation);
        },
      );
    },
  );
}

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrer par statut'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Tous'),
                value: 'all',
                groupValue: _filtreStatus,
                onChanged: (value) {
                  setState(() => _filtreStatus = value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('Validés'),
                value: 'valide',
                groupValue: _filtreStatus,
                onChanged: (value) {
                  setState(() => _filtreStatus = value!);
                  Navigator.pop(context);
                },
              ),
              RadioListTile<String>(
                title: const Text('En attente'),
                value: 'en attente',
                groupValue: _filtreStatus,
                onChanged: (value) {
                  setState(() => _filtreStatus = value!);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Coopérative'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: Icon(_showMap ? Icons.list : Icons.map),
            onPressed: () => setState(() => _showMap = !_showMap),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: FutureBuilder<List<Affectation>>(
              future: _affectationsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return _buildSummary(snapshot.data!);
              },
            ),
          ),
          const Divider(),
          Expanded(
            flex: 2,
            child: _showMap
                ? FutureBuilder<List<Ligne>>(
                    future: _lignesFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }

                      final lignes = snapshot.data!;
                      final initialCenter = lignes.isNotEmpty &&
                              lignes.first.trace.isNotEmpty
                          ? LatLng(
                              lignes.first.trace[0][0],
                              lignes.first.trace[0][1],
                            )
                          : LatLng(-21.4413, 47.0941);

                      return FlutterMap(
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
                                        .map(
                                            (coord) => LatLng(coord[0], coord[1]))
                                        .toList(),
                                    color: Colors.red,
                                    strokeWidth: 4,
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      );
                    },
                  )
                : FutureBuilder<List<Affectation>>(
                    future: _affectationsFuture,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator());
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

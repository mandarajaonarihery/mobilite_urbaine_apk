import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:all_pnud/services/ligne_service.dart';
import 'package:all_pnud/models/ligne.dart';

class MapWithLignesScreen extends StatefulWidget {
  const MapWithLignesScreen({Key? key}) : super(key: key);

  @override
  State<MapWithLignesScreen> createState() => _MapWithLignesScreenState();
}

class _MapWithLignesScreenState extends State<MapWithLignesScreen> {
  final LigneService _ligneService = LigneService();
  List<Ligne> _lignes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLignes();
  }

  Future<void> _loadLignes() async {
    final lignes = await _ligneService.getLignesByCooperative(1);
    setState(() {
      _lignes = lignes;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // centre initial = premier point du premier tracé
    final center = _lignes.isNotEmpty && _lignes.first.trace.isNotEmpty
        ? LatLng(_lignes.first.trace[0][0], _lignes.first.trace[0][1])
        : const LatLng(-18.8792, 47.5079);

    return Scaffold(
      appBar: AppBar(title: const Text('Test Lignes sur Carte')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: center,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),

          // Pour chaque ligne → afficher polyline
          PolylineLayer(
            polylines: _lignes.map((ligne) {
              final points = ligne.trace
                  .map((coord) => LatLng(coord[0], coord[1]))
                  .toList();
              return Polyline(
                points: points,
                strokeWidth: 4,
                color: Color(int.parse(ligne.couleur.substring(1, 7), radix: 16) + 0xFF000000),
              );
            }).toList(),
          ),

          // Un marker sur le premier point
          MarkerLayer(
            markers: _lignes.map((ligne) {
              return Marker(
                point: LatLng(ligne.trace[0][0], ligne.trace[0][1]),
                width: 80,
                height: 80,
                child: const Icon(Icons.flag, color: Colors.red),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

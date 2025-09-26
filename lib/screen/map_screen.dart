import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:all_pnud/services/ligne_service.dart';
import 'package:all_pnud/models/ligne.dart';
import 'package:all_pnud/services/parking_services.dart';
import 'package:all_pnud/models/parking.dart';
import 'package:go_router/go_router.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLocation;
  LatLng? _searchedLocation;
  Ligne? _selectedLigne;
  Parking? _selectedParking;
  final MapController _mapController = MapController();
  final LigneService _ligneService = LigneService();
  final ParkingService _parkingService = ParkingService();
  late Future<List<Ligne>> _futureLignes;
  late Future<List<Parking>> _futureParkings;
  List<Ligne> _allLignes = [];
  List<Ligne> _nearbyLignes = [];
  List<Parking> _allParkings = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _futureLignes = _ligneService.getLignes();
    _futureLignes.then((value) => _allLignes = value);
    _futureParkings = _parkingService.getParkingsByMunicipality(36);
    _futureParkings.then((value) => _allParkings = value);
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return Future.error('Location services are disabled.');
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    _mapController.move(_currentLocation!, 13.0);
  }

  Future<void> _searchLocation(String query) async {
    final LatLng? location = await _ligneService.searchPlace(query);
    if (location != null) {
      setState(() {
        _searchedLocation = location;
        _selectedLigne = null;
        _selectedParking = null;

        _nearbyLignes = _allLignes.where((ligne) {
          return ligne.stops.any((stop) {
            final distance = Distance().as(
              LengthUnit.Meter,
              location,
              LatLng(stop.coordinates[0], stop.coordinates[1]),
            );
            return distance <= 500;
          });
        }).toList();
      });
      _mapController.move(location, 15.0);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Lieu introuvable')));
    }
  }

  /// 🔹 Nettoyer les doublons dans un tracé
  List<LatLng> _deduplicateTrace(List<List<double>> trace) {
    final seen = <String>{};
    final clean = <LatLng>[];
    for (var p in trace) {
      // ATTENTION : adapter ici si votre API renvoie [lon,lat]
      final lat = p[0];
      final lon = p[1];
      final key = '$lat,$lon';
      if (!seen.contains(key)) {
        seen.add(key);
        clean.add(LatLng(lat, lon));
      }
    }
    return clean;
  }

  // 🔹 Construire les polylignes
  List<Polyline> _buildPolylines(List<Ligne> lignes) {
    final polylines = <Polyline>[];
    for (var ligne in lignes) {
      if (_selectedLigne != null && ligne.id != _selectedLigne!.id) continue;

      final trace = _deduplicateTrace(ligne.trace);

      polylines.add(Polyline(
        points: trace,
        color: Color(int.parse(ligne.couleur.replaceFirst('#', '0xFF'))),
        strokeWidth: 4.0,
      ));
    }
    return polylines;
  }

  // 🔹 Polygones parkings
  List<Polygon> _buildParkingPolygons(List<Parking> parkings) {
    final polygons = <Polygon>[];
    for (var parking in parkings) {
      for (var area in parking.localisation) {
        polygons.add(Polygon(
          points: area,
          color: parking.etat == 'libre'
              ? Colors.green.withOpacity(0.5)
              : Colors.red.withOpacity(0.5),
          borderColor: parking.etat == 'libre' ? Colors.green : Colors.red,
          borderStrokeWidth: 2,
        ));
      }
    }
    return polygons;
  }

  // 🔹 Markers parkings
  List<Marker> _buildParkingMarkers(List<Parking> parkings) {
    final markers = <Marker>[];
    for (var parking in parkings) {
      if (parking.localisation.isNotEmpty) {
        final center = parking.localisation[0].fold<LatLng>(
          LatLng(0, 0),
          (prev, point) => LatLng(
            prev.latitude + point.latitude,
            prev.longitude + point.longitude,
          ),
        );
        final centroid = LatLng(
          center.latitude / parking.localisation[0].length,
          center.longitude / parking.localisation[0].length,
        );

        markers.add(Marker(
          point: centroid,
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedParking = parking;
                _selectedLigne = null;
              });
            },
            child: Icon(
              Icons.local_parking,
              color: parking.etat == 'libre' ? Colors.green : Colors.red,
              size: 40,
            ),
          ),
        ));
      }
    }
    return markers;
  }

  // 🔹 Markers arrêts + positions
  List<Marker> _buildMarkers(List<Ligne> lignes) {
    final markers = <Marker>[];
    final reference = _searchedLocation;

    for (var ligne in lignes) {
      for (var stop in ligne.stops) {
        if (_searchedLocation != null) {
          final distance = Distance().as(
            LengthUnit.Meter,
            reference!,
            LatLng(stop.coordinates[0], stop.coordinates[1]),
          );
          if (distance > 500) continue;
        }

        markers.add(Marker(
          point: LatLng(stop.coordinates[0], stop.coordinates[1]),
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedLigne = ligne;
                _selectedParking = null;

                /// 🔹 Recentrer sur le milieu du tracé
                final midIndex = (ligne.trace.length ~/ 2);
                final mid = ligne.trace[midIndex];
                _mapController.move(LatLng(mid[0], mid[1]), 15.0);
              });
            },
            child: Icon(
              stop.name.contains('Terminus')
                  ? Icons.directions_bus
                  : Icons.location_on,
              color: stop.name.contains('Terminus')
                  ? Colors.red
                  : Colors.orange,
              size: 30,
            ),
          ),
        ));
      }
    }

    // Position actuelle
    if (_currentLocation != null) {
      markers.add(Marker(
        point: _currentLocation!,
        width: 80,
        height: 80,
        child: const Icon(Icons.my_location, color: Colors.blue, size: 30),
      ));
    }

    // Position recherchée
    if (_searchedLocation != null) {
      markers.add(Marker(
        point: _searchedLocation!,
        width: 80,
        height: 80,
        child: const Icon(Icons.location_pin, color: Colors.purple, size: 35),
      ));
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des transports et parkings'),
        backgroundColor: const Color(0xFF00C21C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Column(
                  children: [
                    // Barre de recherche
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                  hintText: 'Rechercher un lieu',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () =>
                                _searchLocation(_searchController.text),
                          ),
                        ],
                      ),
                    ),
                    // Carte
                    Expanded(
                      child: FutureBuilder<List<Ligne>>(
                        future: _futureLignes,
                        builder: (context, snapshotLignes) {
                          if (snapshotLignes.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshotLignes.hasError) {
                            return Center(
                                child: Text(
                                    'Erreur lignes: ${snapshotLignes.error}'));
                          }

                          final lignes = snapshotLignes.data!;
                          final polylines = _buildPolylines(lignes);
                          final markers = _buildMarkers(_nearbyLignes.isNotEmpty
                              ? _nearbyLignes
                              : lignes);

                          return FutureBuilder<List<Parking>>(
                            future: _futureParkings,
                            builder: (context, snapshotParkings) {
                              if (snapshotParkings.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshotParkings.hasError) {
                                return Center(
                                    child: Text(
                                        'Erreur parkings: ${snapshotParkings.error}'));
                              }

                              final parkings = snapshotParkings.data!;
                              final parkingPolygons =
                                  _buildParkingPolygons(parkings);
                              final parkingMarkers =
                                  _buildParkingMarkers(parkings);

                              final allMarkers = [...markers, ...parkingMarkers];

                              return FlutterMap(
                                mapController: _mapController,
                                options: MapOptions(
                                  initialCenter: _currentLocation!,
                                  initialZoom: 13.0,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName: 'com.allpnud.app',
                                  ),
                                  PolylineLayer(polylines: polylines),
                                  PolygonLayer(polygons: parkingPolygons),
                                  MarkerLayer(markers: allMarkers),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

                // Card ligne sélectionnée
                if (_selectedLigne != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedLigne!.nom,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text('Coopérative: ${_selectedLigne!.cooperative}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Card parking sélectionné
                if (_selectedParking != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _selectedParking!.nomParking,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text('État: ${_selectedParking!.etat}'),
                              if (_selectedParking!.vehiculeMax != null)
                                Text(
                                    'Places max: ${_selectedParking!.vehiculeMax}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // Liste horizontale lignes proches
                if (_searchedLocation != null && _nearbyLignes.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _nearbyLignes.length,
                        itemBuilder: (context, index) {
                          final ligne = _nearbyLignes[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedLigne = ligne;
                                _selectedParking = null;

                                final midIndex = (ligne.trace.length ~/ 2);
                                final mid = ligne.trace[midIndex];
                                _mapController
                                    .move(LatLng(mid[0], mid[1]), 15.0);
                              });
                            },
                            child: Card(
                              elevation: 4,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      ligne.nom,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text('Coopérative: ${ligne.cooperative}'),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentLocation != null) {
            _mapController.move(_currentLocation!, 15.0);
          }
        },
        backgroundColor: const Color(0xFF00C21C),
        child: const Icon(Icons.gps_fixed, color: Colors.white),
      ),
    );
  }
}

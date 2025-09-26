import 'package:latlong2/latlong.dart';

class Parking {
  final int id;
  final String nomParking;
  final String etat;
  final int? vehiculeMax;
  final List<List<LatLng>> localisation;

  Parking({
    required this.id,
    required this.nomParking,
    required this.etat,
    this.vehiculeMax,
    required this.localisation,
  });

  factory Parking.fromJson(Map<String, dynamic> json) {
    final localisationRaw = json['localisation'] ?? [];
    List<List<LatLng>> localisationParsed = [];

    for (var zone in localisationRaw) {
      List<LatLng> points = [];
      for (var point in zone) {
        // point = [lng, lat]
        points.add(LatLng(point[1], point[0]));
      }
      localisationParsed.add(points);
    }

    return Parking(
      id: json['id_parking'],
      nomParking: json['nom_parking'] ?? '',
      etat: json['etat'] ?? 'libre',
      vehiculeMax: json['vehicule_max'],
      localisation: localisationParsed,
    );
  }
}

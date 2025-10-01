import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:all_pnud/models/ligne.dart';
import 'package:latlong2/latlong.dart';

class LigneService {
  static const String baseUrl = 'https://gateway.tsirylab.com/serviceflotte';

  /// Fetches a list of Lignes from a remote API with pagination.
  Future<List<Ligne>> getLignes({int page = 1, int limit = 10}) async {
    final uri = Uri.parse('$baseUrl/lignes?page=$page&limit=$limit');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> lignesJson = jsonResponse['data'];
        
        // This is where you would filter by cooperativeId if needed,
        // but the API endpoint seems to list all lines.
        // For a more specific request, you would need an endpoint like `/lignes/byCooperativeId`.

        final List<Ligne> lignes = lignesJson.map((json) => Ligne.fromJson(json)).toList();
        return lignes;
      } else {
        throw Exception('Failed to load lines. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  /// Fetches a list of Lignes by cooperative ID from simulated data.
  /// This is useful for testing purposes without making a network call.
  // Future<List<Ligne>> getLignesByCooperative(int cooperativeId) async {
  //   await Future.delayed(const Duration(milliseconds: 500));

  //   // Simulated JSON data
  //   const jsonData = '''
  //   [
  //     {
  //       "id":1,
  //       "nom":"ligne X",
  //       "couleur":"#f7573b",
  //       "tracé":[
  //         [-21.441312,47.094122],
  //         [-21.441323,47.094089],
  //         [-21.4415,47.093699],
  //         [-21.44155,47.093584],
  //         [-21.441625,47.093432],
  //         [-21.4417,47.093286],
  //         [-21.441777,47.093122],
  //         [-21.441878,47.092889],
  //         [-21.441938,47.092761],
  //         [-21.441958,47.092718],
  //         [-21.442022,47.092579],
  //         [-21.44218,47.092262],
  //         [-21.442338,47.09209],
  //         [-21.442463,47.091952],
  //         [-21.442712,47.091674],
  //         [-21.443118,47.091253],
  //         [-21.443677,47.090647],
  //         [-21.443938,47.09035],
  //         [-21.444113,47.090216],
  //         [-21.444965,47.089767],
  //         [-21.445279,47.089593],
  //         [-21.445438,47.089504],
  //         [-21.445514,47.089462],
  //         [-21.445783,47.089497],
  //         [-21.445997,47.089525],
  //         [-21.446564,47.089609],
  //         [-21.447171,47.089677],
  //         [-21.447367,47.089696],
  //         [-21.447644,47.089728],
  //         [-21.447716,47.089737],
  //         [-21.447832,47.08975],
  //         [-21.447953,47.089764],
  //         [-21.448014,47.089772],
  //         [-21.448489,47.089827],
  //         [-21.44881,47.089864],
  //         [-21.448835,47.089866],
  //         [-21.449069,47.089891],
  //         [-21.449379,47.089932],
  //         [-21.449542,47.089953],
  //         [-21.450041,47.09],
  //         [-21.451535,47.090185],
  //         [-21.451694,47.090203]
  //       ],
  //       "cooperativeId":1,
  //       "createdAt":"2025-09-15T08:09:49.726Z",
  //       "updatedAt":"2025-09-15T08:09:49.726Z",
  //       "Cooperative":{"id":1,"nom":"Coop Fianarantsoa"}
  //     }
  //   ]
  //   ''';
    
  //   // Check if the cooperativeId is 1 before parsing, as the data is hardcoded for it
  //   if (cooperativeId != 1) {
  //     return []; // Return empty list if cooperativeId doesn't match simulated data
  //   }

  //   final List parsed = json.decode(jsonData);
  //   return parsed.map((e) => Ligne.fromJson(e)).toList();
  // }
  Future<List<Ligne>> getLignesByCooperative(String cooperativeId,
    {int page = 1, int limit = 10}) async {
  final url = Uri.parse(
    '$baseUrl/lignes/cooperative/$cooperativeId?page=$page&limit=$limit',
  );

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    // Vérifie selon le format exact de ton API (souvent c’est data['lignes'])
    final List lignesJson = data['lignes'] ?? data;
    return lignesJson.map((json) => Ligne.fromJson(json)).toList();
  } else if (response.statusCode == 404) {
    return [];
  } else {
    throw Exception('Erreur lors du chargement des lignes');
  }
}


  Future<LatLng?> searchPlace(String query) async {
  final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1');
  final response = await http.get(url);
  
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data.isNotEmpty) {
      final lat = double.parse(data[0]['lat']);
      final lon = double.parse(data[0]['lon']);
      return LatLng(lat, lon);
    }
  }
  return null;
}

}
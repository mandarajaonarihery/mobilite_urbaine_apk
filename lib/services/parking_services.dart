import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:all_pnud/models/parking.dart';

class ParkingService {
  static const String baseUrl = 'https://gateway.tsirylab.com/serviceflotte';

  Future<List<Parking>> getParkingsByMunicipality(int municipalityId,
      {int page = 1, int limit = 10}) async {
    final url = Uri.parse(
      '$baseUrl/parkings/municipality/$municipalityId?page=$page&limit=$limit',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> parkingsJson = jsonResponse['data'];

        final List<Parking> parkings =
            parkingsJson.map((json) => Parking.fromJson(json)).toList();
        return parkings;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(
            'Échec du chargement des parkings. Code de statut: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }
}

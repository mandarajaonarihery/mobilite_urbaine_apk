import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:all_pnud/models/chauffeur.dart';

class ChauffeurService {
  final String baseUrl =
      'https://gateway.tsirylab.com/serviceflotte/chauffeurs/municipality';

  Future<List<Chauffeur>> getChauffeursByMunicipality(int municipalityId) async {
    final url = Uri.parse('$baseUrl/$municipalityId');
    final response = await http.get(url, headers: {'accept': '*/*'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final list = data['data'] as List;
      return list.map((e) => Chauffeur.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des chauffeurs');
    }
  }
Future<Chauffeur?> getChauffeurByCIN(int municipalityId, String cinText) async {
  final chauffeurs = await getChauffeursByMunicipality(municipalityId);

  try {
    return chauffeurs.firstWhere(
      (c) => c.cin == cinText, // Utilise le champ aplati
    );
  } catch (e) {
    return null;
  }
}


}

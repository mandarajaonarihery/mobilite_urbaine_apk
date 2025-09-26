// lib/service/agent_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:all_pnud/constantes/api.dart';

class AgentService {
  static const String baseUrl = Api.baseUrl;
  static const String agentCitizenPath = Api.agentCitizen;

  /// Récupère uniquement l'id_user d'un agent par id_citizen
 static Future<String?> getAgentIdByCitizen(String idCitizen) async {
  final url = Uri.parse('$baseUrl$agentCitizenPath/$idCitizen');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      print("🔍 Réponse AgentService: $jsonData");

      // Récupère le champ 'id' dans 'data'
      final id = jsonData['data']?['id'];
      if (id != null) {
        return id.toString();
      } else {
        print("⚠️ Clé 'id' non trouvée dans data");
        return null;
      }
    } else {
      print('Erreur API: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Erreur de connexion: $e');
    return null;
  }
}

}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:all_pnud/constantes/api.dart';
import 'package:all_pnud/services/agent_service.dart';

class ScanService {
  /// Récupère les infos véhicule + documents à partir de l'immatriculation et la commune
  Future<Map<String, dynamic>?> getVehiculeWithCode(
      Map<String, dynamic> scannedData, {required String idCitizen}) async {
    try {
      // Récupérer l'ID de l'agent à partir de l'ID du citoyen
      final String? agentId = await AgentService.getAgentIdByCitizen(idCitizen);

      if (agentId == null) {
        return {"error": "Impossible de récupérer l'ID de l'agent pour ce citoyen"};
      }

      // Extraction et nettoyage des données
      final String immatriculation =
          scannedData['immatriculation'].toString().trim();
      final int municipalityId =
          int.parse(scannedData['municipality_id'].toString().trim());

      // Vérifier que les paramètres sont valides
      if (immatriculation.isEmpty || municipalityId <= 0) {
        return {"error": "Paramètres invalides"};
      }

      // Construire l’URL finale
      final String endpoint = Api.vehiculeDocumentation
          .replaceFirst("{immatriculation}", immatriculation)
          .replaceFirst("{municipality_id}", municipalityId.toString());

      final Uri url = Uri.parse("${Api.baseUrl}$endpoint");

      // 🔍 Debug
      print("🔍 immatriculation: $immatriculation");
      print("🏙️ municipalityId: $municipalityId");
      print("👤 idCitizen: $idCitizen");
      print("👤 agentId: $agentId");
      print("🔗 URL appelée: $url");

      // Appel API
      final response = await http.get(url);

      // Vérifier le code de statut
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          return {
            "agentId": agentId,
            "vehiculeData": data,
          };
        } else {
          return {"error": "Format de réponse invalide"};
        }
      } else if (response.statusCode == 404) {
        return {"error": "Données non trouvées (404)"};
      } else {
        return {"error": "Erreur serveur: ${response.statusCode}"};
      }
    } catch (e) {
      print("Exception: $e");
      return {"error": "Exception: $e"};
    }
  }
}
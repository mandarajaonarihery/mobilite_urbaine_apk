import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/infraction.dart';
import 'package:all_pnud/constantes/api.dart';
class InfractionService {
  static const String url = Api.baseUrl + Api.infraction;

  /// Retourne null si succès, sinon le message d'erreur
  static Future<String?> enregistrerInfraction(Infraction infraction) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(infraction.toJson()),
      );

      print("📤 [ENVOI INFRACTION] ${infraction.toJson()}");
      print("📥 [REPONSE] Code: ${response.statusCode}");
      print("📥 [REPONSE] Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        return null; // succès
      } else {
        // On décode le message d'erreur envoyé par le serveur
        final body = jsonDecode(response.body);
        return body['message'] ?? 'Erreur inconnue du serveur';
      }
    } catch (e) {
      print("❌ Erreur HTTP: $e");
      return e.toString(); // message d'erreur
    }
  }
}
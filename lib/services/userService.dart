import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:all_pnud/constantes/api.dart';

class UserService {
  Future<Map<String, dynamic>?> fetchUserInfo(
      String userId, String accessToken) async {
    final url = Uri.parse(
        "${Api.baseUrl}${Api.user.replaceFirst('{id}', userId)}");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Erreur serveur: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Erreur réseau: $e");
      return null;
    }
  }
}
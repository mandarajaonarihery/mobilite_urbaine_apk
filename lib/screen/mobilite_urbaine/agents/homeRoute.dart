import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:all_pnud/widgets/userInfoCard.dart';
import 'package:all_pnud/widgets/primaryButton.dart';
import 'package:all_pnud/widgets/footer.dart';
import 'scan.dart';

class HomeRoute extends StatefulWidget {
  final String accessToken;

  const HomeRoute({
    super.key,
    required this.accessToken,
  });

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  String? _email;
  String? _role;
  String? _idCitizen;

  @override
  void initState() {
    super.initState();
    _decodeToken();
  }

  void _decodeToken() {
    try {
      final decoded = JwtDecoder.decode(widget.accessToken);

      setState(() {
        _email = decoded['user_email'] ?? 'Inconnu';
        _idCitizen = decoded['id_citizen']?.toString();
        if (decoded['roles'] != null && decoded['roles'].isNotEmpty) {
          _role = decoded['roles'][0]['role_name'] ?? 'Aucun rôle';
        } else {
          _role = 'Aucun rôle';
        }
      });
    } catch (e) {
      setState(() {
        _email = 'Erreur';
        _role = 'Erreur';
        _idCitizen = null;
      });
    }
  }

  void _onScanPressed() {
    if (_idCitizen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanPage(idCitizen: _idCitizen!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de récupérer l’ID du citoyen'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  UserInfoCard(
                    name: _email ?? 'Chargement...',
                    role: _role ?? 'Chargement...',
                    imageUrl: 'images/user.jpg',
                    // onMenuPressed supprimé car plus de drawer
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  const Text(
                    'Veuillez appuyer sur le bouton pour scanner un véhicule !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Color(0xFF131313)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Center(
                    child: Image.asset(
                      'images/scan.png',
                      height: MediaQuery.of(context).size.height * 0.25,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  PrimaryButton(
                    text: 'Scanner',
                    onPressed: _onScanPressed,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomFooter(
        onNotificationPressed: () => print("Notification cliquée"),
        onHistoryPressed: () => print("Historique cliqué"),
      ),
    );
  }
}

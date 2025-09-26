import 'package:all_pnud/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:all_pnud/screen/historique.dart';
import 'package:all_pnud/screen/profil.dart';
import 'package:all_pnud/screen/homeRoute.dart';
import 'package:all_pnud/constantes/appColors.dart';
import 'package:all_pnud/screen/scannerResultat.dart';

class CustomDrawer extends StatefulWidget {
  final String accessToken; // ✅ Ajout du token obligatoire

  const CustomDrawer({
    super.key,
    required this.accessToken,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isDarkMode = false; // état du switch

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 70,
            color: AppColors.vert,
            child: const Center(
              child: Text(
                'Mobilité Urbaine',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),

          // Accueil
          ListTile(
            leading: const Icon(Icons.home, color: AppColors.vert),
            title: const Text('Accueil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeRoute(
                    accessToken: widget.accessToken, // ✅ Passe le token
                  ),
                ),
              );
            },
          ),

          // Profil
          ListTile(
            leading: const Icon(Icons.person, color: AppColors.vert),
            title: const Text('Profil'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Profil(
                  ),
                ),
              );
            },
          ),

          // Historique
          ListTile(
            leading: const Icon(Icons.history, color: AppColors.vert),
            title: const Text('Historique de contravention'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Historique(
                    // ⚡️ tu pourras aussi lui passer widget.accessToken si besoin
                      accessToken: widget.accessToken,
                  ),
                ),
              );
            },
          ),

          // Switch mode nuit
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode, color: AppColors.vert),
            title: const Text("Mode nuit"),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
              // 👉 Ici tu peux déclencher ton changement de thème global
            },
          ),

          // Déconnexion
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.vert),
            title: const Text('Se déconnecter'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
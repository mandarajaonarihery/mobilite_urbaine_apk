import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String name;
  final String role;
  final String imageUrl;
  final VoidCallback? onMenuPressed;

  const UserInfoCard({
    super.key,
    required this.name,
    required this.role,
    required this.imageUrl,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Bouton menu (déplacé à gauche)
          IconButton(
            icon: const Icon(Icons.menu),
            iconSize:30,
            onPressed: onMenuPressed,
          ),
          const SizedBox(width: 16),
          // Texte: nom + rôle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  role,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Image (déplacée à droite)
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imageUrl),
          ),
        ],
      ),
    );
  }
}
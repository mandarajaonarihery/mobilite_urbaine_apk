import 'package:flutter/material.dart';

/// Widget pour regrouper une section d’infos
class InfoScanCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const InfoScanCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}
//widget pour les informations
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor; // ← ajouter cette ligne

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor, // ← ajouter cette ligne
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(color: valueColor ?? Colors.grey[700]), // ← utiliser valueColor
            ),
          ),
        ],
      ),
    );
  }
}
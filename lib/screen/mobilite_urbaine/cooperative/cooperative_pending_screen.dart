import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CooperativePendingScreen extends StatefulWidget {
  final Map<String, dynamic> cooperative; // données récupérées

  const CooperativePendingScreen({Key? key, required this.cooperative}) : super(key: key);

  @override
  State<CooperativePendingScreen> createState() => _CooperativePendingScreenState();
}

class _CooperativePendingScreenState extends State<CooperativePendingScreen> {
  late String message;

  @override
  void initState() {
    super.initState();
    _setMessage();
  }

  void _setMessage() {
    final dateDescente = widget.cooperative['date_descente'];
    if (dateDescente == null) {
      message = "Votre dossier est en cours d'analyse par nos administrateurs.";
    } else {
      final date = DateTime.parse(dateDescente);
      message = "Date de descente : ${DateFormat('dd MMMM yyyy').format(date)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statut Coopérative"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.access_time,
              size: 80,
              color: Colors.orange,
            ),
            const SizedBox(height: 24),
            Text(
              message.contains("Date de descente") ? "Descente programmée" : "Validation en attente",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Étapes de validation:", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text("1. Dossier reçu ✅"),
                Text("2. Vérification ✅"),
                Text("3. Validation admin ⏳"),
                Text("4. Notification ⏳"),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: const [
                Icon(Icons.notifications),
                SizedBox(width: 8),
                Expanded(
                  child: Text("Vous recevrez une notification dès validation."),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

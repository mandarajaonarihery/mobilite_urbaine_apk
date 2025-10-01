import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ChauffeurDashboardScreen extends StatelessWidget {
  final Map<String, dynamic> chauffeurData;

  const ChauffeurDashboardScreen({
    Key? key,
    required this.chauffeurData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chauffeur = chauffeurData['chauffeur'];
    final citizen = chauffeurData['citizen'] ?? chauffeur['citizen'];

    final affectationsFromChauffeur = (chauffeur['affectations'] as List<dynamic>? ?? []);
    final affectationsFromRoot = (chauffeurData['affectations'] as List<dynamic>? ?? []);
    final affectations = {
      for (var aff in [...affectationsFromChauffeur, ...affectationsFromRoot])
        aff['id_affectation'] ?? aff['id']: aff
    }.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Espace Chauffeur"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 Infos chauffeur
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    citizen?['citizen_photo'] ?? "https://via.placeholder.com/150",
                  ),
                  radius: 28,
                ),
                title: Text(
                  "${citizen?['citizen_name'] ?? ''} ${citizen?['citizen_lastname'] ?? ''}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("📞 ${chauffeur['numPhon_chauffeur']}"),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Permis : ${chauffeur['numPermis_chauffeur'] ?? 'N/A'}"),
                    Text("Catégorie : ${chauffeur['categori_permis'] ?? 'N/A'}"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🚗 Liste des véhicules affectés
            Text(
              "Vos véhicules affectés",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),

            if (affectations.isEmpty)
              const Text("Aucun véhicule affecté pour le moment.")
            else
              Column(
                children: affectations.map((aff) {
                  final vehicule = aff['vehicule'];
                  final docs = vehicule?['documents'] as List<dynamic>? ?? [];
                  final proprietaire = vehicule?['proprietaire']?['citizen'];

                  // 🔑 Données pour le QR
                  final qrData = {
                    "immatriculation": vehicule?['immatriculation'],
                    "proprietaire_id": proprietaire?['id_citizen'],
                  };

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "🚘 ${vehicule?['immatriculation'] ?? 'Inconnu'}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text("Type : ${vehicule?['typeTransport']?['nom'] ?? 'N/A'}"),
                          Text("Status : ${vehicule?['status'] ?? 'N/A'}"),

                          const SizedBox(height: 10),

                          // 👤 Propriétaire
                          if (proprietaire != null) ...[
                            const Divider(),
                            const Text("👤 Propriétaire :", style: TextStyle(fontWeight: FontWeight.w600)),
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  proprietaire['citizen_photo'] ?? "https://via.placeholder.com/150",
                                ),
                              ),
                              title: Text("${proprietaire['citizen_name']} ${proprietaire['citizen_lastname']}"),
                              subtitle: Text("📍 ${proprietaire['citizen_city']}"),
                            ),
                          ],

                          const Divider(),
                          const Text("📄 Documents :", style: TextStyle(fontWeight: FontWeight.w600)),
                          ...docs.map((doc) => ListTile(
                                leading: const Icon(Icons.description),
                                title: Text(doc['type'] ?? 'Document'),
                                subtitle: Text("Statut : ${doc['status']}"),
                                trailing: doc['date_expiration'] != null
                                    ? Text("Expire : ${doc['date_expiration'].toString().substring(0, 10)}")
                                    : const Text("Pas de date"),
                              )),

                          const Divider(),

                          // 📲 QR Code
                          Center(
  child: QrImageView(
    data: qrData.toString(), // on encode l'objet JSON
    version: QrVersions.auto,
    size: 150.0,
  ),
),

                          const SizedBox(height: 10),
                          const Text("📲 QR Code de vérification (véhicule + propriétaire)"),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

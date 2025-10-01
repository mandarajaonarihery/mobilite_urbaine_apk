import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 🔹 nécessaire pour Provider
import 'package:all_pnud/constantes/appColors.dart';
import 'package:all_pnud/util/scanDonnee.dart';
import 'package:all_pnud/widgets/infoScanWidget.dart';
import 'package:all_pnud/models/infraction.dart';
import 'package:all_pnud/services/infractionService.dart';
import 'package:all_pnud/providers/auth_provider.dart'; // 🔹 ton AuthProvider

class ScannerResultat extends StatefulWidget {
  final Map<String, dynamic> result;
  final String agentId;

  const ScannerResultat({
    super.key,
    required this.result,
    required this.agentId,
  });

  @override
  State<ScannerResultat> createState() => _ScannerResultatState();
}

class _ScannerResultatState extends State<ScannerResultat> {
  late Map<String, dynamic> adapted;
  late List<Map<String, dynamic>> documents;
  late Map<String, dynamic> licence;
  late Map<String, dynamic> vehicle;
  late Map<String, dynamic> driver;

  @override
  void initState() {
    super.initState();
    adapted = scanDonnee(widget.result);
    documents = List<Map<String, dynamic>>.from(adapted['documents'] ?? []);
    licence = adapted['licence'] ?? {};
    vehicle = adapted['vehicle'] ?? {};
    driver = adapted['driver'] ?? {};

    _verifierEtEnvoyerInfractions();
  }

  // ------------------- Couleur conditionnelle -------------------
  Color getDocumentColor(Map<String, dynamic> doc) {
    DateTime now = DateTime.now();
    final type = doc['type']?.toString().toLowerCase() ?? '';
    bool isMissing = doc['expiration'] == null ||
        doc['expiration'] == '' ||
        doc['expiration'] == 'aucune' ||
        doc['expiration'] == 'N/A';

    if (type.contains('cartegrise')) return isMissing ? Colors.red : AppColors.vert;

    bool isExpired = false;
    if (!isMissing) {
      try {
        final exp = DateTime.parse(doc['expiration']);
        if (exp.isBefore(now)) isExpired = true;
      } catch (_) {}
    }

    return (isMissing || isExpired) ? Colors.red : AppColors.vert;
  }

  Color getLicenceColor(Map<String, dynamic> licence) {
    DateTime now = DateTime.now();
    bool isExpired = false;

    if (licence['date_expiration'] != null &&
        licence['date_expiration'] != "N/A") {
      try {
        final exp = DateTime.parse(licence['date_expiration']);
        if (exp.isBefore(now)) isExpired = true;
      } catch (_) {}
    }

    bool notEligible = (licence['eligibilite'] != null &&
        licence['eligibilite'].toString().toLowerCase() != 'oui');

    return (isExpired || notEligible) ? Colors.red : AppColors.vert;
  }

  // ------------------- Vérification infractions -------------------
  Future<void> _verifierEtEnvoyerInfractions() async {
  DateTime now = DateTime.now();
  bool infractionAdded = false;
  String errorMessages = '';

  // 🔹 récupérer municipalityId via Provider ici
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final dynamic muniIdRaw = authProvider.decodedToken?['municipality_id'];
  final int? municipalityId = (muniIdRaw is int)
      ? muniIdRaw
      : int.tryParse(muniIdRaw.toString()); // Sécurise le type

  final int agentIdInt = int.tryParse(widget.agentId) ?? 0;

  // ----------- Documents -----------
  for (var doc in documents) {
    final String type = doc['type']?.toString() ?? "Document";
    final String typeLower = type.toLowerCase();

    bool isMissing = doc['expiration'] == null ||
        doc['expiration'] == '' ||
        doc['expiration'] == 'aucune' ||
        doc['expiration'] == 'N/A';

    bool isExpired = false;
    if (!isMissing && !typeLower.contains('cartegrise')) {
      try {
        final exp = DateTime.parse(doc['expiration']);
        if (exp.isBefore(now)) isExpired = true;
      } catch (e) {
        print("Erreur parsing expiration pour $type: $e");
      }
    }

    String description = '';
    if (isMissing) description = "$type est manquant";
    if (isExpired) description = "$type est expiré";

    if (description.isNotEmpty) {
      print("Infraction détectée pour $type: $description");

      try {
        final infraction = Infraction(
          agentId: agentIdInt,
          immatriculation: vehicle['immatriculation']?.toString() ?? "N/A",
          typeInfraction: "DOCUMENT_INVALIDE",
          description: description,
          montantAmende: 30000.0, // double
          statut: "NON_PAYEE",
          dateInfraction: now,
          municipalityId: municipalityId?.toString(),
        );

        String? error = await InfractionService.enregistrerInfraction(infraction);

        if (error == null) {
          infractionAdded = true;
        } else {
          errorMessages += "$type: $error\n";
        }
      } catch (e) {
        print("Erreur ajout infraction pour $type: $e");
        errorMessages += "$type: $e\n";
      }
    }
  }

  // ----------- Licence -----------
  if (licence.isNotEmpty) {
    bool licenceExpiree = false;
    if (licence['date_expiration'] != null &&
        licence['date_expiration'] != "N/A") {
      try {
        final exp = DateTime.parse(licence['date_expiration']);
        if (exp.isBefore(now)) licenceExpiree = true;
      } catch (e) {
        print("Erreur parsing date licence: $e");
      }
    }

    bool notEligible = (licence['eligibilite'] != null &&
        licence['eligibilite'].toString().toLowerCase() != 'oui');

    String licenceDescription = '';
    if (licenceExpiree) licenceDescription = "La licence est expirée";
    if (notEligible) licenceDescription = "La licence n'est pas éligible";

    if (licenceDescription.isNotEmpty) {
      print("Infraction détectée pour licence: $licenceDescription");

      try {
        final infraction = Infraction(
          agentId: agentIdInt,
          immatriculation: vehicle['immatriculation']?.toString() ?? "N/A",
          typeInfraction: "LICENCE_INVALIDE",
          description: licenceDescription,
          montantAmende: 30000.0, // double
          statut: "NON_PAYEE",
          dateInfraction: now,
          municipalityId: municipalityId.toString(),
        );

        String? error = await InfractionService.enregistrerInfraction(infraction);

        if (error == null) {
          infractionAdded = true;
        } else {
          errorMessages += "Licence: $error\n";
        }
      } catch (e) {
        print("Erreur ajout infraction licence: $e");
        errorMessages += "Licence: $e\n";
      }
    }
  }

  // ----------- SnackBar -----------
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (infractionAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Une ou plusieurs infractions ont été ajoutées.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }

    if (errorMessages.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Erreur lors de l'ajout d'infractions:\n$errorMessages",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  });
}


  // ------------------- Build -------------------
  @override
  Widget build(BuildContext context) {
    final owner = adapted['owner'] ?? {};

    if (adapted.isEmpty ||
        (vehicle.isEmpty &&
            driver.isEmpty &&
            owner.isEmpty &&
            documents.isEmpty &&
            licence.isEmpty)) {
      return Scaffold(
        appBar: AppBar(title: const Text("Résultat du scan")),
        body: const Center(
          child: Text(
            "Aucune donnée trouvée",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Résultat du scan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: const [
                  Icon(Icons.qr_code, size: 80, color: AppColors.vert),
                  SizedBox(height: 20),
                  Text(
                    "Résultat du scan :",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Agent
            InfoScanCard(
              title: 'Agent',
              children: [
                InfoRow(
                    label: 'ID de l\'agent',
                    value: widget.agentId.isNotEmpty
                        ? widget.agentId
                        : "non disponible"),
              ],
            ),

            const SizedBox(height: 20),

            // Véhicule
            InfoScanCard(
              title: 'Véhicule',
              children: [
                InfoRow(
                    label: 'Immatriculation',
                    value: vehicle['immatriculation'] ?? "N/A"),
                InfoRow(
                    label: 'Type de transport',
                    value: vehicle['typeTransport'] ?? "N/A"),
              ],
            ),

            const SizedBox(height: 20),

            // Chauffeur
            if (driver.isNotEmpty)
              InfoScanCard(
                title: 'Chauffeur',
                children: [
                  InfoRow(label: 'Email', value: driver['email'] ?? "N/A"),
                  InfoRow(
                      label: 'Numéro téléphone',
                      value: driver['numPhone'] ?? "N/A"),
                  InfoRow(
                      label: 'Permis de conduire',
                      value: driver['numPermis'] ?? "N/A"),
                ],
              ),

            const SizedBox(height: 20),

            // Propriétaire
            if (owner.isNotEmpty)
              InfoScanCard(
                title: 'Propriétaire',
                children: [
                  InfoRow(label: 'Nom', value: owner['nom'] ?? "N/A"),
                  InfoRow(label: 'Prenom', value: owner['prenom'] ?? "N/A"),
                ],
              ),

            const SizedBox(height: 20),

            // Documents
            if (documents.isNotEmpty)
              InfoScanCard(
                title: 'Documents',
                children: documents.map((doc) {
                  return InfoRow(
                    label: doc['type'] ?? "Document",
                    value: doc['expiration'] ?? "N/A",
                    valueColor: getDocumentColor(doc),
                  );
                }).toList(),
              ),

            const SizedBox(height: 20),

            // Licence
            if (licence.isNotEmpty)
              InfoScanCard(
                title: 'Licence',
                children: [
                  InfoRow(
                      label: 'Numero',
                      value: licence['num_licence'] ?? "N/A",
                      valueColor: getLicenceColor(licence)),
                  InfoRow(
                      label: 'Date d\'expiration',
                      value: licence['date_expiration'] ?? "N/A",
                      valueColor: getLicenceColor(licence)),
                  InfoRow(
                      label: 'Eligibilite',
                      value: licence['eligibilite'] ?? "N/A",
                      valueColor: getLicenceColor(licence)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

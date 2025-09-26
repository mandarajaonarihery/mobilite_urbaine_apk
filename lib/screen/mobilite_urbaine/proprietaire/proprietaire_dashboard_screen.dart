import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:all_pnud/providers/auth_provider.dart';
import 'package:all_pnud/services/vehicule_service.dart';
import 'package:all_pnud/models/vehicule.dart';

class ProprietaireDashboardScreen extends StatefulWidget {
  const ProprietaireDashboardScreen({Key? key}) : super(key: key);

  @override
  State<ProprietaireDashboardScreen> createState() =>
      _ProprietaireDashboardScreenState();
}

class _ProprietaireDashboardScreenState
    extends State<ProprietaireDashboardScreen> {
  late Future<List<Vehicule>> _vehiculesFuture;
  final VehiculeService _vehiculeService = VehiculeService();

  @override
  void initState() {
    super.initState();
    _fetchVehicules();
  }

  void _fetchVehicules() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final citizenId = authProvider.decodedToken?['id_citizen'];
    final token = authProvider.token;

    if (citizenId != null && token != null) {
      setState(() {
        _vehiculesFuture =
            _vehiculeService.getVehiculesByCitizenId(citizenId, token);
      });
    } else {
      setState(() {
        _vehiculesFuture = Future.value([]);
      });
    }
  }

  /// Retourne le message de statut à afficher pour un véhicule
  String getVehiculeStatusMessage(Vehicule vehicule) {
    final vehiculeStatus = vehicule.status?.toLowerCase() ?? '';
    if (vehiculeStatus == 'en_attente') {
      final affectationStatus =
          vehicule.affectation?.statusCoop?.toLowerCase() ?? '';
      switch (affectationStatus) {
        case 'en_attente':
          return 'En attente de validation';
        case 'validenonpaye':
          return 'Vous pouvez maintenant payer';
        case 'rejete':
          return 'Rejeté par la coop';
        case 'validepaye':
          return 'Vous pouvez passer à la demande de licence';
        default:
          return 'En attente';
      }
    } else {
      return vehicule.status ?? 'Inconnu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Tableau de Bord Véhicules'),
      ),
      body: Center(
        child: FutureBuilder<List<Vehicule>>(
          future: _vehiculesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Erreur: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("Aucun véhicule trouvé.");
            } else {
              final vehicules = snapshot.data!;
              return ListView.builder(
                itemCount: vehicules.length,
                itemBuilder: (context, index) {
                  final vehicule = vehicules[index];
                  final statusMessage = getVehiculeStatusMessage(vehicule);

                  return ListTile(
                    leading: const Icon(Icons.directions_bus),
                    title: Text(
                      vehicule.immatriculation ?? 'Non renseigné',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Statut: $statusMessage'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Redirection vers la page détail du véhicule
                    context.goNamed('vehicule_detail', extra: vehicule);

                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

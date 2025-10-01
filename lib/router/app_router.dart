import 'package:all_pnud/screen/mobilite_urbaine/chauffeur/chauffeur_dash.dart';
import 'package:all_pnud/screen/mobilite_urbaine/chauffeur/chauffeur_register.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Providers
import 'package:all_pnud/providers/auth_provider.dart';
import 'package:all_pnud/providers/theme_provider.dart';
import 'package:all_pnud/providers/locale_provider.dart';

// Pages / Screens
import 'package:all_pnud/pages/login_page.dart';
import 'package:all_pnud/screen/landing_page.dart';
import 'package:all_pnud/screen/settings_page.dart';
import 'package:all_pnud/screen/map_screen.dart';
import 'package:all_pnud/screen/home/dashboard_screen.dart';
import 'package:all_pnud/screen/mobilite_urbaine/mobilite_urbaine_screen.dart';

// Mobilité urbaine
import 'package:all_pnud/screen/mobilite_urbaine/cooperative/cooperative_screen.dart';
import 'package:all_pnud/screen/mobilite_urbaine/cooperative/cooperative_register_screen.dart';
import 'package:all_pnud/screen/mobilite_urbaine/cooperative/cooperative_pending_screen.dart';
import 'package:all_pnud/screen/mobilite_urbaine/cooperative/cooperative_rejected.dart';
import 'package:all_pnud/screen/mobilite_urbaine/cooperative/affectation_detail_screen.dart';
import 'package:all_pnud/screen/mobilite_urbaine/agents/agents_screen.dart';
import 'package:all_pnud/screen/mobilite_urbaine/proprietaire/proprietaire_dashboard_screen.dart';
import 'package:all_pnud/screen/mobilite_urbaine/proprietaire/demande_vehicule_screen.dart';
import 'package:all_pnud/screen/mobilite_urbaine/proprietaire/demande_licence_screen.dart';
import 'package:all_pnud/screen/mobilite_urbaine/proprietaire/vehicule_detail.dart';
import 'package:all_pnud/screen/mobilite_urbaine/proprietaire/page_paiement_screen.dart';
import 'package:all_pnud/screen/mobilite_urbaine/agents/homeRoute.dart';

// Models
import 'package:all_pnud/models/vehicule.dart';
import 'package:all_pnud/models/affectation.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static GoRouter getRouter({
    required ThemeProvider themeProvider,
    required LocaleProvider localeProvider,
  }) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      redirect: (context, state) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final isLoggedIn = authProvider.isLoggedIn;
        final isLoggingIn = state.uri.path == '/login';
        final isOnLanding = state.uri.path == '/';
        final isOnMap = state.uri.path == '/map';

        if (!isLoggedIn && !isLoggingIn && !isOnLanding && !isOnMap) return '/';
        if (isLoggedIn && (isLoggingIn || isOnLanding)) return '/mobilite_urbaine';

        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'landing',
          builder: (context, state) => LandingPage(),
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const ModernLoginScreen(),
        ),
        GoRoute(
          path: '/map',
          name: 'map',
          builder: (context, state) => const MapScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/mobilite_urbaine',
          name: 'mobilite_urbaine',
          builder: (context, state) => const MobiliteUrbaineScreen(),
          routes: [
             GoRoute(
      path: 'chauffeur/register',
      name: 'chauffeur_register',
      builder: (context, state) => const ChauffeurRegisterScreen(),
    ),
   GoRoute(
  path: 'chauffeur/dashboard',
  name: 'chauffeur_dashboard',
  builder: (context, state) {
    final chauffeurData = state.extra as Map<String, dynamic>;
    return ChauffeurDashboardScreen(chauffeurData: chauffeurData);
  },
),

            GoRoute(
              path: 'proprietaire/dashboard',
              name: 'proprietaire_dashboard',
              builder: (context, state) => const ProprietaireDashboardScreen(),
            ),
            GoRoute(
              path: 'proprietaire/register',
              name: 'proprietaire_register_vehicule',
              builder: (context, state) => const DemandeVehiculeScreen(),
            ),
            GoRoute(
              path: 'proprietaire/demande-licence',
              name: 'demande_licence',
              builder: (context, state) {
                final vehicule = state.extra as Vehicule;
                return DemandeLicenceScreenSimple(vehicule: vehicule);
              },
            ),
            GoRoute(
              path: 'proprietaire/vehicule',
              name: 'vehicule_detail',
              builder: (context, state) {
                final vehicule = state.extra as Vehicule?;
                if (vehicule == null) {
                  return const Scaffold(
                    body: Center(child: Text('Véhicule manquant')),
                  );
                }
                return VehiculeDetailScreen(vehicule: vehicule);
              },
            ),
            GoRoute(
              path: 'page_paiement',
              name: 'page_paiement',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                final vehicule = extra?['vehicule'] as Vehicule?;
                final typePaiement = extra?['typePaiement'] as String? ?? 'adhesion';
                final motif = extra?['motif'] as String? ?? 'Paiement adhésion';
                return PagePaiementScreen(
                  vehicule: vehicule,
                  motif: motif,
                  typePaiement: typePaiement,
                );
              },
            ),
           
            GoRoute(
              path: 'cooperative',
              name: 'cooperative',
              builder: (context, state) {
                final id = (state.extra as Map<String, dynamic>?)?['cooperativeId'];
                if (id == null) {
                  return const Scaffold(
                    body: Center(child: Text('Erreur: ID de coopérative manquant.')),
                  );
                }
                return DashboardCooperativeScreen(cooperativeId: id);
              },
              routes: [
                GoRoute(
                  path: 'affectation-detail',
                  name: 'affectation_detail',
                  builder: (context, state) {
                    final affectation = state.extra as Affectation?;
                    if (affectation == null) {
                      return const Scaffold(
                        body: Center(child: Text('Erreur: Détails de l\'affectation manquants.')),
                      );
                    }
                    return AffectationDetailScreen(affectation: affectation);
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'cooperative_pending',
              name: 'cooperative_pending',
              builder: (context, state) {
                final cooperative = state.extra as Map<String, dynamic>?;
                if (cooperative == null) {
                  return const Scaffold(
                    body: Center(child: Text('Erreur: coopérative non trouvée')),
                  );
                }
                return CooperativePendingScreen(cooperative: cooperative);
              },
            ),
            GoRoute(
              path: 'cooperative_rejected',
              name: 'cooperative_rejected',
              builder: (context, state) => CooperativeRejectedScreen(),
            ),
            GoRoute(
              path: 'cooperative-register',
              name: 'cooperative_register',
              builder: (context, state) => const CooperativeRegisterScreen(),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) =>
          const Scaffold(body: Center(child: Text('Erreur: Page introuvable'))),
    );
  }
}

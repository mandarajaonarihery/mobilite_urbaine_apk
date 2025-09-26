// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get landingTitle => 'Modernisez la Gestion du Transport Urbain';

  @override
  String get landingWelcome => 'Une solution complète pour les coopératives, propriétaires et agents municipaux pour une supervision efficace et transparente.';

  @override
  String get landingLogin => 'Accéder à la plateforme';

  @override
  String get featuresTitle => 'Une solution pour chaque acteur';

  @override
  String get feature1Title => 'Gestion Simplifiée pour Coopératives';

  @override
  String get feature1Desc => 'Suivez vos véhicules, gérez vos membres et optimisez vos opérations quotidiennes depuis une seule interface.';

  @override
  String get feature2Title => 'Supervision pour la Commune';

  @override
  String get feature2Desc => 'Accédez à des données fiables, contrôlez les licences et assurez le respect des réglementations pour un transport plus sûr.';

  @override
  String get feature3Title => 'Outils pour Agents et Propriétaires';

  @override
  String get feature3Desc => 'Facilitez la collecte des paiements, la gestion des parkings et la communication entre tous les acteurs du secteur.';

  @override
  String get seeMap => 'Explorer la carte';

  @override
  String get feature4Title => 'Carte Interactive en Temps Réel';

  @override
  String get feature4Desc => 'Visualisez les itinéraires, localisez les véhicules et suivez le trafic en direct sur une carte facile à utiliser.';

  @override
  String get loginWelcome => 'Bienvenue';

  @override
  String get loginSubtitle => 'Connectez-vous à votre espace mobilité';

  @override
  String get emailLabel => 'Adresse email';

  @override
  String get emailValidation => 'Veuillez entrer votre email';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordValidation => 'Veuillez entrer votre mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginFailed => 'Échec de la connexion. Veuillez vérifier vos identifiants.';

  @override
  String get error => 'Erreur';

  @override
  String get demoInfo => 'Mode démo : utilisez n\'importe quel email et mot de passe';
}

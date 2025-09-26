Map<String, dynamic> scanDonnee(Map<String, dynamic> rawData) {
  if (rawData['data'] == null || rawData['data'].isEmpty) {
    return {
      "vehicle": {"immatriculation": "N/A", "typeTransport": "N/A"},
      "driver": {"email": "N/A", "numPhone": "N/A", "numPermis": "N/A"},
      "owner": {"nom": "N/A", "prenom": "N/A"},
      "cooperative": {"name": "N/A"},
      "documents": [],
      "licence": {"num_licence": "N/A", "date_expiration": "N/A", "eligibilite": "N/A"},
    };
  }

  final data = rawData['data'][0];

  // VEHICULE
  final vehicle = {
    "immatriculation": data['immatriculation'] ?? "N/A",
    "typeTransport": data['typeTransport']?['nom'] ?? "N/A",
  };

  // CHAUFFEUR
  final chauffeur = data['affectation']?['chauffeur'] ?? {};
  final driver = {
    "email": chauffeur['email_chauffeur'] ?? "N/A",
    "numPhone": chauffeur['numPhon_chauffeur'] ?? "N/A",
    "numPermis": chauffeur['numPermis_chauffeur'] ?? "N/A",
  };

  // PROPRIETAIRE
  final citizen = data['citizen'] ?? {};
  final owner = {
    "nom": citizen['nom_proprietaire'] ?? "N/A",
    "prenom": citizen['prenom_proprietaire'] ?? "N/A",
  };

  // COOPERATIVE
  final cooperativeData = data['affectation']?['cooperative'] ?? {};
  final cooperative = {
    "name": cooperativeData['name_cooperative'] ?? "N/A",
  };

  // DOCUMENTS
  final allowedTypes = ['assurance', 'cartegrise', 'visite_technique'];
  final documents = (data['documents'] as List? ?? [])
      .where((doc) => allowedTypes.contains(doc['type']?.toLowerCase()))
      .map((doc) => {
            "type": doc['type'] ?? "Inconnu",
            "expiration": doc['date_expiration'] ?? "aucune",
          })
      .toList();


  // LICENCE
  final licenceData = data['licence'] ?? {};
  final licence = {
    "num_licence": licenceData['num_licence'] ?? "N/A",
    "date_expiration": licenceData['date_expiration'] ?? "N/A",
    "eligibilite": licenceData['eligibilite'] ?? "N/A",
  };

  return {
    "vehicle": vehicle,
    "driver": driver,
    "owner": owner,
    "cooperative": cooperative,
    "documents": documents,
    "licence": licence,
  };
}
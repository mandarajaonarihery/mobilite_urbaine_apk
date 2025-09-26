class Chauffeur {
  final int? id;
  final String? numPhonChauffeur;
  final String? numPermisChauffeur;
  final String? categoriPermis;
  final int? municipalityId;
  final String? cityzenId;

  // Données citoyen
  final String? nom; // alias
  final String? prenom; // alias
  final String? cin; // alias pour carteIdentiteNationnal
  final String? photo; // alias pour photoChauffeur
  final String? adresse;

  // Image permis chauffeur
  final String? permisImage;

  Chauffeur({
    this.id,
    this.numPhonChauffeur,
    this.numPermisChauffeur,
    this.categoriPermis,
    this.municipalityId,
    this.cityzenId,
    this.nom,
    this.prenom,
    this.cin,
    this.photo,
    this.adresse,
    this.permisImage,
  });

  factory Chauffeur.fromJson(Map<String, dynamic> json) {
    // si l’API renvoie citizen imbriqué
    final citizen = json['citizen'] ?? {};

    return Chauffeur(
      id: json['id'],
      numPhonChauffeur: json['numPhon_chauffeur'],
      numPermisChauffeur: json['numPermis_chauffeur'],
      categoriPermis: json['categori_permis'],
      municipalityId: json['municipality_id'],
      cityzenId: json['cityzen_id'],

      // alias
      nom: citizen['nom_chauffeur'] ?? json['nom_chauffeur'],
      prenom: citizen['prenom_chauffeur'] ?? json['prenom_chauffeur'],
      cin: citizen['carte_identite_nationnal']?.toString() ??
          json['carte_identite_nationnal']?.toString(),
      photo: citizen['photo_chauffeur'] ?? json['photo_chauffeur'],
      adresse: citizen['adresse'] ?? json['adresse'],
      permisImage: json['permis_image'], // permis image direct
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numPhon_chauffeur': numPhonChauffeur,
      'numPermis_chauffeur': numPermisChauffeur,
      'categori_permis': categoriPermis,
      'municipality_id': municipalityId,
      'cityzen_id': cityzenId,
      'permis_image': permisImage,
      'citizen': {
        'nom_chauffeur': nom,
        'prenom_chauffeur': prenom,
        'carte_identite_nationnal': cin,
        'photo_chauffeur': photo,
        'adresse': adresse,
      }
    };
  }
}

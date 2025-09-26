class Licence {
  final String? numLicence;
  final String? immatriculation;
  final String? duree;
  final String? dateExpiration;
  final String? statusApprobation;
  final String? statusPaiement; // <-- ajouter ce champ
  final String? eligibilite;
  final int? municipalityId;

  Licence({
    this.numLicence,
    this.immatriculation,
    this.duree,
    this.dateExpiration,
    this.statusApprobation,
    this.statusPaiement, // <-- ajouté
    this.eligibilite,
    this.municipalityId,
  });

  factory Licence.fromJson(Map<String, dynamic> json) => Licence(
        numLicence: json['num_licence'] as String?,
        immatriculation: json['immatriculation'] as String?,
        duree: json['duree'] as String?,
        dateExpiration: json['date_expiration'] as String?,
        statusApprobation: json['status_approbation'] as String?,
        statusPaiement: json['status_paiement'] as String?, // <-- ajouté
        eligibilite: json['eligibilite'] as String?,
        municipalityId: json['municipality_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'num_licence': numLicence,
        'immatriculation': immatriculation,
        'duree': duree,
        'date_expiration': dateExpiration,
        'status_approbation': statusApprobation,
        'status_paiement': statusPaiement, // <-- ajouté
        'eligibilite': eligibilite,
        'municipality_id': municipalityId,
      };
}

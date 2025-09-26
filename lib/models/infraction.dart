class Infraction {
  final int agentId;
  final String? numeroTelephone;
  final String immatriculation;
  final String typeInfraction;
  final String description;
  final double montantAmende;
  final String statut;
  final DateTime dateInfraction;
  final bool? payee;
  final int? municipalityId; // 🔹 Ajouté

  Infraction({
    required this.agentId,
    this.numeroTelephone,
    required this.immatriculation,
    required this.typeInfraction,
    required this.description,
    required this.montantAmende,
    required this.statut,
    required this.dateInfraction,
    this.payee,
    this.municipalityId, // 🔹 Ajouté
  });

  Map<String, dynamic> toJson() {
    return {
      "agent_id": agentId,
      if (numeroTelephone != null) "numero_telephone": numeroTelephone,
      "immatriculation": immatriculation,
      "type_infraction": typeInfraction,
      "description": description,
      "montant_amende": montantAmende,
      "statut": statut,
      "date_infraction": dateInfraction.toIso8601String(),
      if (payee != null) "payee": payee,
      if (municipalityId != null) "municipality_id": municipalityId, // 🔹
    };
  }

  factory Infraction.fromJson(Map<String, dynamic> json) {
    return Infraction(
      agentId: json['agent_id'] ?? 0,
      numeroTelephone: json['numero_telephone'],
      immatriculation: json['immatriculation'] ?? '',
      typeInfraction: json['type_infraction'] ?? '',
      description: json['description'] ?? '',
      montantAmende: (json['montant_amende'] ?? 0).toDouble(),
      statut: json['statut'] ?? '',
      dateInfraction: DateTime.tryParse(json['date_infraction'] ?? '') ?? DateTime.now(),
      payee: json['payee'],
      municipalityId: json['municipality_id'], // 🔹
    );
  }
}

class Stop {
  final int id;
  final String name;
  final List<double> coordinates;
  final String description;
  final String ligneId;
  final int municipalityId;
  final String createdAt;
  final String updatedAt;

  Stop({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.description,
    required this.ligneId,
    required this.municipalityId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      id: json['id'],
      name: json['name'],
      coordinates: List<double>.from(json['coordinates'].map((x) => x?.toDouble())),
      description: json['description'],
      ligneId: json['ligneId'],
      municipalityId: json['municipality_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
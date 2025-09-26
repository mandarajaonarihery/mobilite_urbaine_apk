class TypeTransport {
  final int id;
  final String? nom;

  TypeTransport({
    required this.id,
    this.nom,
  });

  factory TypeTransport.fromJson(Map<String, dynamic> json) {
    return TypeTransport(
      id: json['id'] as int,
      nom: json['nom'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
    };
  }
}
    
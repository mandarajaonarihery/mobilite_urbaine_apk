class Document {
  final int id;
  final String? type;
  final String? status;
  final String? fichierRecto;

  Document({
    required this.id,
    this.type,
    this.status,
    this.fichierRecto,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as int,
      type: json['type'] as String?,
      status: json['status'] as String?,
      fichierRecto: json['fichier_recto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'status': status,
      'fichier_recto': fichierRecto,
    };
  }
}

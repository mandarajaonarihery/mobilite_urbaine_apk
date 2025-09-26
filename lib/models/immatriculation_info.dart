// lib/models/immatriculation_info.dart

class ImmatriculationInfo {
  final String? immatriculation;
  final String? idCitizen;

  ImmatriculationInfo({this.immatriculation, this.idCitizen});

  factory ImmatriculationInfo.fromJson(Map<String, dynamic> json) {
    return ImmatriculationInfo(
      immatriculation: json['immatriculation'] as String?,
      idCitizen: json['id_citizen'] as String?,
    );
  }
}
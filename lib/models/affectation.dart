// lib/models/affectation.dart
import 'package:all_pnud/models/chauffeur.dart';
import 'package:all_pnud/models/vehicule.dart';
import 'package:all_pnud/models/cooperative.dart';

class Affectation {
  final int? id;
  final int? idChauffeur;
  final String? immatriculation;
  final int? idCooperative;
  final String? statusCoop;
  final String? createdAt;
  final String? updatedAt;
  final Chauffeur? chauffeur;
  final Vehicule? vehicule;
  final Cooperative? cooperative;

  Affectation({
    this.id,
    this.idChauffeur,
    this.immatriculation,
    this.idCooperative,
    this.statusCoop,
    this.createdAt,
    this.updatedAt,
    this.chauffeur,
    this.vehicule,
    this.cooperative,
  });

  factory Affectation.fromJson(Map<String, dynamic> json) {
    return Affectation(
      id: json['id'] as int?,
      idChauffeur: json['id_chauffeur'] as int?,
      immatriculation: json['immatriculation'] as String?,
      idCooperative: json['id_cooperative'] as int?,
      statusCoop: json['status_coop'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      chauffeur: json['chauffeur'] != null
          ? Chauffeur.fromJson(json['chauffeur'])
          : null,
      vehicule: json['vehicule'] != null
          ? Vehicule.fromJson(json['vehicule'])
          : null,
      cooperative: json['cooperative'] != null
          ? Cooperative.fromJson(json['cooperative'])
          : null,
    );
  }

  // copyWith pour mettre à jour statusCoop
  Affectation copyWith({String? statusCoop}) {
    return Affectation(
      id: id,
      idChauffeur: idChauffeur,
      immatriculation: immatriculation,
      idCooperative: idCooperative,
      statusCoop: statusCoop ?? this.statusCoop,
      createdAt: createdAt,
      updatedAt: updatedAt,
      chauffeur: chauffeur,
      vehicule: vehicule,
      cooperative: cooperative,
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_chauffeur': idChauffeur,
      'immatriculation': immatriculation,
      'id_cooperative': idCooperative,
      'status_coop': statusCoop,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'chauffeur': chauffeur?.toJson(),
      'vehicule': vehicule?.toJson(),
      'cooperative': cooperative?.toJson(),
    };
  }
}

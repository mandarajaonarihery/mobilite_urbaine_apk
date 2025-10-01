// lib/models/vehicule.dart
import 'affectation.dart';
import 'type_transport.dart';
import 'document.dart';
import 'infraction.dart';
import 'licence.dart'; // Ton nouveau modèle

class Vehicule {
  final String? immatriculation;
  final String? idCitizen;
  final int? typetransportId;
  final String? municipalityId;
  final String? emailProprietaire;
  final String? status;
  final String? numLicence;
  final String? createdAt;
  final String? updatedAt;
  final Affectation? affectation;
  final TypeTransport? typeTransport;
  final List<Document>? documents;
  final Infraction? infraction;
  final String? dateDescente;
  final String? statusDateDescente;
  final String? motifRefus;

  // Nouveau champ
  final Licence? licence;

  Vehicule({
    this.immatriculation,
    this.idCitizen,
    this.typetransportId,
    this.municipalityId,
     this.dateDescente,
    this.emailProprietaire,
    this.statusDateDescente,
    this.motifRefus,
    this.status,
    this.numLicence,
    this.createdAt,
    this.updatedAt,
    this.affectation,
    this.typeTransport,
    this.documents,
    this.infraction,
    this.licence, // <-- ajouté ici
    
    
    
  });

  factory Vehicule.fromJson(Map<String, dynamic> json) {
    return Vehicule(
      immatriculation: json['immatriculation'] as String?,
      idCitizen: json['id_citizen'] as String?,
        dateDescente: json['date_descente'] as String?,
      typetransportId: json['typetransport_id'] as int?,
      statusDateDescente: json['status_date_descente'] as String?,
      municipalityId: json['municipality_id'] as String?,
      emailProprietaire: json['email_prop'] as String?,
      motifRefus: json['motif_refus'] as String?, 
      status: json['status'] as String?,
      numLicence: json['num_licence'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      affectation: json['affectation'] != null
          ? Affectation.fromJson(json['affectation'])
          : null,
      typeTransport: json['typeTransport'] != null
          ? TypeTransport.fromJson(json['typeTransport'])
          : null,
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => Document.fromJson(e))
          .toList(),
      infraction: json['infraction'] != null
          ? Infraction.fromJson(json['infraction'])
          : null,
      licence: json['licence'] != null
          ? Licence.fromJson(json['licence'])
          : null, // <-- Map la licence ici
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'immatriculation': immatriculation,
      'id_citizen': idCitizen,
      'typetransport_id': typetransportId,
      'municipality_id': municipalityId,
      'email_prop': emailProprietaire,
      'status': status,
      'num_licence': numLicence,
      'motif_refus': motifRefus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'affectation': affectation?.toJson(),
      'typeTransport': typeTransport?.toJson(),
      'documents': documents?.map((e) => e.toJson()).toList(),
      'infraction': infraction?.toJson(),
        'date_descente': dateDescente,
      'status_date_descente': statusDateDescente, // <-- ajouté ici
      'licence': licence?.toJson(), // <-- ajouté ici
    };
  }
}

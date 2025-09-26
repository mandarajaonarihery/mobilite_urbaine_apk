import 'dart:convert';
import 'Cooperative.dart';
import 'Stop.dart';

class Ligne {
  final int id;
  final String nom;
  final int municipalityId;
  final String couleur;
  final List<List<double>> trace;
  final int cooperativeId;
  final String createdAt;
  final String updatedAt;
  final Cooperative cooperative;
  final List<Stop> stops;

  Ligne({
    required this.id,
    required this.nom,
    required this.municipalityId,
    required this.couleur,
    required this.trace,
    required this.cooperativeId,
    required this.createdAt,
    required this.updatedAt,
    required this.cooperative,
    required this.stops,
  });

  factory Ligne.fromJson(Map<String, dynamic> json) {
    return Ligne(
      id: json['id'],
      nom: json['nom'],
      municipalityId: json['municipality_id'],
      couleur: json['couleur'],
      trace: List<List<double>>.from(json['tracé'].map((x) => List<double>.from(x.map((y) => y?.toDouble())))),
      cooperativeId: json['cooperativeId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      cooperative: Cooperative.fromJson(json['cooperative']),
      stops: List<Stop>.from(json['stops'].map((x) => Stop.fromJson(x))),
    );
  }
}
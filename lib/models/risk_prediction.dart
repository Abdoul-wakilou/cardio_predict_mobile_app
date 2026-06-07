// lib/models/risk_prediction.dart
import 'package:flutter/material.dart';

class RiskPrediction {
  final int niveauRisque;
  final String libelle;
  final String description;
  final List<String> conseils;
  final double? probabilityDisease;
  final double? probabilityNoDisease;
  final String? riskCategory;
  final Map<String, dynamic>? rawResponse;

  const RiskPrediction({
    required this.niveauRisque,
    required this.libelle,
    required this.description,
    required this.conseils,
    this.probabilityDisease,
    this.probabilityNoDisease,
    this.riskCategory,
    this.rawResponse,
  });

  /// Couleur associée au niveau de risque
  Color get color {
    switch (niveauRisque) {
      case 0:
        return Colors.green;
      case 1:
        return Colors.lightGreen;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.deepOrange;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Libellé textuel du niveau de risque
  String get niveauText {
    switch (niveauRisque) {
      case 0:
        return 'Aucun risque';
      case 1:
        return 'Risque faible';
      case 2:
        return 'Risque modéré';
      case 3:
        return 'Risque élevé';
      case 4:
        return 'Risque très élevé';
      default:
        return 'Inconnu';
    }
  }

  /// Probabilité de maladie en pourcentage (format texte)
  String get probabilityDiseasePercent {
    if (probabilityDisease != null) {
      return '${(probabilityDisease! * 100).toStringAsFixed(1)}%';
    }
    return 'N/A';
  }

  /// Probabilité d'être sain en pourcentage (format texte)
  String get probabilityNoDiseasePercent {
    if (probabilityNoDisease != null) {
      return '${(probabilityNoDisease! * 100).toStringAsFixed(1)}%';
    }
    return 'N/A';
  }

  /// Crée une copie du modèle avec des champs modifiés
  RiskPrediction copyWith({
    int? niveauRisque,
    String? libelle,
    String? description,
    List<String>? conseils,
    double? probabilityDisease,
    double? probabilityNoDisease,
    String? riskCategory,
    Map<String, dynamic>? rawResponse,
  }) {
    return RiskPrediction(
      niveauRisque: niveauRisque ?? this.niveauRisque,
      libelle: libelle ?? this.libelle,
      description: description ?? this.description,
      conseils: conseils ?? this.conseils,
      probabilityDisease: probabilityDisease ?? this.probabilityDisease,
      probabilityNoDisease: probabilityNoDisease ?? this.probabilityNoDisease,
      riskCategory: riskCategory ?? this.riskCategory,
      rawResponse: rawResponse ?? this.rawResponse,
    );
  }

  /// Crée une instance par défaut (pour les cas d'erreur ou chargement)
  factory RiskPrediction.defaultPrediction() {
    return const RiskPrediction(
      niveauRisque: 0,
      libelle: 'Non disponible',
      description: 'Aucune donnée de prédiction',
      conseils: ['Veuillez effectuer une nouvelle analyse'],
      probabilityDisease: null,
      probabilityNoDisease: null,
      riskCategory: 'Inconnu',
      rawResponse: null,
    );
  }

  @override
  String toString() {
    return 'RiskPrediction(niveauRisque: $niveauRisque, libelle: $libelle, '
        'probabilityDisease: $probabilityDisease, conseils: ${conseils.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RiskPrediction &&
        other.niveauRisque == niveauRisque &&
        other.libelle == libelle &&
        other.description == description &&
        other.probabilityDisease == probabilityDisease;
  }

  @override
  int get hashCode {
    return Object.hash(niveauRisque, libelle, description, probabilityDisease);
  }
}
import 'package:flutter/material.dart';

class RiskPrediction {
  final int niveauRisque;
  final String libelle;
  final String description;
  final List<String> conseils;

  // Nouvelles propriétés
  final double? probabilityDisease;
  final double? probabilityNoDisease;
  final String? riskCategory;
  final Map<String, dynamic>? rawResponse;

  RiskPrediction({
    required this.niveauRisque,
    required this.libelle,
    required this.description,
    required this.conseils,
    this.probabilityDisease,
    this.probabilityNoDisease,
    this.riskCategory,
    this.rawResponse,
  });

  Color get color {
    switch (niveauRisque) {
      case 0: return Colors.green;
      case 1: return Colors.lightGreen;
      case 2: return Colors.orange;
      case 3: return Colors.deepOrange;
      case 4: return Colors.red;
      default: return Colors.grey;
    }
  }

  String get niveauText {
    switch (niveauRisque) {
      case 0: return 'Aucun risque';
      case 1: return 'Risque faible';
      case 2: return 'Risque modéré';
      case 3: return 'Risque élevé';
      case 4: return 'Risque très élevé';
      default: return 'Inconnu';
    }
  }
}
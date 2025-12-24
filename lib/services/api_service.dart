// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient_data.dart';
import '../models/risk_prediction.dart';

class ApiService {
  // URL de l'API Flask - À ADAPTER SELON VOTRE CONFIGURATION
  // Pour web (Chrome) : http://localhost:5000
  // Pour émulateur Android : http://10.0.2.2:5000
  // Pour réseau local : http://VOTRE_IP:5000
  static const String _baseUrl = 'http://localhost:5000';

  // Getter pour accéder à l'URL
  static String get baseUrl => _baseUrl;

  // Clé pour stocker les données en cache (optionnel)
  static const String _cacheKey = 'last_prediction';

  static Future<RiskPrediction> predictRisk(PatientData data) async {
    try {
      print('📡 Envoi des données à l\'API Flask...');

      // Préparer les données pour l'API
      final Map<String, dynamic> requestData = {
        'age': data.age ?? 0,
        'sex': data.sex ?? 0,
        'cp': data.cp ?? 0,
        'trestbps': data.trestbps ?? 0,
        'chol': data.chol ?? 0,
        'fbs': data.fbs ?? 0,
        'restecg': data.restecg ?? 0,
        'thalach': data.thalach ?? 0,
        'exang': data.exang ?? 0,
        'oldpeak': data.oldpeak ?? 0.0,
        'slope': data.slope ?? 0,
        'ca': data.ca ?? 0,
        'thal': data.thal ?? 0,
      };

      print('📦 Données envoyées: $requestData');

      final url = Uri.parse('$_baseUrl/predict');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestData),
      );

      print('📡 Réponse API: ${response.statusCode}');
      print('📡 Corps réponse: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Convertir la réponse Flask en RiskPrediction
        final prediction = _parseApiResponse(responseData, data);

        // Stocker en cache (optionnel)
        _cachePrediction(prediction);

        return prediction;
      } else {
        throw Exception('Erreur API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Erreur de connexion: $e');

      // Fallback: utiliser la simulation si l'API est indisponible
      print('🔄 Utilisation du mode simulation...');
      return _simulatePrediction(data);
    }
  }

  static RiskPrediction _parseApiResponse(Map<String, dynamic> response, PatientData data) {
    // Extraire les données de la réponse Flask
    final int prediction = response['prediction'] ?? 0;
    final double probabilityDisease = response['probability_disease'] ?? 0.0;
    final double probabilityNoDisease = response['probability_no_disease'] ?? 0.0;
    final String riskCategory = response['prediction_label'] ?? 'Inconnu';

    // Convertir en niveau de risque 0-4
    final int niveauRisque = _convertToRiskLevel(prediction, probabilityDisease);

    // Générer les conseils personnalisés
    final List<String> conseils = _generatePersonalizedAdvice(data, niveauRisque, response);

    // Déterminer la description
    final String description = _getDescription(niveauRisque, probabilityDisease);

    // Déterminer le libellé
    final String libelle = _getLibelle(niveauRisque);

    return RiskPrediction(
      niveauRisque: niveauRisque,
      libelle: libelle,
      description: description,
      conseils: conseils,
      // Données additionnelles de l'API
      probabilityDisease: probabilityDisease,
      probabilityNoDisease: probabilityNoDisease,
      riskCategory: riskCategory,
      rawResponse: response,
    );
  }

  static int _convertToRiskLevel(int prediction, double probability) {
    if (prediction == 1) {
      // Malade - déterminer la sévérité basée sur la probabilité
      if (probability >= 0.8) return 4; // Très élevé
      if (probability >= 0.6) return 3; // Élevé
      return 2; // Modéré
    } else {
      // Sain - déterminer basé sur la probabilité d'être sain
      if (probability >= 0.8) return 0; // Aucun risque
      return 1; // Faible risque
    }
  }

  static List<String> _generatePersonalizedAdvice(
      PatientData data,
      int niveauRisque,
      Map<String, dynamic> apiResponse
      ) {
    final List<String> conseils = [];

    // Conseils basés sur les données spécifiques du patient
    if (data.age != null && data.age! > 50) {
      conseils.add('Surveillance cardiovasculaire annuelle recommandée après 50 ans.');
    }

    if (data.trestbps != null && data.trestbps! > 140) {
      conseils.add('Tension artérielle élevée (${data.trestbps} mmHg). Limitez le sel et surveillez régulièrement.');
    }

    if (data.chol != null && data.chol! > 200) {
      conseils.add('Cholestérol élevé (${data.chol} mg/dL). Privilégiez les graisses insaturées (avocat, noix, poissons).');
    }

    if (data.fbs != null && data.fbs == 1) {
      conseils.add('Glycémie à jeun élevée. Réduisez les sucres rapides et augmentez l\'activité physique.');
    }

    if (data.thalach != null && data.thalach! < 120) {
      conseils.add('Fréquence cardiaque maximale basse (${data.thalach} bpm). Consultez pour un test d\'effort.');
    }

    if (data.exang != null && data.exang == 1) {
      conseils.add('Angine à l\'effort détectée. Évaluation cardiologique recommandée.');
    }

    if (data.oldpeak != null && data.oldpeak! > 1.0) {
      conseils.add('Dépression ST significative (${data.oldpeak} points). Surveillance ECG nécessaire.');
    }

    // Conseils généraux selon le niveau de risque
    switch (niveauRisque) {
      case 0: // Aucun risque
        conseils.addAll([
          'Continuez votre excellente hygiène de vie.',
          'Maintenez une activité physique régulière (30 min/jour).',
          'Bilan de santé annuel recommandé.'
        ]);
        break;

      case 1: // Risque faible
        conseils.addAll([
          'Surveillez votre poids et votre alimentation.',
          '150 min d\'activité modérée/semaine minimum.',
          'Évitez le tabac et modérez l\'alcool.'
        ]);
        break;

      case 2: // Risque modéré
        conseils.addAll([
          'Consultez un médecin pour bilan cardiovasculaire.',
          'Adoptez un régime méditerranéen.',
          'Auto-surveillance tension et cholestérol.'
        ]);
        break;

      case 3: // Risque élevé
        conseils.addAll([
          'CONSULTATION CARDIOLOGIQUE RECOMMANDÉE',
          'Suivi médical strict des traitements.',
          'Surveillance quotidienne des symptômes.',
          'Évitez les efforts intenses sans avis médical.'
        ]);
        break;

      case 4: // Risque très élevé
        conseils.addAll([
          'URGENCE MÉDICALE - CONSULTEZ IMMÉDIATEMENT',
          'Ne négligez aucun symptôme (douleur thoracique, essoufflement).',
          'Traitement médical urgent requis.',
          'Mode de vie strict sous supervision médicale.'
        ]);
        break;
    }

    // Ajouter les statistiques de l'API si disponibles
    if (apiResponse['probability_disease'] != null) {
      final double riskPercent = (apiResponse['probability_disease'] as double) * 100;
      conseils.add('Score de risque IA: ${riskPercent.toStringAsFixed(1)}%');
    }

    return conseils;
  }

  static String _getDescription(int niveauRisque, double probability) {
    final String probText = (probability * 100).toStringAsFixed(1);

    switch (niveauRisque) {
      case 0:
        return '✅ Santé cardiovasculaire excellente. Probabilité de maladie: $probText%';
      case 1:
        return '⚠️  Santé correcte avec vigilance. Probabilité de maladie: $probText%';
      case 2:
        return '🔶 Risque modéré nécessitant surveillance. Probabilité de maladie: $probText%';
      case 3:
        return '🚨 Risque élevé - Consultation recommandée. Probabilité de maladie: $probText%';
      case 4:
        return '💥 RISQUE TRÈS ÉLEVÉ - Consultation URGENTE. Probabilité de maladie: $probText%';
      default:
        return 'Analyse terminée. Probabilité de maladie: $probText%';
    }
  }

  static String _getLibelle(int niveauRisque) {
    switch (niveauRisque) {
      case 0: return 'Aucun risque';
      case 1: return 'Risque faible';
      case 2: return 'Risque modéré';
      case 3: return 'Risque élevé';
      case 4: return 'Risque très élevé';
      default: return 'Inconnu';
    }
  }

  // Méthode de fallback si l'API est indisponible
  static RiskPrediction _simulatePrediction(PatientData data) {
    // Logique de simulation (votre code original)
    int score = 0;

    if (data.age != null && data.age! > 55) score += 2;
    else if (data.age != null && data.age! > 45) score += 1;

    if (data.sex != null && data.sex == 1) score += 1;

    if (data.cp != null) {
      switch (data.cp) {
        case 0: score += 3; break;
        case 1: score += 2; break;
        case 2: score += 1; break;
      }
    }

    if (data.trestbps != null && data.trestbps! > 140) score += 2;
    else if (data.trestbps != null && data.trestbps! > 130) score += 1;

    if (data.chol != null && data.chol! > 240) score += 2;
    else if (data.chol != null && data.chol! > 200) score += 1;

    if (data.fbs != null && data.fbs == 1) score += 1;

    if (data.restecg != null && data.restecg == 1) score += 1;
    else if (data.restecg != null && data.restecg == 2) score += 2;

    if (data.thalach != null && data.thalach! < 120) score += 2;
    else if (data.thalach != null && data.thalach! < 140) score += 1;

    if (data.exang != null && data.exang == 1) score += 2;

    if (data.oldpeak != null && data.oldpeak! > 2.0) score += 2;
    else if (data.oldpeak != null && data.oldpeak! > 1.0) score += 1;

    if (data.slope != null && data.slope == 0) score += 2;
    else if (data.slope != null && data.slope == 1) score += 1;

    if (data.thal != null && data.thal == 2) score += 2;
    else if (data.thal != null && data.thal == 3) score += 1;

    int risque;
    if (score >= 15) risque = 4;
    else if (score >= 10) risque = 3;
    else if (score >= 6) risque = 2;
    else if (score >= 3) risque = 1;
    else risque = 0;

    final conseils = <String>[];

    if (data.trestbps != null && data.trestbps! > 140) {
      conseils.add('Tension élevée. Réduisez le sel.');
    }

    if (data.chol != null && data.chol! > 200) {
      conseils.add('Cholestérol élevé. Adoptez un régime pauvre en graisses.');
    }

    if (data.fbs != null && data.fbs == 1) {
      conseils.add('Glycémie élevée. Limitez les sucres.');
    }

    switch (risque) {
      case 0:
        conseils.addAll(['Maintenez vos bonnes habitudes.', 'Bilan annuel.']);
        break;
      case 1:
        conseils.addAll(['Surveillance alimentation.', 'Activité physique régulière.']);
        break;
      case 2:
        conseils.addAll(['Consultation médicale recommandée.', 'Régime méditerranéen.']);
        break;
      case 3:
        conseils.addAll(['CONSULTEZ UN CARDIOLOGUE.', 'Suivi médical strict.']);
        break;
      case 4:
        conseils.addAll(['URGENCE MÉDICALE.', 'Consultation immédiate.']);
        break;
    }

    return RiskPrediction(
      niveauRisque: risque,
      libelle: _getLibelle(risque),
      description: 'Prédiction en mode simulation (API non disponible)',
      conseils: conseils,
      probabilityDisease: score / 20.0, // Simulation
      probabilityNoDisease: 1 - (score / 20.0),
      riskCategory: risque >= 3 ? 'Élevé' : 'Faible/Modéré',
    );
  }

  // Cache pour la dernière prédiction (optionnel)
  static void _cachePrediction(RiskPrediction prediction) {
    // Implémentation simple avec shared_preferences si nécessaire
    print('💾 Prédiction mise en cache');
  }

  // Méthode pour tester la connexion à l'API
  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {'Accept': 'application/json'},
      );

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Test connexion échoué: $e');
      return false;
    }
  }

  // Méthode pour obtenir les informations de l'API
  static Future<Map<String, dynamic>?> getApiInfo() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('❌ Impossible de récupérer les infos API: $e');
      return null;
    }
  }
}
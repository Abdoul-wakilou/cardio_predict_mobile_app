import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/patient_data.dart';
import '../models/risk_prediction.dart';

class ApiService {
  // URL de base dynamique selon la plateforme
  static String get _baseUrl {
    if (kIsWeb) {
      // Navigateur web (Chrome, Edge, etc.)
      return 'http://localhost:5000';
    } else {
      // Émulateur Android ou appareil physique
      return 'http://10.0.2.2:5000';
    }
  }

  static String get baseUrl => _baseUrl;

  static Future<RiskPrediction> predictRisk(PatientData data) async {
    try {
      print('📡 Envoi des données à l\'API Flask...');
      print('📍 URL: $baseUrl/predict');
      print('🌐 Plateforme: ${kIsWeb ? "Web (Chrome)" : "Mobile"}');

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

      final url = Uri.parse('$baseUrl/predict');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestData),
      ).timeout(const Duration(seconds: 10));

      print('📡 Réponse API: ${response.statusCode}');
      print('📡 Corps réponse: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData.containsKey('error')) {
          throw Exception('Erreur API: ${responseData['error']}');
        }
        
        final prediction = _parseApiResponse(responseData);
        return prediction;
      } else {
        throw Exception('Erreur API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Erreur de connexion: $e');
      rethrow;
    }
  }

  static RiskPrediction _parseApiResponse(Map<String, dynamic> response) {
    final int prediction = response['prediction'] ?? 0;
    final double probabilityDisease = response['probability_disease'] ?? 0.0;
    final double probabilityNoDisease = response['probability_no_disease'] ?? 0.0;
    final int riskLevel = response['risk_level'] ?? 0;
    final String riskLabel = response['risk_label'] ?? 'Inconnu';
    final String riskDescription = response['risk_description'] ?? '';
    final String predictionLabel = response['prediction_label'] ?? 'Inconnu';
    
    final List<String> recommendations = (response['recommendations'] as List?)
        ?.map((e) => e.toString())
        .toList() ?? [];

    return RiskPrediction(
      niveauRisque: riskLevel,
      libelle: riskLabel,
      description: riskDescription,
      conseils: recommendations,
      probabilityDisease: probabilityDisease,
      probabilityNoDisease: probabilityNoDisease,
      riskCategory: predictionLabel,
      rawResponse: response,
    );
  }

  static Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));
      
      print('🔍 Test connexion: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Test connexion échoué: $e');
      return false;
    }
  }
}
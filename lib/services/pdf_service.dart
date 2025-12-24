// lib/services/pdf_service.dart
import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import '../models/risk_prediction.dart';
import '../models/patient_data.dart';

class PdfService {
  static Future<File> generateReport({
    required RiskPrediction prediction,
    required PatientData patientData,
    required DateTime analysisDate,
  }) async {
    // Créer le document PDF
    final pdf = pw.Document();

    // Ajouter une page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // En-tête
            _buildHeader(prediction, analysisDate),
            pw.SizedBox(height: 20),
            
            // Résumé du patient
            _buildPatientSummary(patientData),
            pw.SizedBox(height: 20),
            
            // Résultats de l'analyse
            _buildAnalysisResults(prediction),
            pw.SizedBox(height: 20),
            
            // Conseils personnalisés
            _buildAdviceSection(prediction),
            pw.SizedBox(height: 20),
            
            // Pied de page
            _buildFooter(),
          ];
        },
      ),
    );

    // Sauvegarder le fichier
    return await savePdf(pdf, 'rapport_cardio_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  static pw.Widget _buildHeader(RiskPrediction prediction, DateTime date) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'CardioPredict',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green,
                  ),
                ),
                pw.Text(
                  'Rapport d\'Analyse Cardiaque',
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey,
                  ),
                ),
              ],
            ),
            pw.Container(
              padding: pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: _getRiskColorPdf(prediction.niveauRisque),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(
                prediction.niveauText.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        pw.Divider(height: 20, thickness: 1),
        pw.Text(
          'Date de l\'analyse: ${_formatDate(date)}',
          style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
        ),
      ],
    );
  }

  static pw.Widget _buildPatientSummary(PatientData data) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: pw.EdgeInsets.all(16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Données du Patient',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _buildDataRow('Âge', '${data.age ?? "N/A"} ans'),
              _buildDataRow('Sexe', data.sex == 1 ? 'Homme' : 'Femme'),
              _buildDataRow('Pression artérielle', '${data.trestbps ?? "N/A"} mmHg'),
              _buildDataRow('Cholestérol', '${data.chol ?? "N/A"} mg/dL'),
              _buildDataRow('Glycémie à jeun', data.fbs == 1 ? '> 120 mg/dL' : '≤ 120 mg/dL'),
              _buildDataRow('Fréquence cardiaque max', '${data.thalach ?? "N/A"} bpm'),
              _buildDataRow('Dépression ST', '${data.oldpeak ?? "N/A"} points'),
              _buildDataRow('Angine à l\'effort', data.exang == 1 ? 'Oui' : 'Non'),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildDataRow(String label, String value) {
    return pw.Container(
      width: 200,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey600,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAnalysisResults(RiskPrediction prediction) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: pw.EdgeInsets.all(16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Résultats de l\'Analyse',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green,
            ),
          ),
          pw.SizedBox(height: 12),
          
          // Niveau de risque
          pw.Container(
            padding: pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: _getLightRiskColorPdf(prediction.niveauRisque),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              children: [
                // Icône (simulée avec un cercle)
                pw.Container(
                  width: 40,
                  height: 40,
                  decoration: pw.BoxDecoration(
                    color: _getRiskColorPdf(prediction.niveauRisque),
                    shape: pw.BoxShape.circle,
                  ),
                  child: pw.Center(
                    child: pw.Text(
                      _getRiskSymbol(prediction.niveauRisque),
                      style: pw.TextStyle(
                        fontSize: 20,
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(width: 12),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        prediction.niveauText.toUpperCase(),
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: _getRiskColorPdf(prediction.niveauRisque),
                        ),
                      ),
                      pw.Text(
                        prediction.description,
                        style: pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          pw.SizedBox(height: 16),
          
          // Détails statistiques
          if (prediction.probabilityDisease != null && prediction.probabilityNoDisease != null)
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Statistiques de l\'IA:',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                _buildStatRow('Probabilité de maladie:', '${(prediction.probabilityDisease! * 100).toStringAsFixed(1)}%'),
                _buildStatRow('Probabilité de santé:', '${(prediction.probabilityNoDisease! * 100).toStringAsFixed(1)}%'),
                if (prediction.riskCategory != null)
                  _buildStatRow('Catégorie de risque:', prediction.riskCategory!),
              ],
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildStatRow(String label, String value) {
    return pw.Container(
      margin: pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label),
          pw.Text(
            value,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildAdviceSection(RiskPrediction prediction) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      padding: pw.EdgeInsets.all(16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Recommandations Personnalisées',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green,
            ),
          ),
          pw.SizedBox(height: 12),
          
          ...prediction.conseils.asMap().entries.map((entry) {
            final index = entry.key;
            final conseil = entry.value;
            return pw.Container(
              margin: pw.EdgeInsets.only(bottom: 8),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    margin: pw.EdgeInsets.only(top: 4, right: 8),
                    child: pw.Text(
                      '•',
                      style: pw.TextStyle(fontSize: 16),
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Text(
                      conseil,
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'Informations importantes',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Ce rapport est généré par CardioPredict et fournit une estimation '
            'basée sur les données fournies. Il ne remplace pas une consultation '
            'médicale professionnelle. Consultez toujours un médecin pour un '
            'diagnostic complet.',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
              fontStyle: pw.FontStyle.italic,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Généré le ${_formatDate(DateTime.now())}',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey400,
            ),
          ),
        ],
      ),
    );
  }

  static Future<File> savePdf(pw.Document pdf, String fileName) async {
    final bytes = await pdf.save();
    
    // Obtenir le répertoire de téléchargement
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$fileName';
    
    final file = File(path);
    await file.writeAsBytes(bytes);
    
    return file;
  }

  static Future<void> openFile(File file) async {
    await OpenFile.open(file.path);
  }

  // Helper functions
  static PdfColor _getRiskColorPdf(int niveau) {
    switch (niveau) {
      case 0: return PdfColors.green;
      case 1: return PdfColors.lightGreen;
      case 2: return PdfColors.orange;
      case 3: return PdfColors.orangeAccent; // Alternative à deepOrange
      case 4: return PdfColors.red;
      default: return PdfColors.grey;
    }
  }

  static PdfColor _getLightRiskColorPdf(int niveau) {
    switch (niveau) {
      case 0: return PdfColor.fromInt(0xFFE8F5E9); // Vert très clair
      case 1: return PdfColor.fromInt(0xFFF1F8E9); // Vert clair
      case 2: return PdfColor.fromInt(0xFFFFF3E0); // Orange clair
      case 3: return PdfColor.fromInt(0xFFFBE9E7); // Orange rouge clair
      case 4: return PdfColor.fromInt(0xFFFFEBEE); // Rouge clair
      default: return PdfColors.grey100;
    }
  }

  static String _getRiskSymbol(int niveau) {
    switch (niveau) {
      case 0: return '✓';
      case 1: return '👍';
      case 2: return 'ℹ';
      case 3: return '⚠';
      case 4: return '✗';
      default: return '?';
    }
  }

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} à ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  static Future<File> generateSimpleReport({
  required RiskPrediction prediction,
  required DateTime analysisDate,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return [
          // En-tête
          _buildHeader(prediction, analysisDate),
          pw.SizedBox(height: 20),

          // Résultats de l'analyse
          _buildAnalysisResults(prediction),
          pw.SizedBox(height: 20),

          // Conseils
          _buildAdviceSection(prediction),
          pw.SizedBox(height: 20),

          // Pied de page
          _buildFooter(),
        ];
      },
    ),
  );

  return await savePdf(
    pdf,
    'rapport_cardio_${DateTime.now().millisecondsSinceEpoch}.pdf',
  );
}

}
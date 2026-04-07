// lib/pages/resultats_page.dart
import 'package:flutter/material.dart';
import '../models/risk_prediction.dart';
import '../models/patient_data.dart';
import '../services/pdf_service.dart';

class ResultatsPage extends StatelessWidget {
  final RiskPrediction prediction;
  final PatientData? patientData;

  // Constructeur principal
  const ResultatsPage({
    super.key,
    required this.prediction,
    this.patientData, // Rendons-le optionnel
  });

  // Factory pour gérer le cas null - CORRIGÉ
  factory ResultatsPage.fromPrediction(RiskPrediction? prediction,
      {PatientData? patientData}) {
    return ResultatsPage(
      prediction: prediction ?? _defaultPrediction(),
      patientData: patientData, // Passez patientData
    );
  }

  static RiskPrediction _defaultPrediction() {
    return RiskPrediction(
      niveauRisque: 0,
      libelle: 'Non disponible',
      description: 'Aucune donnée de prédiction',
      conseils: ['Veuillez effectuer une nouvelle analyse'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Résultats de l\'analyse',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            // Header avec résultat principal
            SlideInWidget(
              delay: 0,
              child: _buildResultHeader(),
            ),
            SizedBox(height: 32),

            // Indicateur de risque
            ScaleInWidget(
              delay: 200,
              child: _buildRiskIndicator(context), // Passer context ici
            ),
            SizedBox(height: 40),

            // Section conseils
            SlideInWidget(
              delay: 400,
              child: _buildConseilsSection(),
            ),
            SizedBox(height: 40),

            // Actions
            FadeInWidget(
              delay: 600,
              child: _buildActionButtons(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            prediction.color.withOpacity(0.15),
            prediction.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: prediction.color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: prediction.color.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icone animée
          PulseWidget(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: prediction.color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: prediction.color.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                _getRiskIcon(prediction.niveauRisque),
                size: 48,
                color: prediction.color,
              ),
            ),
          ),
          SizedBox(height: 20),

          // Titre du niveau de risque
          Text(
            prediction.niveauText.toUpperCase(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: prediction.color,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),

          // Description
          Text(
            prediction.description,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRiskIndicator(BuildContext context) {
    // Ajouter BuildContext context ici
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          Text(
            'NIVEAU DE RISQUE',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 1.0,
            ),
          ),
          SizedBox(height: 16),

          // Barre de progression du risque
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(
              children: [
                // Fond de la barre
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),

                // Partie remplie selon le risque
                AnimatedContainer(
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.easeOut,
                  width: _getRiskPercentage(prediction.niveauRisque, context),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        prediction.color.withOpacity(0.8),
                        prediction.color,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: prediction.color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),

          // Légende des niveaux
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildRiskLevel(0, 'Aucun'),
              _buildRiskLevel(1, 'Faible'),
              _buildRiskLevel(2, 'Modéré'),
              _buildRiskLevel(3, 'Élevé'),
              _buildRiskLevel(4, 'Très élevé'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiskLevel(int level, String label) {
    final isActive = level == prediction.niveauRisque;
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? _getRiskColor(level) : Colors.grey[300],
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? _getRiskColor(level) : Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildConseilsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête conseils
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xFF2E7D32).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.medical_services_rounded,
                    size: 22,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Recommandations Personnalisées',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Liste des conseils avec animations séquentielles
            Column(
              children: prediction.conseils.asMap().entries.map((entry) {
                final index = entry.key;
                final conseil = entry.value;
                return SlideInWidget(
                  delay: 500 + (index * 100),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: _buildConseilItem(conseil, index),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConseilItem(String conseil, int index) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Numéro du conseil
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Color(0xFF2E7D32).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFF2E7D32).withOpacity(0.3),
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),

          // Texte du conseil
          Expanded(
            child: Text(
              conseil,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Bouton principal - Nouvelle analyse
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xFF2E7D32),
                Color(0xFF4CAF50),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF2E7D32).withOpacity(0.3),
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.refresh_rounded,
                  size: 22,
                  color: Colors.white,
                ),
                SizedBox(width: 12),
                Text(
                  'Nouvelle Analyse',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // Bouton secondaire - Télécharger PDF
        OutlinedButton(
          onPressed: () => _downloadPDF(context),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: Color(0xFF2E7D32)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.download_rounded,
                size: 20,
                color: Color(0xFF2E7D32),
              ),
              SizedBox(width: 10),
              Text(
                'Télécharger mon Rapport',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _downloadPDF(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Icon(
              Icons.picture_as_pdf_rounded,
              size: 48,
              color: Color(0xFF2E7D32),
            ),
            SizedBox(height: 16),
            Text(
              'Télécharger le Rapport',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B5E20),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Votre rapport personnalisé sera généré au format PDF avec :',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            _buildPDFFeature(' Vos données de santé analysées'),
            _buildPDFFeature(' Votre niveau de risque détaillé'),
            _buildPDFFeature(' Conseils personnalisés'),
            _buildPDFFeature(' Date de l\'analyse'),
            _buildPDFFeature(' Mention CardioPredict'),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey[400]!),
                    ),
                    child: Text(
                      'Annuler',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _generateRealPDF(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Générer le PDF',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateRealPDF(BuildContext context) async {
    // Afficher un indicateur de chargement
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Génération du PDF...'),
          ],
        ),
        content: Text('Veuillez patienter quelques instants.'),
      ),
    );

    try {
      print('🔄 Début de la génération du PDF...');

      // Utiliser la méthode simplifiée que vous avez ajoutée
      final pdfFile = await PdfService.generateSimpleReport(
        prediction: prediction,
        analysisDate: DateTime.now(),
      );

      print('✅ PDF généré: ${pdfFile.path}');

      // Fermer le dialogue de chargement
      Navigator.pop(context);

      // Ouvrir le fichier
      await PdfService.openFile(pdfFile);

      print('📄 Fichier ouvert avec succès');

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('PDF généré avec succès !'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      // Fermer le dialogue de chargement en cas d'erreur
      Navigator.pop(context);

      print('❌ Erreur lors de la génération du PDF: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('Erreur: ${e.toString()}'),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildPDFFeature(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: Color(0xFF2E7D32)),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _simulatePDFDownload(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.download_rounded, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Génération du rapport PDF en cours...',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF2E7D32),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    // Simulation du téléchargement
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Rapport PDF généré avec succès !',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    });
  }

  double _getRiskPercentage(int niveau, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width -
        88; // 24*2 padding + 20*2 container padding
    switch (niveau) {
      case 0:
        return screenWidth * 0.0;
      case 1:
        return screenWidth * 0.25;
      case 2:
        return screenWidth * 0.5;
      case 3:
        return screenWidth * 0.75;
      case 4:
        return screenWidth * 1.0;
      default:
        return screenWidth * 0.0;
    }
  }

  Color _getRiskColor(int niveau) {
    switch (niveau) {
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

  IconData _getRiskIcon(int niveau) {
    switch (niveau) {
      case 0:
        return Icons.verified_rounded;
      case 1:
        return Icons.thumb_up_rounded;
      case 2:
        return Icons.info_rounded;
      case 3:
        return Icons.warning_rounded;
      case 4:
        return Icons.error_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}

// =============================================
// WIDGETS D'ANIMATION (garder les mêmes)
// =============================================

class SlideInWidget extends StatefulWidget {
  final Widget child;
  final int delay;

  const SlideInWidget({super.key, required this.child, this.delay = 0});

  @override
  _SlideInWidgetState createState() => _SlideInWidgetState();
}

class _SlideInWidgetState extends State<SlideInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: FadeTransition(
        opacity: _controller,
        child: widget.child,
      ),
    );
  }
}

class ScaleInWidget extends StatefulWidget {
  final Widget child;
  final int delay;

  const ScaleInWidget({super.key, required this.child, this.delay = 0});

  @override
  _ScaleInWidgetState createState() => _ScaleInWidgetState();
}

class _ScaleInWidgetState extends State<ScaleInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

class FadeInWidget extends StatefulWidget {
  final Widget child;
  final int delay;

  const FadeInWidget({super.key, required this.child, this.delay = 0});

  @override
  _FadeInWidgetState createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class PulseWidget extends StatefulWidget {
  final Widget child;

  const PulseWidget({super.key, required this.child});

  @override
  _PulseWidgetState createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<PulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

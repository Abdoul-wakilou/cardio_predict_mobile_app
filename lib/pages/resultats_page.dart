import 'package:flutter/material.dart';
import '../models/risk_prediction.dart';

class ResultatsPage extends StatelessWidget {
  final RiskPrediction prediction;

  const ResultatsPage({
    super.key,
    required this.prediction,
  });

  // Factory constructor pour la route (optionnel)
  factory ResultatsPage.fromPrediction(RiskPrediction? prediction) {
    return ResultatsPage(
      prediction: prediction ?? RiskPrediction.defaultPrediction(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Résultats de l\'analyse',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildResultHeader(),
            const SizedBox(height: 32),
            _buildRiskIndicator(),
            const SizedBox(height: 40),
            if (prediction.probabilityDisease != null)
              _buildProbabilitySection(),
            const SizedBox(height: 20),
            _buildConseilsSection(),
            const SizedBox(height: 40),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResultHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
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
          const SizedBox(height: 20),
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
          const SizedBox(height: 16),
          Text(
            prediction.description,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: prediction.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              prediction.riskCategory ?? 'Non déterminé',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: prediction.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProbabilitySection() {
    final probabilityPercent = prediction.probabilityDisease != null
        ? '${(prediction.probabilityDisease! * 100).toStringAsFixed(1)}%'
        : 'N/A';
        
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Probabilité de maladie:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              Text(
                probabilityPercent,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: prediction.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: prediction.probabilityDisease?.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            color: prediction.color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        children: [
          const Text(
            'NIVEAU DE RISQUE',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOut,
                  width: _getRiskPercentage(),
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
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
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
        const SizedBox(height: 4),
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
    if (prediction.conseils.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Aucune recommandation disponible',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    size: 22,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
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
            const SizedBox(height: 20),
            Column(
              children: prediction.conseils.asMap().entries.map((entry) {
                final index = entry.key;
                final conseil = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          conseil,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh_rounded, size: 20),
                SizedBox(width: 12),
                Text(
                  'Nouvelle Analyse',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Color(0xFF2E7D32)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_rounded, size: 20, color: Color(0xFF2E7D32)),
                SizedBox(width: 12),
                Text(
                  'Accueil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _getRiskPercentage() {
    switch (prediction.niveauRisque) {
      case 0:
        return 0.0;
      case 1:
        return 0.25;
      case 2:
        return 0.5;
      case 3:
        return 0.75;
      case 4:
        return 1.0;
      default:
        return 0.0;
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
import 'package:flutter/material.dart';
import '../models/risk_prediction.dart';

class ResultatsPage extends StatelessWidget {
  final RiskPrediction prediction;

  const ResultatsPage({
    super.key,
    required this.prediction,
  });

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
            const SizedBox(height: 24),
            _buildRiskIndicator(),
            const SizedBox(height: 24),
            if (prediction.probabilityDisease != null)
              _buildProbabilitySection(),
            const SizedBox(height: 24),
            _buildConseilsSection(context),
            const SizedBox(height: 32),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResultHeader() {
    // Déterminer le libellé du badge
    final isMalade = prediction.riskCategory == 'Malade';
    final badgeText = isMalade ? 'MALADE' : 'SAIN';
    final badgeColor = isMalade ? Colors.red : Colors.green;

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
        border: Border.all(color: prediction.color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          // Icône
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: prediction.color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                  color: prediction.color.withOpacity(0.3), width: 2),
            ),
            child: Icon(_getRiskIcon(prediction.niveauRisque),
                size: 48, color: prediction.color),
          ),
          const SizedBox(height: 16),
          // Niveau de risque
          Text(
            prediction.niveauText.toUpperCase(),
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: prediction.color),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            prediction.description,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Badge Sain/Malade
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor.withOpacity(0.5), width: 1),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: badgeColor,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
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
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Probabilité de maladie:',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text(probabilityPercent,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: prediction.color)),
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
      ),
      child: Column(
        children: [
          const Text('NIVEAU DE RISQUE',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey)),
          const SizedBox(height: 12),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              width: _getRiskPercentage(),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  prediction.color.withOpacity(0.8),
                  prediction.color
                ]),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 8),
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
            fontSize: 9,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? _getRiskColor(level) : Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildConseilsSection(BuildContext context) {
    if (prediction.conseils.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
        child: const Center(
            child: Text('Aucune recommandation disponible',
                style: TextStyle(color: Colors.grey))),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // En-tête de la section
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.medical_services_rounded,
                  size: 22, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(width: 12),
            const Text(
              'Recommandations',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B5E20)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Liste des recommandations en accordéons
        ...prediction.conseils.asMap().entries.map((entry) {
          final index = entry.key;
          final conseil = entry.value;
          return _buildAccordionItem(
            context: context,
            number: index + 1,
            text: conseil,
            color: prediction.color,
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAccordionItem({
    required BuildContext context,
    required int number,
    required String text,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ),
          title: Text(
            text.length > 60 ? '${text.substring(0, 60)}...' : text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF2E7D32)),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Colors.grey[700],
                ),
              ),
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
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh_rounded, size: 20, color: Colors.white),
                SizedBox(width: 12),
                Text('Nouvelle Analyse',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              side: const BorderSide(color: Color(0xFF2E7D32)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_rounded, size: 20, color: Color(0xFF2E7D32)),
                SizedBox(width: 12),
                Text('Accueil',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32))),
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

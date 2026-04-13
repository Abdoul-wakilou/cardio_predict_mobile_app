// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'introduction_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Espace responsive en haut
                        SizedBox(height: screenHeight * 0.02),
                        
                        // Logo/Image avec taille responsive
                        Container(
                          height: screenWidth * 0.5,
                          width: screenWidth * 0.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE8F5E8),
                              width: 8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage('assets/images/CardioPredict1.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.04),
                        
                        // Titre principal avec taille responsive
                        Text(
                          'CardioPredict',
                          style: TextStyle(
                            fontSize: screenWidth * 0.09,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1B5E20),
                            letterSpacing: -1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: screenHeight * 0.02),
                        
                        // Description
                        Text(
                          'Votre partenaire santé pour un diagnostic cardiaque intelligent et personnalisé',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: screenHeight * 0.06),
                        
                        // Points forts avec icônes Material Design
                        _buildFeatureItem(
                          icon: Icons.favorite,
                          title: 'Analyse médicale avancée',
                          subtitle: 'Basée sur 10+ paramètres cliniques',
                        ),
                        
                        SizedBox(height: 16),
                        
                        _buildFeatureItem(
                          icon: Icons.psychology,
                          title: 'Intelligence artificielle',
                          subtitle: 'Algorithme certifié et sécurisé',
                        ),
                        
                        SizedBox(height: 16),
                        
                        _buildFeatureItem(
                          icon: Icons.security,
                          title: 'Respect de la confidentialité',
                          subtitle: 'Aucune donnée n’est stockée après l’analyse',
                        ),
                        
                        // Espace flexible qui pousse le contenu vers le bas
                        Expanded(
                          child: Container(),
                        ),
                        
                        // Bouton avec design moderne et responsive
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => IntroductionPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.022,
                                horizontal: 32,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              shadowColor: const Color(0xFF2E7D32).withOpacity(0.3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Démarrer le diagnostic',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Texte informatif
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            'Application médicale • Résultats instantanés',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: screenWidth * 0.03,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE9ECEF),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2E7D32),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B5E20),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'introduction_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _subtitleSlide;
  late Animation<double> _subtitleOpacity;
  late List<Animation<Offset>> _featureSlides;
  late List<Animation<double>> _featureOpacities;
  late Animation<Offset> _btnSlide;
  late Animation<double> _btnOpacity;
  late Animation<double> _footerOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Logo: scale + fade
    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    // Title slide down
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.1, 0.45, curve: Curves.easeOutCubic),
    ));
    _titleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.35, curve: Curves.easeIn),
      ),
    );

    // Subtitle
    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 0.5, curve: Curves.easeOutCubic),
    ));
    _subtitleOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 0.4, curve: Curves.easeIn),
      ),
    );

    // Feature items (staggered slide from left)
    _featureSlides = List.generate(3, (i) {
      final start = 0.28 + i * 0.1;
      return Tween<Offset>(
        begin: const Offset(-0.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(start, start + 0.3, curve: Curves.easeOutCubic),
      ));
    });
    _featureOpacities = List.generate(3, (i) {
      final start = 0.28 + i * 0.1;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, start + 0.18, curve: Curves.easeIn),
        ),
      );
    });

    // Button slide up
    _btnSlide = Tween<Offset>(
      begin: const Offset(0, 0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOutCubic),
    ));
    _btnOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 0.78, curve: Curves.easeIn),
      ),
    );

    // Footer
    _footerOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.02),

                        // ── Logo animé (sans pulse) ──
                        FadeTransition(
                          opacity: _logoOpacity,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: Container(
                              height: screenWidth * 0.5,
                              width: screenWidth * 0.5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF2E7D32).withOpacity(0.3),
                                    const Color(0xFF4CAF50).withOpacity(0.1),
                                  ],
                                ),
                                border: Border.all(
                                  color: const Color(0xFF2E7D32).withOpacity(0.3),
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2E7D32).withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/CardioPredict1.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.04),

                        // ── Titre animé ──
                        FadeTransition(
                          opacity: _titleOpacity,
                          child: SlideTransition(
                            position: _titleSlide,
                            child: Column(
                              children: [
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
                                const SizedBox(height: 8),
                                Container(
                                  width: 60,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF2E7D32),
                                        const Color(0xFF4CAF50),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // ── Sous-titre animé ──
                        FadeTransition(
                          opacity: _subtitleOpacity,
                          child: SlideTransition(
                            position: _subtitleSlide,
                            child: Text(
                              'Votre partenaire santé pour un diagnostic cardiaque intelligent et personnalisé',
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.06),

                        // ── Features items (staggered) ──
                        ..._buildAnimatedFeatures(),

                        const Spacer(),

                        // ── Bouton animé ──
                        FadeTransition(
                          opacity: _btnOpacity,
                          child: SlideTransition(
                            position: _btnSlide,
                            child: _AnimatedButton(
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (_, anim, __) => const IntroductionPage(),
                                    transitionsBuilder: (_, anim, __, child) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).animate(CurvedAnimation(
                                          parent: anim,
                                          curve: Curves.easeOutCubic,
                                        )),
                                        child: child,
                                      );
                                    },
                                    transitionDuration: const Duration(milliseconds: 380),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Footer ──
                        FadeTransition(
                          opacity: _footerOpacity,
                          child: Text(
                            'Application médicale • Résultats instantanés',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: screenWidth * 0.03,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),
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

  List<Widget> _buildAnimatedFeatures() {
    final items = [
      (Icons.favorite, 'Analyse médicale avancée', 'Basée sur 13 paramètres cliniques'),
      (Icons.psychology, 'Intelligence artificielle', 'Algorithme certifié et sécurisé'),
      (Icons.security, 'Respect de la confidentialité', 'Aucune donnée n\'est stockée après l\'analyse'),
    ];

    return items.asMap().entries.map((e) {
      final i = e.key;
      final item = e.value;
      return Column(
        children: [
          FadeTransition(
            opacity: _featureOpacities[i],
            child: SlideTransition(
              position: _featureSlides[i],
              child: _AnimatedFeatureCard(
                icon: item.$1,
                title: item.$2,
                subtitle: item.$3,
              ),
            ),
          ),
          if (i < 2) const SizedBox(height: 12),
        ],
      );
    }).toList();
  }
}

// ────────────────────────────────────────────
// Feature card avec animation au toucher
// ────────────────────────────────────────────
class _AnimatedFeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AnimatedFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  State<_AnimatedFeatureCard> createState() => _AnimatedFeatureCardState();
}

class _AnimatedFeatureCardState extends State<_AnimatedFeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverCtrl;
  late Animation<double> _elevation;
  late Animation<Color?> _borderColor;

  @override
  void initState() {
    super.initState();
    _hoverCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _elevation = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut),
    );
    _borderColor = ColorTween(
      begin: const Color(0xFFE9ECEF),
      end: const Color(0xFFA5D6A7),
    ).animate(CurvedAnimation(parent: _hoverCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _hoverCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _hoverCtrl.forward(),
      onTapUp: (_) => _hoverCtrl.reverse(),
      onTapCancel: () => _hoverCtrl.reverse(),
      child: AnimatedBuilder(
        animation: _hoverCtrl,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _borderColor.value ?? const Color(0xFFE9ECEF),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withOpacity(_elevation.value * 0.018),
                  blurRadius: _elevation.value * 3,
                  offset: Offset(0, _elevation.value * 0.4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, color: const Color(0xFF2E7D32), size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1B5E20),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ────────────────────────────────────────────
// Bouton avec effet ripple + scale au toucher
// ────────────────────────────────────────────
class _AnimatedButton extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onPressed;

  const _AnimatedButton({
    required this.screenWidth,
    required this.screenHeight,
    required this.onPressed,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _pressCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _pressCtrl.forward(),
      onTapUp: (_) {
        _pressCtrl.reverse();
        widget.onPressed();
      },
      onTapCancel: () => _pressCtrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: widget.screenHeight * 0.022,
            horizontal: 32,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2E7D32).withOpacity(0.32),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Démarrer le diagnostic',
                style: TextStyle(
                  fontSize: widget.screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const _BouncingArrow(),
            ],
          ),
        ),
      ),
    );
  }
}

// Flèche qui rebondit en boucle
class _BouncingArrow extends StatefulWidget {
  const _BouncingArrow();

  @override
  State<_BouncingArrow> createState() => _BouncingArrowState();
}

class _BouncingArrowState extends State<_BouncingArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _offset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.28, 0),
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offset,
      child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
    );
  }
}
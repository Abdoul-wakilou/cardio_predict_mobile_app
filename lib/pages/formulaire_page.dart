// lib/pages/formulaire_page.dart
import 'package:flutter/material.dart';
import '../models/patient_data.dart';
import '../models/risk_prediction.dart';
import '../services/api_service.dart';
import 'resultats_page.dart';

class FormulairePage extends StatefulWidget {
  const FormulairePage({super.key});

  @override
  _FormulairePageState createState() => _FormulairePageState();
}

class _FormulairePageState extends State<FormulairePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _currentStep = 0;

  // Contrôleurs pour tous les champs
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _trestbpsController = TextEditingController();
  final TextEditingController _cholController = TextEditingController();
  final TextEditingController _thalachController = TextEditingController();
  final TextEditingController _oldpeakController = TextEditingController();

  // Variables pour les champs catégoriels
  int? _selectedSex;
  int? _selectedCp;
  int? _selectedFbs;
  int? _selectedRestecg;
  int? _selectedExang;
  int? _selectedSlope;
  int? _selectedThal;
  int? _selectedCa;

  // Étapes du formulaire
  final List<FormStep> _formSteps = [
    FormStep(
      title: 'Informations Démographiques',
      icon: Icons.person_outline_rounded,
      description: 'Âge et sexe biologique',
    ),
    FormStep(
      title: 'Paramètres Physiologiques',
      icon: Icons.favorite_border_rounded,
      description: 'Pression artérielle et fréquence cardiaque',
    ),
    FormStep(
      title: 'Analyses Biologiques',
      icon: Icons.bloodtype_outlined,
      description: 'Cholestérol et glycémie',
    ),
    FormStep(
      title: 'Données Cliniques',
      icon: Icons.medical_services_outlined,
      description: 'ECG, douleurs thoraciques et tests',
    ),
  ];

  Future<void> _analyserRisque() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Animation de progression
    for (int i = 0; i <= 100; i += 20) {
      await Future.delayed(Duration(milliseconds: 200));
      if (!mounted) return;
    }

    try {
      final patientData = PatientData(
        age: int.tryParse(_ageController.text),
        sex: _selectedSex,
        cp: _selectedCp,
        trestbps: int.tryParse(_trestbpsController.text),
        chol: int.tryParse(_cholController.text),
        fbs: _selectedFbs,
        restecg: _selectedRestecg,
        thalach: int.tryParse(_thalachController.text),
        exang: _selectedExang,
        oldpeak: double.tryParse(_oldpeakController.text),
        slope: _selectedSlope,
        ca: _selectedCa,
        thal: _selectedThal,
      );

      final prediction = await ApiService.predictRisk(patientData);

      if (!mounted) return;

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              ResultatsPage(prediction: prediction),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 600),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'analyse: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _nextStep() {
    if (_currentStep < _formSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Évaluation Cardiaque',
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
      body: _isLoading
          ? _buildLoadingAnimation()
          : Column(
              children: [
                // Barre de progression
                _buildProgressBar(),

                // Étapes du formulaire
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // En-tête de l'étape
                          _buildStepHeader(),
                          SizedBox(height: 24),

                          // Contenu de l'étape
                          _buildStepContent(),
                        ],
                      ),
                    ),
                  ),
                ),

                // Boutons de navigation en bas de page
                if (_formSteps.length > 1) _buildNavigationButtons(),
              ],
            ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        border: Border(
          bottom: BorderSide(color: Colors.grey[100]!),
        ),
      ),
      child: Column(
        children: [
          // Étapes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _formSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isActive = index == _currentStep;
              final isCompleted = index < _currentStep;

              return Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: isActive || isCompleted
                                ? Color(0xFF2E7D32)
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                            boxShadow: [
                              if (isActive || isCompleted)
                                BoxShadow(
                                  color: Color(0xFF2E7D32).withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                            ],
                          ),
                          child: Center(
                            child: isCompleted
                                ? Icon(Icons.check,
                                    size: 16, color: Colors.white)
                                : Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                          ),
                        ),
                        if (index < _formSteps.length - 1)
                          Expanded(
                            child: Container(
                              height: 2,
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: isCompleted
                                    ? Color(0xFF2E7D32)
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      _getShortStepTitle(step.title),
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
                        color: isActive ? Color(0xFF2E7D32) : Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getShortStepTitle(String title) {
    final Map<String, String> shortTitles = {
      'Informations Démographiques': 'Démographie',
      'Paramètres Physiologiques': 'Physiologie',
      'Analyses Biologiques': 'Biologie',
      'Données Cliniques': 'Clinique',
    };
    return shortTitles[title] ?? title;
  }

  Widget _buildStepHeader() {
    final currentStep = _formSteps[_currentStep];

    return SlideInWidget(
      delay: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF2E7D32).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  currentStep.icon,
                  size: 22,
                  color: Color(0xFF2E7D32),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentStep.title,
                      style: TextStyle(
                        fontSize: 20, // Taille réduite
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      currentStep.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildDemographicStep();
      case 1:
        return _buildPhysiologicalStep();
      case 2:
        return _buildBiologicalStep();
      case 3:
        return _buildClinicalStep();
      default:
        return Container();
    }
  }

  Widget _buildDemographicStep() {
    return SlideInWidget(
      delay: 100,
      child: Column(
        children: [
          _buildNumberField(
            icon: Icons.cake_rounded,
            label: 'Âge du patient',
            controller: _ageController,
            unit: 'ans',
            hintText: '45, 54, 63',
          ),
          SizedBox(height: 20),
          _buildDropdownField(
            icon: Icons.people_rounded,
            label: 'Sexe biologique',
            value: _selectedSex,
            items: [
              DropdownItem(
                  value: 0, label: 'Femme', description: 'Sexe féminin'),
              DropdownItem(
                  value: 1, label: 'Homme', description: 'Sexe masculin'),
            ],
            onChanged: (value) => setState(() => _selectedSex = value),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysiologicalStep() {
    return Column(
      children: [
        SlideInWidget(
          delay: 100,
          child: _buildNumberField(
            icon: Icons.monitor_heart_outlined,
            label: 'Pression artérielle au repos',
            controller: _trestbpsController,
            unit: 'mmHg',
            hintText: '120, 140, 160',
            helperText: 'Normale: 90-120 mmHg',
          ),
        ),
        SizedBox(height: 20),
        SlideInWidget(
          delay: 200,
          child: _buildNumberField(
            icon: Icons.favorite_border_rounded,
            label: 'Fréquence cardiaque maximale',
            controller: _thalachController,
            unit: 'bpm',
            hintText: '150, 170, 190',
            helperText: 'Normale: 60-200 bpm',
          ),
        ),
      ],
    );
  }

  Widget _buildBiologicalStep() {
    return Column(
      children: [
        SlideInWidget(
          delay: 100,
          child: _buildNumberField(
            icon: Icons.water_drop_outlined,
            label: 'Cholestérol sérique',
            controller: _cholController,
            unit: 'mg/dL',
            hintText: '200, 250, 300',
            helperText: 'Normale: < 200 mg/dL',
          ),
        ),
        SizedBox(height: 20),
        SlideInWidget(
          delay: 200,
          child: _buildDropdownField(
            icon: Icons.bakery_dining_outlined,
            label: 'Glycémie à jeun > 120 mg/dL',
            value: _selectedFbs,
            items: [
              DropdownItem(
                  value: 0, label: 'Non', description: 'Glycémie normale'),
              DropdownItem(
                  value: 1, label: 'Oui', description: 'Glycémie élevée'),
            ],
            onChanged: (value) => setState(() => _selectedFbs = value),
          ),
        ),
      ],
    );
  }

  Widget _buildClinicalStep() {
    return Column(
      children: [
        SlideInWidget(
          delay: 100,
          child: _buildDropdownField(
            icon: Icons.heart_broken_outlined,
            label: 'Type de douleur thoracique',
            value: _selectedCp,
            items: [
              DropdownItem(
                  value: 0,
                  label: 'Angine typique',
                  description: 'Douleur caractéristique'),
              DropdownItem(
                  value: 1,
                  label: 'Angine atypique',
                  description: 'Douleur non caractéristique'),
              DropdownItem(
                  value: 2,
                  label: 'Douleur non angineuse',
                  description: 'Douleur non liée au cœur'),
              DropdownItem(
                  value: 3,
                  label: 'Asymptomatique',
                  description: 'Aucune douleur'),
            ],
            onChanged: (value) => setState(() => _selectedCp = value),
          ),
        ),
        SizedBox(height: 20),
        SlideInWidget(
          delay: 200,
          child: _buildDropdownField(
            icon: Icons.monitor_heart_outlined,
            label: 'Résultats ECG au repos',
            value: _selectedRestecg,
            items: [
              DropdownItem(
                  value: 0, label: 'Normal', description: 'ECG normal'),
              DropdownItem(
                  value: 1,
                  label: 'Anomalie onde ST-T',
                  description: 'Anomalie détectée'),
              DropdownItem(
                  value: 2,
                  label: 'Hypertrophie ventriculaire',
                  description: 'HVG probable'),
            ],
            onChanged: (value) => setState(() => _selectedRestecg = value),
          ),
        ),
        SizedBox(height: 20),
        SlideInWidget(
          delay: 300,
          child: _buildDropdownField(
            icon: Icons.directions_run_rounded,
            label: 'Angine induite par l\'effort',
            value: _selectedExang,
            items: [
              DropdownItem(
                  value: 0,
                  label: 'Non',
                  description: 'Aucune douleur à l\'effort'),
              DropdownItem(
                  value: 1,
                  label: 'Oui',
                  description: 'Douleur présente à l\'effort'),
            ],
            onChanged: (value) => setState(() => _selectedExang = value),
          ),
        ),
        SizedBox(height: 20),
        SlideInWidget(
          delay: 400,
          child: _buildNumberField(
            icon: Icons.show_chart_rounded,
            label: 'Dépression du segment ST',
            controller: _oldpeakController,
            unit: 'points',
            hintText: '1.5, 2.0, 3.2',
            helperText: 'Normale: 0-2 points',
            isDecimal: true,
          ),
        ),
        SizedBox(height: 20),
        SlideInWidget(
          delay: 500,
          child: _buildDropdownField(
            icon: Icons.trending_up_rounded,
            label: 'Pente du segment ST à l\'effort',
            value: _selectedSlope,
            items: [
              DropdownItem(
                  value: 0,
                  label: 'Descendante',
                  description: 'Pente négative'),
              DropdownItem(
                  value: 1, label: 'Plate', description: 'Pente nulle'),
              DropdownItem(
                  value: 2, label: 'Montante', description: 'Pente positive'),
            ],
            onChanged: (value) => setState(() => _selectedSlope = value),
          ),
        ),
        SizedBox(height: 20),
        SlideInWidget(
          delay: 600,
          child: _buildDropdownField(
            icon: Icons.science_rounded,
            label: 'Résultat test thalassémie',
            value: _selectedThal,
            items: [
              DropdownItem(
                  value: 0,
                  label: 'Inconnu/Manquant',
                  description: 'Donnée non disponible'),
              DropdownItem(
                  value: 1, label: 'Normal', description: 'Test normal'),
              DropdownItem(
                  value: 2,
                  label: 'Défaut fixe',
                  description: 'Anomalie fixe détectée'),
              DropdownItem(
                  value: 3,
                  label: 'Défaut réversible',
                  description: 'Anomalie réversible'),
            ],
            onChanged: (value) => setState(() => _selectedThal = value),
          ),
        ),
        SizedBox(height: 20),
        SlideInWidget(
  delay: 550,
  child: _buildDropdownField(
    icon: Icons.numbers_rounded,
    label: 'Nombre de vaisseaux colorés',
    value: _selectedCa,
    items: [
      DropdownItem(value: 0, label: '0', description: 'Aucun vaisseau'),
      DropdownItem(value: 1, label: '1', description: 'Un vaisseau'),
      DropdownItem(value: 2, label: '2', description: 'Deux vaisseaux'),
      DropdownItem(value: 3, label: '3', description: 'Trois vaisseaux'),
    ],
    onChanged: (value) => setState(() => _selectedCa = value),
  ),
),
      ],
    );
  }

  Widget _buildNumberField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String unit,
    String? hintText,
    String? helperText,
    bool isDecimal = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!), // Bordure plus subtile
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), // Ombre plus subtile
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Color(0xFF2E7D32)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: controller,
              keyboardType: isDecimal
                  ? TextInputType.numberWithOptions(decimal: true)
                  : TextInputType.number,
              decoration: InputDecoration(
                hintText: hintText,
                suffixText: unit,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF2E7D32)),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est obligatoire';
                }
                if (isDecimal) {
                  final parsed = double.tryParse(value);
                  if (parsed == null) return 'Valeur décimale invalide';
                } else {
                  final parsed = int.tryParse(value);
                  if (parsed == null) return 'Valeur entière invalide';
                }
                return null;
              },
            ),
            if (helperText != null) ...[
              SizedBox(height: 6),
              Text(
                helperText,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required IconData icon,
    required String label,
    required int? value,
    required List<DropdownItem> items,
    required Function(int?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!), // Bordure plus subtile
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: Color(0xFF2E7D32)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: value,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Color(0xFF2E7D32)),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              items: items.map((item) {
                return DropdownMenuItem<int>(
                  value: item.value,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (item.description != null) ...[
                          SizedBox(height: 2),
                          Text(
                            item.description!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              validator: (value) {
                if (value == null) return 'Veuillez sélectionner une option';
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

Widget _buildNavigationButtons() {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        top: BorderSide(color: Colors.grey[100]!),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: SlideInWidget(
      delay: 300,
      child: Row(
        children: [
          if (_currentStep > 0) ...[
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Color(0xFF2E7D32)),
                ),
                child: Text(
                  'Précédent',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
          ],
          Expanded(
            flex: _currentStep > 0 ? 1 : 2,
            child: ElevatedButton(
              onPressed: _currentStep < _formSteps.length - 1
                  ? _nextStep
                  : _analyserRisque,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: Color(0xFF2E7D32).withOpacity(0.3),
              ),
              child: Text(
                _currentStep < _formSteps.length - 1
                    ? 'Continuer'
                    : 'Analyser le risque',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildLoadingAnimation() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScaleInWidget(
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Color(0xFF2E7D32).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology_rounded,
                    size: 50,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text(
                'Analyse en cours...',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B5E20),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'Notre IA analyse vos données pour évaluer\nvotre risque cardiovasculaire',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
              SizedBox(height: 32),
              Container(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Veuillez patienter quelques instants...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ageController.dispose();
    _trestbpsController.dispose();
    _cholController.dispose();
    _thalachController.dispose();
    _oldpeakController.dispose();
    super.dispose();
  }
}

// =============================================
// CLASSES ET WIDGETS D'ANIMATION
// =============================================

class FormStep {
  final String title;
  final IconData icon;
  final String description;

  FormStep({
    required this.title,
    required this.icon,
    required this.description,
  });
}

class DropdownItem {
  final int value;
  final String label;
  final String? description;

  DropdownItem({
    required this.value,
    required this.label,
    this.description,
  });
}

// Animation de slide depuis le bas
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
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<Offset>(
      begin: Offset(0, 0.2),
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

// Animation de scale (agrandissement)
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
      duration: Duration(milliseconds: 400),
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

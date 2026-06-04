// lib/pages/formulaire_page.dart
import 'package:flutter/material.dart';
import '../models/patient_data.dart';
import '../models/risk_prediction.dart';
import '../services/api_service.dart';
import 'resultats_page.dart';
import 'package:flutter/services.dart';

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

  /// Vérifie si les 13 variables obligatoires sont remplies
  bool _isFormComplete() {
    if (_ageController.text.isEmpty ||
        _trestbpsController.text.isEmpty ||
        _cholController.text.isEmpty ||
        _thalachController.text.isEmpty ||
        _oldpeakController.text.isEmpty) {
      return false;
    }
    if (_selectedSex == null ||
        _selectedCp == null ||
        _selectedFbs == null ||
        _selectedRestecg == null ||
        _selectedExang == null ||
        _selectedSlope == null ||
        _selectedCa == null ||
        _selectedThal == null) {
      return false;
    }
    return true;
  }

  Future<void> _analyserRisque() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isFormComplete()) return;

    setState(() {
      _isLoading = true;
    });

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
            return FadeTransition(opacity: animation, child: child);
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
    // Valider l'étape courante avant de passer à la suivante
    if (_formKey.currentState!.validate()) {
      if (_currentStep < _formSteps.length - 1) {
        setState(() {
          _currentStep++;
        });
      }
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
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
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
                _buildProgressBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStepHeader(),
                          SizedBox(height: 24),
                          _buildStepContent(),
                        ],
                      ),
                    ),
                  ),
                ),
                if (_formSteps.length > 1) _buildNavigationButtons(),
              ],
            ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        border: Border(bottom: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _formSteps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isActive || isCompleted
                        ? const Color(0xFF2E7D32)
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                    boxShadow: isActive || isCompleted
                        ? [
                            BoxShadow(
                              color: const Color(0xFF2E7D32).withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getShortStepTitle(step.title),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? const Color(0xFF2E7D32)
                        : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
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
                child: Icon(currentStep.icon, size: 22, color: Color(0xFF2E7D32)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentStep.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      currentStep.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
          // age : plage [1, 120] selon FEATURE_RANGES
          _buildNumberField(
            icon: Icons.cake_rounded,
            label: 'Âge du patient',
            controller: _ageController,
            unit: 'ans',
            hintText: '45',
            helperText: 'Plage acceptée : 1 – 120 ans',
            min: 1,
            max: 120,
          ),
          SizedBox(height: 20),
          _buildDropdownField(
            icon: Icons.people_rounded,
            label: 'Sexe biologique',
            value: _selectedSex,
            items: [
              DropdownItem(value: 0, label: 'Femme', description: 'Sexe féminin'),
              DropdownItem(value: 1, label: 'Homme', description: 'Sexe masculin'),
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
          // trestbps : plage [50, 250] selon FEATURE_RANGES
          child: _buildNumberField(
            icon: Icons.monitor_heart_outlined,
            label: 'Pression artérielle au repos',
            controller: _trestbpsController,
            unit: 'mmHg',
            hintText: '120',
            helperText: 'Plage acceptée : 50 – 250 mmHg  •  Normale : 90–120',
            min: 50,
            max: 250,
          ),
        ),
        SizedBox(height: 20),
        SlideInWidget(
          delay: 200,
          // thalach : plage [50, 250] selon FEATURE_RANGES
          child: _buildNumberField(
            icon: Icons.favorite_border_rounded,
            label: 'Fréquence cardiaque maximale',
            controller: _thalachController,
            unit: 'bpm',
            hintText: '150',
            helperText: 'Plage acceptée : 50 – 250 bpm  •  Normale : 60–200',
            min: 50,
            max: 250,
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
          // chol : plage [50, 700] selon FEATURE_RANGES
          child: _buildNumberField(
            icon: Icons.water_drop_outlined,
            label: 'Cholestérol sérique',
            controller: _cholController,
            unit: 'mg/dL',
            hintText: '200',
            helperText: 'Plage acceptée : 50 – 700 mg/dL  •  Normale : < 200',
            min: 50,
            max: 700,
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
              DropdownItem(value: 0, label: 'Non', description: 'Glycémie normale'),
              DropdownItem(value: 1, label: 'Oui', description: 'Glycémie élevée'),
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
              DropdownItem(value: 0, label: 'Normal', description: 'ECG normal'),
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
          // oldpeak : plage [-5, 10] selon FEATURE_RANGES
          child: _buildNumberField(
            icon: Icons.show_chart_rounded,
            label: 'Dépression du segment ST',
            controller: _oldpeakController,
            unit: 'mm',
            hintText: '1.0',
            helperText: 'Plage acceptée : -5 – 10 mm  •  Normale : 0–2',
            isDecimal: true,
            allowNegative: true,
            min: -5,
            max: 10,
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
                  value: 0, label: 'Ascendante', description: 'Pente positive'),
              DropdownItem(value: 1, label: 'Plate', description: 'Pente nulle'),
              DropdownItem(
                  value: 2,
                  label: 'Descendante',
                  description: 'Pente négative'),
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
                  value: 0, label: 'Normal', description: 'Test normal'),
              DropdownItem(
                  value: 1,
                  label: 'Défaut fixe',
                  description: 'Anomalie fixe détectée'),
              DropdownItem(
                  value: 2,
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
            label: 'Nombre de vaisseaux colorés (fluoroscopie)',
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

  // -----------------------------------------------------------------------
  // _buildNumberField — avec validation de plage min/max
  // Les plages correspondent exactement à FEATURE_RANGES dans app.py
  // -----------------------------------------------------------------------
  Widget _buildNumberField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String unit,
    String? hintText,
    String? helperText,
    bool isDecimal = false,
    bool allowNegative = false,
    double? min,
    double? max,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
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
            TextFormField(
              controller: controller,
              keyboardType: isDecimal
                  ? TextInputType.numberWithOptions(
                      decimal: true, signed: allowNegative)
                  : TextInputType.numberWithOptions(signed: allowNegative),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  allowNegative
                      ? RegExp(r'^-?\d*\.?\d{0,2}')
                      : isDecimal
                          ? RegExp(r'^\d*\.?\d{0,2}')
                          : RegExp(r'^\d+'),
                ),
              ],
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                suffixText: unit,
                suffixStyle: TextStyle(color: Colors.grey[600]),
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
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red[400]!),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.red[600]!, width: 1.5),
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

                final parsed = double.tryParse(value);
                if (parsed == null) {
                  return isDecimal
                      ? 'Valeur décimale invalide'
                      : 'Valeur entière invalide';
                }

                // Validation de la plage — correspond à FEATURE_RANGES dans app.py
                if (min != null && parsed < min) {
                  final minStr = min == min.truncateToDouble()
                      ? min.toInt().toString()
                      : min.toString();
                  return 'Minimum : $minStr $unit';
                }
                if (max != null && parsed > max) {
                  final maxStr = max == max.truncateToDouble()
                      ? max.toInt().toString()
                      : max.toString();
                  return 'Maximum : $maxStr $unit';
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<int>(
                  value: value,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF2E7D32)),
                  iconSize: 24,
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    hintText: 'Sélectionner une option',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  ),
                  items: items.map((item) {
                    return DropdownMenuItem<int>(
                      value: item.value,
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1B5E20),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final bool isLastStep = _currentStep == _formSteps.length - 1;
    final bool canAnalyze = isLastStep && _isFormComplete();

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
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
                        borderRadius: BorderRadius.circular(12)),
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
                onPressed: (!isLastStep)
                    ? _nextStep
                    : (canAnalyze ? _analyserRisque : null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  disabledBackgroundColor: Colors.grey[300],
                ),
                child: Text(
                  !isLastStep ? 'Continuer' : 'Analyser le risque',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
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
                  child: Icon(Icons.psychology_rounded,
                      size: 50, color: Color(0xFF2E7D32)),
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
                    fontSize: 16, color: Colors.grey[600], height: 1.4),
              ),
              SizedBox(height: 32),
              Container(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)),
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
  FormStep({required this.title, required this.icon, required this.description});
}

class DropdownItem {
  final int value;
  final String label;
  final String? description;
  DropdownItem({required this.value, required this.label, this.description});
}

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
        vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
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
      child: FadeTransition(opacity: _controller, child: widget.child),
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
        vsync: this, duration: Duration(milliseconds: 400));
    _animation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
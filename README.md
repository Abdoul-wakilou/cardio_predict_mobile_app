# 🫀 CardioPredict — Application Mobile Flutter

**CardioPredict** est une application mobile développée avec **Flutter**, propulsée par l'intelligence artificielle, conçue pour la **détection précoce des risques cardiovasculaires**.  
Elle permet à l'utilisateur de saisir des données cliniques (âge, cholestérol, tension artérielle, etc.), d'envoyer ces données à une **API Flask IA**, puis d'**afficher le niveau de risque cardiovasculaire** ainsi que des **conseils personnalisés de prévention**.

Ce dépôt correspond exclusivement au **frontend mobile Flutter**, qui communique avec le backend IA via une API REST.

---

## 🎓 Contexte académique

Ce projet est réalisé dans le cadre d'un **mémoire de Master 2**, portant sur :

> **La conception d'un modèle d'intelligence artificielle pour la détection précoce des risques cardiovasculaires.**

L'application mobile constitue la **couche de présentation et d'interaction utilisateur**, connectée à un backend IA développé en Python (Flask + Machine Learning).

---

## 🎯 Objectifs de l'application mobile

- Offrir une **interface simple, moderne et intuitive**.
- Permettre la **saisie sécurisée des données cliniques**.
- Envoyer les données à l'API IA Flask.
- Afficher :
  - le **niveau de risque cardiovasculaire**,
  - une **description explicative**,
  - des **conseils personnalisés de prévention**.
- Générer et télécharger un **rapport PDF** des résultats.
- Ne stocker **aucune donnée sensible localement ou côté serveur**.

---

## ✨ Fonctionnalités principales

- 📋 **Formulaire de saisie** des données cliniques en 4 étapes.
- 🔗 **Communication API** avec le backend Flask (JSON).
- 📊 **Affichage visuel** des résultats avec graphiques animés.
- 💡 **Conseils personnalisés** basés sur le niveau de risque.
- 📄 **Génération PDF** de rapports détaillés (mobile uniquement).
- 🎨 **Interface responsive** avec animations Material Design 3.
- 🔐 **Confidentialité** : Aucun stockage de données personnelles.

---

## ⚙️ Technologies utilisées

| Domaine | Technologies |
|-------|--------------|
| Application mobile | Flutter (Dart) 3.0+ |
| Gestion d'état | Provider |
| Communication API | HTTP / REST (JSON) |
| Génération PDF | pdf, printing, path_provider |
| Design UI | Material Design 3 |
| Animations | Flutter Animations |
| Backend IA (externe) | Flask (Python + scikit-learn) |
| Versioning | Git & GitHub |

---

## 📁 Structure du projet

```
cardio_predict_mobile_app/
├── lib/
│   ├── main.dart                  # Point d'entrée de l'application
│   ├── models/                    # Modèles de données
│   │   ├── risk_prediction.dart   # Résultats prédiction
│   │   └── patient_data.dart      # Données patient
│   ├── pages/                     # Écrans
│   │   ├── formulaire_page.dart   # Formulaire de saisie
│   │   └── resultats_page.dart    # Affichage résultats
│   ├── services/                  # Services externes
│   │   ├── api_service.dart       # Communication API Flask
│   │   └── pdf_service.dart       # Génération PDF
│   └── widgets/                   # Widgets réutilisables
├── assets/
│   └── images/                    # Images et logos
├── pubspec.yaml                   # Dépendances Flutter
└── README.md                      # Documentation
```

---

## 🚀 Installation & Lancement

### Prérequis

- **Flutter SDK ≥ 3.0**
- **Dart SDK**
- **Android Studio / VS Code**
- **Émulateur Android** ou appareil physique
- **Backend Flask** déjà lancé sur `http://localhost:5000`

### Étape 1 : Cloner le dépôt

```bash
git clone https://github.com/Abdoul-wakilou-Tiga/cardio_predict_mobile_app.git
cd cardio_predict_mobile_app
```

### Étape 2 : Installer les dépendances

```bash
flutter pub get
```

### Étape 3 : Lancer l'application

```bash
flutter run
```

---

## 🔗 Communication avec le backend IA

### Endpoint : `/predict`
**Méthode :** POST  
**Content-Type :** application/json

### Requête API depuis Flutter
```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> predictRisk(Map<String, dynamic> patientData) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5000/predict'), // Émulateur Android
    headers: {'Content-Type': 'application/json'},
    body: json.encode(patientData),
  );
  
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to get prediction');
  }
}
```

### Réponse API attendue
```json
{
  "success": true,
  "prediction": 1,
  "probability_disease": 0.82,
  "probability_no_disease": 0.18,
  "risk_level": "Élevé",
  "description": "Risque cardiovasculaire élevé nécessitant une consultation médicale",
  "recommendations": [
    "Consulter un cardiologue rapidement",
    "Surveiller régulièrement votre tension artérielle",
    "Adopter une alimentation pauvre en sel"
  ]
}
```

---

## 📱 Variables collectées

| Variable | Type | Description |
|----------|------|-------------|
| **age** | numérique | Âge du patient (années) |
| **sex** | catégorique | Sexe biologique (0: femme, 1: homme) |
| **cp** | catégorique | Type de douleur thoracique (0-3) |
| **trestbps** | numérique | Pression artérielle au repos (mmHg) |
| **chol** | numérique | Cholestérol sérique (mg/dL) |
| **fbs** | binaire | Glycémie à jeun > 120 mg/dL (0: non, 1: oui) |
| **restecg** | catégorique | Résultats ECG au repos (0-2) |
| **thalach** | numérique | Fréquence cardiaque maximale (bpm) |
| **exang** | binaire | Angine induite par l'effort (0: non, 1: oui) |
| **oldpeak** | numérique | Dépression du segment ST (points) |
| **slope** | catégorique | Pente du segment ST à l'effort (0-2) |
| **ca** | catégorique | Nombre de vaisseaux colorés (0-3) |
| **thal** | catégorique | Résultat test thalassémie (1-3) |

---

## 🎨 Design et UX

### Palette de couleurs
```dart
Color(0xFF2E7D32)  // Vert principal
Color(0xFF4CAF50)  // Vert secondaire  
Color(0xFF1B5E20)  // Vert foncé
Color(0xFFE8F5E9)  // Vert clair (background)
```

### Niveaux de risque
| Niveau | Couleur | Description |
|--------|---------|-------------|
| **Aucun** | Vert | Risque très faible |
| **Faible** | Vert clair | Surveillance recommandée |
| **Modéré** | Orange | Consultation médicale conseillée |
| **Élevé** | Orange foncé | Consultation médicale nécessaire |
| **Très élevé** | Rouge | Consultation médicale urgente |

---

## 📦 Dépendances principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.5.0                    # Requêtes API
  provider: ^6.1.2                # Gestion d'état
  pdf: ^3.10.9                    # Génération PDF
  printing: ^5.11.2               # Impression PDF
  path_provider: ^2.1.3           # Accès fichiers
  open_file: ^3.2.1               # Ouverture fichiers
  flutter_vector_icons: ^2.0.0    # Icônes supplémentaires
```

---


## 🚀 Build pour production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS (macOS uniquement)
```bash
flutter build ios --release
```

---


### Problème : "PDF not generated"
- Sur web : La génération PDF n'est pas supportée
- Sur mobile : Vérifier les permissions de stockage

### Problème : "Dependencies issues"
```bash
flutter clean
flutter pub get
```

---

## 🔐 Sécurité et confidentialité

- **Aucune donnée patient** n'est stockée sur le téléphone
- **Aucune donnée** n'est persistée côté serveur
- Les données sont utilisées **uniquement** pour la prédiction en temps réel
- **Communication locale** entre mobile et backend (pas de cloud)
- L'application est une **aide à la décision médicale** et ne remplace pas un avis médical professionnel

---

## 👨‍💻 Auteur

**Abdoul-wakilou Tiga**  
Étudiant en Master 2 Génie Logiciel 
Université Université d'Abomey-Calavi
Année académique 2024-2025

### Contact
- 📧 Email : [abdoulwakiloutiga@gmail.com](abdoulwakiloutiga@gmail.com)
- 🔗 LinkedIn : [Abdoul-wakilou-Tiga](https://linkedin.com/in/abdoul-wakilou-tiga)
- 🐙 GitHub : [Abdoul-wakilou-Tiga](https://github.com/Abdoul-wakilou-Tiga)

---

## 📄 Licence

Ce projet est distribué sous licence **MIT**.

---

*Dernière mise à jour : Décembre 2025*  
*Version Flutter : 3.0+*  
*Backend requis : Flask API (cardio_predict_model)*
````md
# 🫀 CardioPredict — Application Mobile Flutter

**CardioPredict** est une application mobile développée avec **Flutter**, propulsée par l’intelligence artificielle, conçue pour la **détection précoce des risques cardiovasculaires**.  
Elle permet à l’utilisateur de saisir des données cliniques (âge, cholestérol, tension artérielle, etc.), d’envoyer ces données à une **API Flask IA**, puis d’**afficher le niveau de risque cardiovasculaire** ainsi que des **conseils personnalisés de prévention**.

Ce dépôt correspond exclusivement au **frontend mobile Flutter**, qui communique avec le backend IA via une API REST.

---

## 🎓 Contexte académique

Ce projet est réalisé dans le cadre d’un **mémoire de Master 2**, portant sur :

> **La conception d’un modèle d’intelligence artificielle pour la détection précoce des risques cardiovasculaires.**

L’application mobile constitue la **couche de présentation et d’interaction utilisateur**, connectée à un backend IA développé en Python (Flask + Machine Learning).

---

## 🎯 Objectifs de l’application mobile

- Offrir une **interface simple, moderne et intuitive**.
- Permettre la **saisie sécurisée des données cliniques**.
- Envoyer les données à l’API IA Flask.
- Afficher :
  - le **niveau de risque cardiovasculaire**,
  - une **description explicative**,
  - des **conseils personnalisés de prévention**.
- Générer et télécharger un **rapport PDF** des résultats.
- Ne stocker **aucune donnée sensible localement ou côté serveur**.

---

## ✨ Fonctionnalités principales

- 📋 Formulaire de saisie des données cliniques.
- 🔗 Communication avec l’API Flask (JSON).
- 📊 Affichage du résultat de la prédiction (faible, modéré, élevé).
- 💡 Conseils personnalisés basés sur le niveau de risque.
- 📄 Génération et téléchargement d’un rapport PDF.
- 🎨 Interface responsive et moderne (Flutter).
- 🔐 Respect de la confidentialité des données.

---

## ⚙️ Technologies utilisées

| Domaine | Technologies |
|-------|--------------|
| Application mobile | Flutter (Dart) |
| Architecture | Clean UI + Services |
| Communication API | HTTP / REST (JSON) |
| Backend IA (externe) | Flask (Python) |
| Génération PDF | pdf, path_provider, open_file |
| Versioning | Git & GitHub |

---

## 📁 Structure du projet

```text
cardio_predict_mobile_app/
├── lib/
│   ├── main.dart                  # Point d’entrée de l’application
│   ├── models/                    # Modèles (RiskPrediction, PatientData)
│   ├── pages/                     # Pages UI (Home, Formulaire, Résultats, etc.)
│   ├── services/                  # Services (API, PDF, etc.)
│   └── widgets/                   # Widgets réutilisables
├── assets/
│   └── images/                    # Images et logos
├── pubspec.yaml                   # Dépendances Flutter
└── README.md                      # Documentation
````

---

## 🚀 Installation & Lancement

### 🔧 Prérequis

* **Flutter SDK ≥ 3.0**
* **Dart SDK**
* **Android Studio / VS Code**
* **Émulateur Android ou appareil physique**
* Backend Flask **déjà lancé** sur `http://localhost:5000`

---

### 📥 Cloner le dépôt

```bash
git clone https://github.com/Abdoul-wakilou-Tiga/cardio_predict_mobile_app.git
cd cardio_predict_mobile_app
```

---

### 📦 Installer les dépendances

```bash
flutter pub get
```

---

### ▶️ Lancer l’application

```bash
flutter run
```

> ⚠️ Assurez-vous que :
>
> * l’API Flask est active sur `http://localhost:5000`,
> * l’adresse IP est correctement configurée si vous utilisez un émulateur ou un téléphone physique.

---

## 🔗 Communication avec le backend IA

* **Méthode** : `POST`
* **Endpoint** : `/predict`
* **Format** : JSON
* **Rôle** :

  * envoyer les données cliniques,
  * recevoir le niveau de risque et les conseils,
  * afficher les résultats dans l’application.

---

## 🔐 Sécurité et confidentialité

* Aucune donnée patient n’est stockée sur le téléphone.
* Aucune donnée n’est persistée côté serveur.
* Les données sont utilisées uniquement pour la prédiction en temps réel.
* L’application est une **aide à la décision médicale** et ne remplace pas un avis médical professionnel.

---

## 👤 Auteur

**ABDoul-WAKILOU TIGA**
Master 2 — Intelligence Artificielle & Santé
Projet académique de recherche
Application mobile Flutter connectée à un backend IA Flask

```
```

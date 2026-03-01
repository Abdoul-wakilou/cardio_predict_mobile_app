/* lib/modls/patient_data.dart */

class PatientData {
  final int? age;
  final int? sex;
  final int? cp;
  final int? trestbps;
  final int? chol;
  final int? fbs;
  final int? restecg;
  final int? thalach;
  final int? exang;
  final double? oldpeak;
  final int? slope;
  final int? thal;
  final int? ca;

  PatientData({
    this.age,
    this.sex,
    this.cp,
    this.trestbps,
    this.chol,
    this.fbs,
    this.restecg,
    this.thalach,
    this.exang,
    this.oldpeak,
    this.slope,
    this.thal,
    this.ca,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age ?? 0,
      'sex': sex ?? 0,
      'cp': cp ?? 0,
      'trestbps': trestbps ?? 0,
      'chol': chol ?? 0,
      'fbs': fbs ?? 0,
      'restecg': restecg ?? 0,
      'thalach': thalach ?? 0,
      'exang': exang ?? 0,
      'oldpeak': oldpeak ?? 0.0,
      'slope': slope ?? 0,
      'ca': ca ?? 0,
      'thal': thal ?? 0,
    };
  }
}
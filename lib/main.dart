import 'package:flutter/material.dart';

import 'app.dart';
import 'services/prediction_service.dart';

void main() {
  runApp(CardioPredictApp(predictionService: HttpPredictionService()));
}

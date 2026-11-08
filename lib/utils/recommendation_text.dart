/// Recommandation découpée pour l'affichage : titre court puis détail.
class RecommendationText {
  const RecommendationText({this.heading, required this.body});

  /// L'API rédige ses conseils sous la forme « Constat : conduite à tenir ».
  /// Sans ce motif, le texte est affiché entier plutôt que tronqué.
  factory RecommendationText.parse(String text) {
    final separator = text.indexOf(' : ');
    if (separator <= 0 || separator > _maxHeadingLength) {
      return RecommendationText(body: text);
    }
    final body = text.substring(separator + 3).trim();
    return RecommendationText(
      heading: text.substring(0, separator).trim(),
      body: body.isEmpty ? body : body[0].toUpperCase() + body.substring(1),
    );
  }

  static const int _maxHeadingLength = 70;

  final String? heading;
  final String body;
}

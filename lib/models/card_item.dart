class CardItem {
  final int id;
  final String value;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.id,
    required this.value,
    this.isFlipped = false,
    this.isMatched = false,
  });

  // Create a copy of the card with potentially modified properties
  CardItem copyWith({
    int? id,
    String? value,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return CardItem(
      id: id ?? this.id,
      value: value ?? this.value,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}

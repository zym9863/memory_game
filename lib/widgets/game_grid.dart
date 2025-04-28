import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'memory_card.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final cards = gameProvider.cards;
    
    // Determine grid dimensions based on difficulty
    int crossAxisCount;
    double cardSize;
    
    switch (gameProvider.difficulty) {
      case GameDifficulty.easy:
        crossAxisCount = 3; // 3x4 grid for 12 cards
        cardSize = 90.0;
        break;
      case GameDifficulty.medium:
        crossAxisCount = 4; // 4x4 grid for 16 cards
        cardSize = 80.0;
        break;
      case GameDifficulty.hard:
        crossAxisCount = 4; // 4x6 grid for 24 cards
        cardSize = 70.0;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1.0,
        ),
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return MemoryCard(
            card: cards[index],
            onCardTap: (cardId) => gameProvider.flipCard(cardId),
            size: cardSize,
          );
        },
      ),
    );
  }
}

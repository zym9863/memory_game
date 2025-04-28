import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme_constants.dart';
import '../providers/game_provider.dart';
import 'home_screen.dart';
import 'game_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    // Format time as mm:ss
    final minutes = (gameProvider.elapsedSeconds ~/ 60).toString().padLeft(
      2,
      '0',
    );
    final seconds = (gameProvider.elapsedSeconds % 60).toString().padLeft(
      2,
      '0',
    );
    final timeString = '$minutes:$seconds';

    // Calculate stars based on moves and difficulty
    int maxMoves;
    switch (gameProvider.difficulty) {
      case GameDifficulty.easy:
        maxMoves = 12;
        break;
      case GameDifficulty.medium:
        maxMoves = 18;
        break;
      case GameDifficulty.hard:
        maxMoves = 30;
        break;
    }

    int stars;
    if (gameProvider.moves <= maxMoves) {
      stars = 3;
    } else if (gameProvider.moves <= maxMoves * 1.5) {
      stars = 2;
    } else {
      stars = 1;
    }

    return Scaffold(
      body: Container(
        decoration: ThemeConstants.gradientBackgroundDecoration,
        child: SafeArea(
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              elevation: 12.0,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Trophy icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.amber.withAlpha(50),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events_rounded,
                        size: 50,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Game over text
                    Text(
                      '游戏结束!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: ThemeConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Congratulations text
                    Text(
                      _getResultMessage(stars),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeConstants.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(
                            index < stars
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color:
                                index < stars
                                    ? Colors.amber
                                    : Colors.grey.shade400,
                            size: 40,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    // Results in a card
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: ThemeConstants.backgroundColor,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        children: [
                          _buildResultRow(
                            icon: Icons.emoji_events_outlined,
                            label: '得分',
                            value: gameProvider.score.toString(),
                            color: Colors.amber,
                          ),
                          const SizedBox(height: 16),
                          _buildResultRow(
                            icon: Icons.timer_outlined,
                            label: '用时',
                            value: timeString,
                            color: ThemeConstants.primaryColor,
                          ),
                          const SizedBox(height: 16),
                          _buildResultRow(
                            icon: Icons.touch_app_outlined,
                            label: '步数',
                            value: gameProvider.moves.toString(),
                            color: Colors.orange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          context,
                          '再玩一次',
                          Icons.refresh_rounded,
                          ThemeConstants.secondaryColor,
                          () {
                            gameProvider.resetGame();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const GameScreen(),
                              ),
                            );
                          },
                        ),
                        _buildActionButton(
                          context,
                          '返回主页',
                          Icons.home_rounded,
                          ThemeConstants.primaryColor,
                          () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getResultMessage(int stars) {
    switch (stars) {
      case 3:
        return '太棒了！你的记忆力非常出色！';
      case 2:
        return '做得好！你有很好的记忆力！';
      default:
        return '恭喜完成游戏！再接再厉！';
    }
  }

  Widget _buildResultRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 16),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 16,
            color: ThemeConstants.textSecondaryColor,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 4,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme_constants.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: ThemeConstants.gradientBackgroundDecoration,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Game logo/title
              _buildGameTitle(),

              const SizedBox(height: 40),

              // Game description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  '测试你的记忆力！翻开卡片，找到匹配的对子',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: ThemeConstants.textOnPrimaryColor.withAlpha(220),
                  ),
                ),
              ),

              const Spacer(),

              // Difficulty selection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text('选择难度', style: ThemeConstants.subheadingStyle),
                        const SizedBox(height: 24),
                        _buildDifficultyButton(
                          context,
                          '简单',
                          GameDifficulty.easy,
                          ThemeConstants.secondaryColor,
                          Icons.sentiment_satisfied_alt,
                        ),
                        const SizedBox(height: 16),
                        _buildDifficultyButton(
                          context,
                          '中等',
                          GameDifficulty.medium,
                          ThemeConstants.primaryColor,
                          Icons.sentiment_neutral,
                        ),
                        const SizedBox(height: 16),
                        _buildDifficultyButton(
                          context,
                          '困难',
                          GameDifficulty.hard,
                          const Color(0xFFE53935),
                          Icons.sentiment_very_dissatisfied,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),

              // Footer
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  '© 2025 记忆翻牌游戏',
                  style: TextStyle(
                    color: ThemeConstants.textOnPrimaryColor.withAlpha(150),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameTitle() {
    return Column(
      children: [
        // Game icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(50),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.grid_view_rounded,
            size: 60,
            color: ThemeConstants.textOnPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        // Game title
        const Text('记忆翻牌游戏', style: ThemeConstants.headingStyle),
      ],
    );
  }

  Widget _buildDifficultyButton(
    BuildContext context,
    String label,
    GameDifficulty difficulty,
    Color color,
    IconData icon,
  ) {
    return ElevatedButton(
      onPressed: () {
        // Initialize the game with selected difficulty
        final gameProvider = Provider.of<GameProvider>(context, listen: false);
        gameProvider.initGame(difficulty);

        // Navigate to game screen
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const GameScreen()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

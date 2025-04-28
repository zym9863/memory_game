import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/theme_constants.dart';
import '../providers/game_provider.dart';
import '../widgets/game_grid.dart';
import 'result_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    // Check if game is over and navigate to result screen
    if (gameProvider.isGameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ResultScreen()),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('记忆翻牌'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重新开始',
            onPressed: () {
              gameProvider.resetGame();
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            tooltip: '返回主页',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              ThemeConstants.backgroundColor,
              ThemeConstants.backgroundColor.withAlpha(240),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildGameInfo(context),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [const GameGrid()],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context) {
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

    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: ThemeConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildInfoItem(
              icon: Icons.timer_outlined,
              label: '时间',
              value: timeString,
              color: ThemeConstants.primaryColor,
            ),
            _buildInfoItem(
              icon: Icons.touch_app_outlined,
              label: '步数',
              value: gameProvider.moves.toString(),
              color: Colors.orange,
            ),
            _buildInfoItem(
              icon: Icons.star_outline,
              label: '分数',
              value: gameProvider.score.toString(),
              color: Colors.amber,
            ),
            _buildInfoItem(
              icon: Icons.grid_view_outlined,
              label: '剩余',
              value: gameProvider.remainingPairs.toString(),
              color: ThemeConstants.secondaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: ThemeConstants.textSecondaryColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

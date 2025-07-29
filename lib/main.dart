import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants/theme_constants.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: '记忆翻牌游戏',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: ThemeConstants.primaryColor,
            primary: ThemeConstants.primaryColor,
            secondary: ThemeConstants.secondaryColor,
            surface: ThemeConstants.surfaceColor,
          ),
          scaffoldBackgroundColor: ThemeConstants.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: ThemeConstants.primaryColor,
            foregroundColor: ThemeConstants.textOnPrimaryColor,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConstants.primaryColor,
              foregroundColor: ThemeConstants.textOnPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          cardTheme: CardThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

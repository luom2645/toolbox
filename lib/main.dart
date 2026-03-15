import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const DigitalHeroApp());
}

class DigitalHeroApp extends StatelessWidget {
  const DigitalHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '数字英雄传',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const GameScreen(),
    );
  }
}

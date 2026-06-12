import 'package:flutter/material.dart';

import 'screens/busca_screen.dart';

void main() {
  runApp(const CallWorkApp());
}

class CallWorkApp extends StatelessWidget {
  const CallWorkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Work',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF085041),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF9F5),
        useMaterial3: true,
      ),
      home: const BuscaScreen(),
    );
  }
}
import 'package:citacoes_app/pages/home_page.dart';
import 'package:flutter/material.dart';

const _nightBackground = Color(0xFF111714);
const _nightSurface = Color(0xFF1B2420);
const _nightAccent = Color(0xFFD1F27C);
const _nightMint = Color(0xFF78C8B0);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _nightAccent,
          brightness: Brightness.dark,
          surface: _nightSurface,
        ).copyWith(
          primary: _nightAccent,
          onPrimary: _nightBackground,
          secondary: _nightMint,
          surface: _nightSurface,
          error: const Color(0xFFFF8A80),
        );

    return MaterialApp(
      title: 'Academic Citation Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: _nightBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: _nightBackground,
          foregroundColor: Color(0xFFE5EBE4),
          centerTitle: true,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _nightSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFF39463E)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: Color(0xFF39463E)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: _nightAccent, width: 1.5),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _nightAccent,
            foregroundColor: _nightBackground,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

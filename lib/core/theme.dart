import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kBrand900 = Color(0xFF085041);
const kBrand700 = Color(0xFF0F6E56);
const kBrand600 = Color(0xFF178A64);
const kBrand500 = Color(0xFF1D9E75);
const kBrand300 = Color(0xFF86D9BB);
const kBrand100 = Color(0xFFD1F1E4);
const kBrand50  = Color(0xFFE9F8F1);

const kInk     = Color(0xFF1F2421);
const kInkSoft = Color(0xFF5F625D);
const kInkMute = Color(0xFF9A9D97);
const kPaper   = Color(0xFFFAF9F5);
const kLine    = Color(0xFFE8E6DF);
const kBg      = Color(0xFFECEAE1);

ThemeData buildTheme() {
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: kBrand500,
      primary: kBrand900,
      secondary: kBrand500,
      surface: Colors.white,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: kPaper,
  );

  return base.copyWith(
    textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: kInk,
      displayColor: kInk,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: kBrand900,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 17,
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kBrand700,
      unselectedItemColor: kInkMute,
      selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      unselectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      elevation: 12,
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kBrand900,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        elevation: 0,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kInk,
        side: const BorderSide(color: kLine, width: 1.5),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kLine, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kLine, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kBrand500, width: 1.8),
      ),
      labelStyle: const TextStyle(color: kInkSoft, fontSize: 14),
      hintStyle: const TextStyle(color: kInkMute, fontSize: 14),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: kLine),
      ),
      margin: EdgeInsets.zero,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kInkSoft),
      side: const BorderSide(color: kLine),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
    dividerTheme: const DividerThemeData(color: kLine, thickness: 1, space: 1),
  );
}

import 'package:mivro/features/auth/screens/signin_screen.dart';
import 'package:mivro/features/auth/screens/signup_screen.dart';
import 'package:mivro/features/home/screens/home_screen.dart';
import 'package:mivro/core/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _initialScreen = const SignUpScreen();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final hasAccount = prefs.getBool('hasAccount') ?? false;

    setState(() {
      if (isLoggedIn) {
        _initialScreen = const HomeScreen();
      } else if (hasAccount) {
        _initialScreen = const SignInScreen();
      } else {
        _initialScreen = const SignUpScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: _initialScreen,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData.light().copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(),
      scaffoldBackgroundColor: Colors.white,
      primaryColor: mivroGreen,
      colorScheme: const ColorScheme.light(
        primary: mivroGreen,
        secondary: mivroGreenDark,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: mivroGreen,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mivroGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      cardTheme: CardThemeData(
        color: mivroGray,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

import 'dart:developer';

import 'package:mivro/presentation/auth/screens/details_screen.dart';
import 'package:mivro/presentation/auth/screens/login_screen.dart';
import 'package:mivro/presentation/auth/screens/signup_screen.dart';
import 'package:mivro/presentation/home/view/screens/home_page.dart';
import 'package:mivro/utils/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // FlutterNativeSplash.remove();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Widget> _screenFuture;

  @override
  void initState() {
    super.initState();
    _screenFuture = checkLogin();
  }

  Future<Widget> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isUser = prefs.getBool('isUser') ?? false;
    log(isLoggedIn.toString());
    log(isUser.toString());

    if (isLoggedIn) {
      return const HomePage();
    } else if (isUser) {
      return const LoginScreen();
    } else {
      return const SignUpScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: FutureBuilder<Widget>(
        future: _screenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading screen'));
          }
          return snapshot.data!;
        },
      ),
    );
  }
}

final theme = ThemeData.light().copyWith(
  textTheme: GoogleFonts.poppinsTextTheme(),
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: myColorFromHex("#134B70"),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.white,
  ),
);

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/tambah_kendaraan.dart';
import 'login.dart';
import 'beranda.dart';
import 'main_screen.dart';
import 'pengaturan_profil.dart';
import 'tambah_kendaraan.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parqrin App',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const MainLayout(child: LoginPage()),
        '/main': (context) => const MainScreen(),
      },
    );
  }
}

/// --- SPLASH SCREEN ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A994E),
      body: Center(
        child: Image.asset(
          "assets/logo_parqrin.png",
          width: 250,
        ),
      ),
    );
  }
}

/// --- MAIN LAYOUT (berisi widget bawah yang muncul di semua halaman) ---
class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        color: const Color(0xFF6A994E),
        padding: const EdgeInsets.all(12),
        child: const Text(
          "© 2025 Parqrin App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

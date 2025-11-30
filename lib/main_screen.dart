import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'beranda.dart';
import 'aktivitas.dart';
import 'riwayat.dart';
import 'akun.dart';

class MainScreen extends StatefulWidget {
  final String? username;
  final String? email;

  const MainScreen({
    super.key,
    this.username,
    this.email,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? username;
  String? email;

  final List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (!mounted) return;

    setState(() {
      if (userJson != null) {
        final user = jsonDecode(userJson);
        username = user['name'];
        email = user['email'];
      } else {
        username = widget.username ?? "Pengguna";
        email = widget.email ?? "email@example.com";
      }

      _pages
        ..clear()
        ..addAll([
          BerandaPage(username: username, email: email),
          const AktivitasPage(),
          const Center(child: Text("Fitur Bayar & Metrans Coming Soon")),
          RiwayatPage(riwayat: []), // riwayat sementara kosong
          AkunPage(
            username: username ?? "",
            email: email ?? "",
          ),
        ]);

      if (_selectedIndex >= _pages.length) {
        _selectedIndex = 0;
      }
    });
  }

  void _onItemTapped(int index) {
    if (_pages.isEmpty) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0FFC2),
      body: _pages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF6A994E),
        selectedItemColor: const Color.fromARGB(255, 8, 9, 6),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Aktivitas"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: "Bayar"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"), // <-- ganti ikon & label
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }
}

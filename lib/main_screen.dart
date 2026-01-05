import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Pages
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

  List<Widget> _pages = [];
  bool _handledArgs = false; // 🔥 penting

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_handledArgs) return;

    final args = ModalRoute.of(context)?.settings.arguments;

    if (args == "riwayat") {
      setState(() {
        _selectedIndex = 2; // 🔥 pindah ke Riwayat
      });
    }

    _handledArgs = true;
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (!mounted) return;

    if (userJson != null) {
      final user = jsonDecode(userJson);
      username = user['name'];
      email = user['email'];
    } else {
      username = widget.username ?? "Pengguna";
      email = widget.email ?? "email@example.com";
    }

    setState(() {
      _pages = [
        BerandaPage(username: username, email: email),
        const AktivitasPage(),
        const RiwayatPage(),
        AkunPage(
          username: username ?? "",
          email: email ?? "",
        ),
      ];
    });
  }

  void _onItemTapped(int index) {
    if (_pages.isEmpty) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),

      body: _pages.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF6A994E),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 230, 230, 230),
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Aktivitas"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'beranda.dart';
import 'aktivitas.dart';
import 'dompet.dart';
import 'akun.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {
  final String? username;
  final String? email;

  const MainScreen({super.key, this.username, this.email});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  String? username;
  String? email;

  final List<Widget> _pages = [];

  @override
  // void initState() {
  //   super.initState();
  //   loadUser();
  //   _pages.addAll([
  //     BerandaPage(username: widget.username, email: widget.email),
  //     const AktivitasPage(),
  //     const Center(child: Text("Bayar (Coming Soon)")),
  //     const DompetPage(),
  //     AkunPage(
  //       username: widget.username ?? "User",
  //       email: widget.email ?? "user@email.com",
  //       phone: "081234567890",
  //     ),
  //   ]);
  // }
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
  final prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString('user');

  setState(() {
    if (userJson != null) {
      var user = jsonDecode(userJson);
      username = user['name'];
      email = user['email'];
    } else {
      username = widget.username;
      email = widget.email;
    }

    _pages.clear();
    _pages.addAll([
      BerandaPage(username: username, email: email),
      const AktivitasPage(),
      const Center(child: Text("Bayar (Coming Soon)")),
      const DompetPage(),
      AkunPage(
        username: username ?? "",
        email: email ?? "",
        phone: "",   // dummy phone DIHAPUS
      ),
    ]);
  });
}


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF386641),
        selectedItemColor: const Color(0xFFE0FFC2),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Aktivitas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "Bayar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Dompet",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }
}

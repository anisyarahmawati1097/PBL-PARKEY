import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const Header({super.key, this.title = "Dashboard Admin"});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green,
      elevation: 2,
      title: Text(
        title,
        style: const TextStyle(
          color: Color.fromARGB(255, 253, 253, 253),
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      actions: [
        IconButton(
  icon: const Icon(Icons.logout),
  onPressed: () async {
    // Hapus data login di SharedPreferences jika ada
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    // Pindah ke halaman login dan hapus semua history
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login', // pastikan route login sudah terdaftar di MaterialApp
      (route) => false,
    );
  },
),

      ],
    );
  }
}

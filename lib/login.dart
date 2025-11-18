import 'package:flutter/material.dart';
import 'daftar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ================================
  //           FUNGSI LOGIN
  // ================================
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi semua field terlebih dahulu")),
      );
      return;
    }

    try {
      final url = Uri.parse("http://192.168.51.134:8000/api/masuk");// pakai IP laptop

      final response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {"email": email, "password": password},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Login berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Berhasil masuk!")),
        );

        String token = data['token'];
        var user = data['user'];

         // Simpan token & user ke local storage
        final prefs = await SharedPreferences.getInstance();
   
        await prefs.setString('token', token);
        await prefs.setString('user', jsonEncode(user));
        // TODO: simpan token jika perlu (SharedPreferences)

        // Pindah ke halaman utama
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        // Ambil pesan error dari backend
        String msg = data["message"] ?? '';
        if (msg.isEmpty && data is Map && data.containsKey('errors')) {
          final errors = data['errors'] as Map;
          final firstField = errors.keys.first;
          msg = (errors[firstField] as List).first.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg.isNotEmpty ? msg : "Gagal masuk!")),
        );
      }
    } catch (e) {
      // Jika tidak bisa connect ke server
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error koneksi: $e")));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A994E),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF386641),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Masuk",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Field Email
                const Text("Email", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: "Masukkan email",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

                // Field Password
                const Text("Kata sandi", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Masukkan kata sandi",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Lupa kata sandi",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                // Tombol Login
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC3E956),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "MASUK",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Navigasi ke halaman Daftar
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const DaftarPage()),
                      );
                    },
                    child: const Text(
                      "Belum punya akun? Daftar Sekarang",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

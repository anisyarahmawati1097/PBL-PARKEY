import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'lupasandi.dart';
import 'daftar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // =============================================
  //                LOGIN FUNCTION
  // =============================================
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Semua kolom harus diisi.");
      return;
    }

    try {
      final url = Uri.parse("http://192.168.110.68:8000/api/masuk");

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      // --- Pastikan response adalah JSON ---
      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        _showMessage("Server tidak mengembalikan data yang valid.");
        return;
      }

      // --- Status 200 → Login Berhasil ---
      if (response.statusCode == 200) {
        _showMessage("Berhasil Masuk!");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);
        await prefs.setString("user", jsonEncode(data["user"]));
        await prefs.setString("user_id", data["user"]["id"].toString());


        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/main');
        return;
      }

      // --- Jika gagal → kirim pesan error dari Laravel ---
      _handleError(data);
    } catch (e) {
      _showMessage("Tidak dapat terhubung ke server.");
    }
  }

  // =============================================
  //              HANDLE ERROR LARAVEL
  // =============================================
  void _handleError(dynamic data) {
    String message = "";

    // error dari Validator Laravel
    if (data is Map && data.containsKey("errors")) {
      final errors = data["errors"] as Map;
      message = (errors.values.first as List).first.toString();
    }

    // error manual { message : "...." }
    if (message.isEmpty && data is Map && data.containsKey("message")) {
      message = data["message"];
    }

    _showMessage(message.isNotEmpty ? message : "Gagal Masuk!");
  }

  // =============================================
  //                     ALERT
  // =============================================
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // =============================================
  //                        UI
  // =============================================
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

                const SizedBox(height: 25),

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

                const SizedBox(height: 20),

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
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LupaPasswordPage()),
      );
    },
    child: const Text(
      "Lupa kata sandi?",
      style: TextStyle(color: Colors.white),
    ),
  ),
),
                const SizedBox(height: 10),

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

                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

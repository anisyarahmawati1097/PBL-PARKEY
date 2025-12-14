import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

Future<void> _resetPassword() async {
  final email = _emailController.text.trim();
  final token = _tokenController.text.trim();
  final password = _passwordController.text.trim();
  final confirmPassword = _confirmController.text.trim();

  if (email.isEmpty || token.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Semua kolom harus diisi")),
    );
    return;
  }

  if (password != confirmPassword) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kata sandi dan konfirmasi tidak sama")),
    );
    return;
  }

  try {
    final url = Uri.parse("http://192.168.156.134:8000/api/reset-password");

    final response = await http.post(
      url,
      headers: {"Accept": "application/json"},
      body: {
        "email": email,
        "token": token,
        "password": password,
        "password_confirmation": confirmPassword,
      },
    );

    final data = jsonDecode(response.body);

    if (!mounted) return; // <-- Tambahkan ini setelah async

    if (response.statusCode == 200) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(data["message"] ?? "Kata sandi berhasil direset!")),
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data["message"] ?? "Gagal mereset kata sandi!")),
      );
    }
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error koneksi: $e")),
    );
  }
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
                    "Reset Kata Sandi",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Masukkan token reset, email Anda, dan kata sandi baru.",
                  style: TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 15),

                const Text("Token Reset", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                TextField(
                  controller: _tokenController,
                  decoration: const InputDecoration(
                    hintText: "Masukkan token dari email",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

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

                const Text("Kata sandi Baru", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Masukkan kata sandi baru",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                const Text("Konfirmasi Kata sandi", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                TextField(
                  controller: _confirmController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Ulangi kata sandi baru",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC3E956),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "RESET KATA SANDI",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Kembali ke halaman permintaan token",
                      style: TextStyle(color: Colors.white),
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

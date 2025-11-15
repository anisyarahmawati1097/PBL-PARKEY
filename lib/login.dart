import 'package:flutter/material.dart';
import 'daftar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      final url = Uri.parse("http://192.168.184.131:8000/api/masuk");

      final response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {
          "email": email, // jika backend bisa login pakai username, ganti menjadi "login": email
          "password": password,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token = data["token"];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Login berhasil")),
        );

        // TODO: simpan token di SharedPreferences bila perlu

        // pindah ke halaman utama
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        String msg = data["message"] ?? '';

        if (msg.isEmpty && data is Map && data.containsKey('errors')) {
          final errors = data['errors'] as Map;
          final firstField = errors.keys.first;
          msg = (errors[firstField] as List).first.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg.isNotEmpty ? msg : "Login gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo_parqrin.png",
                height: 165,
              ),
              const SizedBox(height: 20),

              Container(
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

                    const Text("Email / Username",
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "Masukkan email atau username",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text("Password",
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: "Masukkan password",
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Lupa Password",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

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
                          "LOGIN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DaftarPage(),
                            ),
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
            ],
          ),
        ),
      ),
    );
  }
}

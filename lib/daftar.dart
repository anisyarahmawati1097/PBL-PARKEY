import 'package:flutter/material.dart';
import 'login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DaftarPage extends StatefulWidget {
  const DaftarPage({super.key});

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _phoneController = TextEditingController();

  // ================================
  //  FUNGSI REGISTER KE BACKEND
  // ================================
  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _fullNameController.text.trim();
    final dob = _dobController.text.trim();
    final phone = _phoneController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty || fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua kolom wajib diisi terlebih dahulu")),
      );
      return;
    }

    try {
      final url = Uri.parse("http://192.168.115.134:8000/api/daftar");

      final response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {
          "fullname": fullName,        // Nama lengkap
          "name": username,            // Username → kolom "name"
          "email": email,
          "tanggal_lahir": dob,        // Format: YYYY-MM-DD
          "phone": phone,
          "password": password,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Berhasil daftar!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else {
        String msg = data["message"] ?? '';

        if (msg.isEmpty && data is Map && data.containsKey('errors')) {
          final errors = data['errors'] as Map;
          final firstField = errors.keys.first;
          msg = (errors[firstField] as List).first.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg.isNotEmpty ? msg : "Gagal daftar!")),
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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A994E),
      appBar: AppBar(
        title: const Text("Daftar Akun"),
        backgroundColor: const Color(0xFF386641),
        foregroundColor: Colors.white,
      ),
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
                    "Buat Akun Baru",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text("Nama Lengkap", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                TextField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    hintText: "Masukkan nama lengkap",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),

                const Text("Tanggal Lahir (YYYY-MM-DD)", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                TextField(
                  controller: _dobController,
                  decoration: const InputDecoration(
                    hintText: "YYYY-MM-DD",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.datetime,
                ),
                const SizedBox(height: 15),

                const Text("Nomor HP", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    hintText: "Masukkan nomor HP",
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),

                const Text("Nama pengguna", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 5),
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: "Masukkan nama pengguna",
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
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),

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
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC3E956),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "DAFTAR",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Sudah punya akun? Masuk",
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

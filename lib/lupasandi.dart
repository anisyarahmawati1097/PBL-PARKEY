import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'reset_sandi.dart';

class LupaPasswordPage extends StatefulWidget {
  const LupaPasswordPage({super.key});

  @override
  State<LupaPasswordPage> createState() => _LupaPasswordPageState();
}

class _LupaPasswordPageState extends State<LupaPasswordPage> {
  final _emailController = TextEditingController();

  Future<void> _kirimReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email tidak boleh kosong")),
      );
      return;
    }

    try {
      final url = Uri.parse("http://192.168.156.134:8000/api/lupa-password");

      final response = await http.post(
        url,
        headers: {"Accept": "application/json"},
        body: {"email": email},
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(data["message"] ?? "Email reset telah dikirim!"),
    ),
  );
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ResetPasswordPage(),
    ),
  );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(data["message"] ?? "Gagal mengirim permintaan!"),
          ),
        );
      }
    } catch (e) {
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
                    "Lupa Kata Sandi",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Masukkan email Anda. Kami akan mengirimkan link reset kata sandi.",
                  style: TextStyle(color: Colors.white),
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

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _kirimReset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC3E956),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "KIRIM TOKEN RESET",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

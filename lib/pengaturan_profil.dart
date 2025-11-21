import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PengaturanProfilPage extends StatefulWidget {
  final String username;
  final String email;
  final String phone;
  final String fullName;
  final String dob;

  const PengaturanProfilPage({
    super.key,
    this.username = '',
    this.email = '',
    this.phone = '',
    this.fullName = '',
    this.dob = '',
  });

  @override
  State<PengaturanProfilPage> createState() => _PengaturanProfilPageState();
}

class _PengaturanProfilPageState extends State<PengaturanProfilPage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;

  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(
      text: widget.fullName.isNotEmpty ? widget.fullName : widget.username,
    );
    _usernameController = TextEditingController(text: widget.username);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _dobController = TextEditingController(text: widget.dob);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // ==========================================
  // 🔥 1. UPDATE PROFIL -> POST /user/update
  // ==========================================
  Future<void> _saveProfile() async {
    setState(() => _loading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anda belum login")),
      );
      return;
    }

    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/user/update"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
      body: {
        "name": _nameController.text,
        "username": _usernameController.text,
        "email": _emailController.text,
        "phone": _phoneController.text,
        "dob": _dobController.text,
      },
    );

    setState(() => _loading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memperbarui profil: ${response.body}")),
      );
    }
  }

  // ==========================================
  // 🔥 2. LOGOUT -> POST /keluar
  // ==========================================
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    await http.post(
      Uri.parse("http://127.0.0.1:8000/api/keluar"),
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    // Hapus token
    prefs.remove("token");

    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedName = _nameController.text.isNotEmpty
        ? _nameController.text
        : _usernameController.text.isNotEmpty
            ? _usernameController.text
            : "User";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Profil"),
        backgroundColor: const Color(0xFF6A994E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Header profil
            ListTile(
              leading: const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 36, color: Colors.white),
              ),
              title: Text(
                displayedName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_phoneController.text.isNotEmpty
                      ? _phoneController.text
                      : "-"),
                  Text(_emailController.text.isNotEmpty
                      ? _emailController.text
                      : "-"),
                ],
              ),
            ),

            const SizedBox(height: 12),

            _buildTextField("Nama Lengkap", _nameController),
            const SizedBox(height: 12),

            _buildTextField("Tanggal Lahir", _dobController),
            const SizedBox(height: 12),

            _buildTextField(
              "Nomor Telepon",
              _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),

            _buildTextField(
              "Email",
              _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),

            _buildTextField("Nama Pengguna", _usernameController),
            const SizedBox(height: 20),

            // Tombol Simpan
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A994E),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _loading ? null : _saveProfile,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text("SIMPAN"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7272),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: _logout,
              child: const Text("LOGOUT"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PengaturanProfilPage extends StatefulWidget {
  final String username;
  final String email;
  final String phone;
  final String fullName;
  final String tanggalLahir;

  const PengaturanProfilPage({
    super.key,
    this.username = '',
    this.email = '',
    this.phone = '',
    this.fullName = '',
    this.tanggalLahir = '',
  });

  @override
  State<PengaturanProfilPage> createState() => _PengaturanProfilPageState();
}

class _PengaturanProfilPageState extends State<PengaturanProfilPage> {
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _tanggalLahirController;

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _tanggalLahirController = TextEditingController();
    _loadProfileData();
  }

  // =============================
  // LOAD PROFILE DARI LOGIN
  // =============================
  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final userJson = prefs.getString("user");
    if (userJson == null) return;

    final user = jsonDecode(userJson);

    setState(() {
      _fullNameController.text = user["fullname"] ?? widget.fullName;
      _usernameController.text = user["name"] ?? widget.username;
      _emailController.text = user["email"] ?? widget.email;
      _phoneController.text = user["phone"] ?? widget.phone;
      _tanggalLahirController.text = user["tanggal_lahir"] ?? widget.tanggalLahir;
    });
  }

  // =============================
  // UPDATE PROFIL
  // =============================
  Future<void> _saveProfile() async {
    setState(() => _loading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Anda belum masuk!")),
      );
      setState(() => _loading = false);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://192.168.110.68:8000/api/update-profile"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {
          "fullname": _fullNameController.text,
          "name": _usernameController.text,
          "email": _emailController.text,
          "phone": _phoneController.text,
          "tanggal_lahir": _tanggalLahirController.text,
        },
      );

      setState(() => _loading = false);

      if (response.statusCode == 200) {
        final updatedUser = {
          "fullname": _fullNameController.text,
          "name": _usernameController.text,
          "email": _emailController.text,
          "phone": _phoneController.text,
          "tanggal_lahir": _tanggalLahirController.text,
        };

        prefs.setString("user", jsonEncode(updatedUser));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update: ${response.body}")),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  // =============================
  // LOGOUT
  // =============================
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      await http.post(
        Uri.parse("http://192.168.110.68:8000/api/logout"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
    } catch (_) {}

    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType? keyboardType}) {
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
    final displayedName = _fullNameController.text.isNotEmpty
        ? _fullNameController.text
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
            // =============================
            // BAGIAN PALING ATAS (DISIMPILKAN NAMA + EMAIL SAJA)
            // =============================
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
                  Text(_emailController.text.isNotEmpty
                      ? _emailController.text
                      : "-"),
                ],
              ),
            ),

            const SizedBox(height: 12),
            _buildTextField("Nama Lengkap", _fullNameController),
            const SizedBox(height: 12),
            _buildTextField("Tanggal Lahir", _tanggalLahirController),
            const SizedBox(height: 12),
            _buildTextField("Nomor Telepon", _phoneController,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            _buildTextField("Email", _emailController,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            _buildTextField("Nama Pengguna", _usernameController),
            const SizedBox(height: 20),

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
              child: const Text("KELUAR"), 
            ),
          ],
        ),
      ),
    );
  }
}

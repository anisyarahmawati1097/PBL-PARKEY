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
        Uri.parse("http://172.20.10.3:8000/api/update-profile"),
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

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    try {
      await http.post(
        Uri.parse("http://172.20.10.3:8000/api/logout"),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // Avatar Profil
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF6A994E), width: 3),
                ),
                child: const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Nama
            Center(
              child: Text(
                displayedName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            // Email
            Center(
              child: Text(
                _emailController.text.isNotEmpty ? _emailController.text : "-",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),

            // Form Fields
            _buildTextField("Nama Lengkap", _fullNameController),
            _buildTextField("Tanggal Lahir", _tanggalLahirController),
            _buildTextField("Nomor Telepon", _phoneController, keyboardType: TextInputType.phone),
            _buildTextField("Email", _emailController, keyboardType: TextInputType.emailAddress),
            _buildTextField("Nama Pengguna", _usernameController),
            const SizedBox(height: 24),

            // Tombol Simpan
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A994E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _loading ? null : _saveProfile,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("SIMPAN", style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 12),
            // Tombol Keluar
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7272),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _logout,
              child: const Text("KELUAR", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

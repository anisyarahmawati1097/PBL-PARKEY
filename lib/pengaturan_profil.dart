import 'package:flutter/material.dart';

class PengaturanProfilPage extends StatefulWidget {
  // Terima data dari halaman Daftar (atau sumber lain).
  // Jika ada field yang belum dikirim, tetap aman karena ada default kosong.
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

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data yang diterima (atau kosong)
    _nameController = TextEditingController(text: widget.fullName.isNotEmpty ? widget.fullName : widget.username);
    _usernameController = TextEditingController(text: widget.username.isNotEmpty ? widget.username : widget.fullName);
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

  void _saveProfile() {
    // Untuk demo lokal: cukup update UI dan tunjukkan notifikasi.
    // Nanti bisa sambungkan penyimpanan ke SharedPreferences / API.
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil berhasil diperbarui")),
    );
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType, bool obscure = false}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Profil"),
        backgroundColor: const Color(0xFF6A994E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView( // gunakan ListView agar aman ketika keyboard muncul
          children: [
            ListTile(
              leading: const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 36, color: Colors.white),
              ),
              title: Text(
                _nameController.text.isNotEmpty ? _nameController.text : (_usernameController.text.isNotEmpty ? _usernameController.text : 'User'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_phoneController.text.isNotEmpty ? _phoneController.text : '-'),
                  Text(_emailController.text.isNotEmpty ? _emailController.text : '-'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Nama Lengkap (sesuai form daftar)
            _buildTextField("Nama Lengkap", _nameController),
            const SizedBox(height: 12),

            // Tanggal Lahir (sesuai form daftar)
            _buildTextField("Tanggal Lahir", _dobController, keyboardType: TextInputType.datetime),
            const SizedBox(height: 12),

            // Nomor Telepon
            _buildTextField("Nomor Telepon", _phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 12),

            // Email
            _buildTextField("Email", _emailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),

            // Nama Pengguna
            _buildTextField("Nama Pengguna", _usernameController),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A994E),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _saveProfile,
              child: const Text("SIMPAN"),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 114, 114),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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

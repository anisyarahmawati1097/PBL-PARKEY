import 'package:flutter/material.dart';
import 'tambah_kendaraan.dart';
import 'pengaturan_profil.dart';

class AkunPage extends StatefulWidget {
  final String username;
  final String email;

  const AkunPage({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  late String username;
  late String email;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    email = widget.email;
  }

  Widget _buildMenuCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF6A994E)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Akun"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A994E),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          // Foto profil
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          // Nama
          Center(
            child: Text(
              username,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 4),
          // Email
          Center(
            child: Text(
              email,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
          const SizedBox(height: 20),
          // Menu Card
          _buildMenuCard(
            icon: Icons.directions_car,
            title: "Tambah Kendaraan",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TambahKendaraanPage()),
              );
            },
          ),
          _buildMenuCard(
            icon: Icons.settings,
            title: "Pengaturan Profil",
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PengaturanProfilPage(
                    username: username,
                    email: email,
                  ),
                ),
              );

              if (result != null && result is Map<String, String>) {
                setState(() {
                  username = result['username'] ?? username;
                  email = result['email'] ?? email;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}

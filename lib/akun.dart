import 'package:flutter/material.dart';
import 'tambah_kendaraan.dart';
import 'pengaturan_profil.dart';

class AkunPage extends StatelessWidget {
  final String username;
  final String email;

  const AkunPage({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akun"),
        backgroundColor: const Color(0xFF6A994E),
      ),
      body: ListView(
        children: [
          // Header akun
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(username),
            subtitle: Text(email),
          ),
          const Divider(),

          // Tambah Kendaraan
          ListTile(
            leading: const Icon(Icons.directions_car, color: Colors.green),
            title: const Text("Tambah Kendaraan"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TambahKendaraanPage(), // tanpa const
                ),
              );
            },
          ),

          // Pengaturan Profil
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.green),
            title: const Text("Pengaturan Profil"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PengaturanProfilPage(), // tanpa const
                ),
              );
            },
          ),

          const Divider(),

        
        ],
      ),
    );
  }
}

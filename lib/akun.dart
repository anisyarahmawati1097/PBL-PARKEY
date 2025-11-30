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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Akun"),
        backgroundColor: const Color(0xFF6A994E),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(username),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(email),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.directions_car, color: Colors.green),
            title: const Text("Tambah Kendaraan"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TambahKendaraanPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.green),
            title: const Text("Pengaturan Profil"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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

              // Jika result tidak null, update data akun
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

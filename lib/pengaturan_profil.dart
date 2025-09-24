import 'package:flutter/material.dart';

class PengaturanProfilPage extends StatelessWidget {
  const PengaturanProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akun"),
        backgroundColor: const Color(0xFF6A994E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header profil
            const ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 36, color: Colors.white),
              ),
              title: Text("raniyaa",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("6281234567890"),
                  Text("example@email.com"),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Form Nama
            TextField(
              decoration: InputDecoration(
                labelText: "Nama",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Form Nomor Telepon
            TextField(
              decoration: InputDecoration(
                labelText: "Nomor Telepon",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Form Email
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Form Tanggal Lahir
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Tanggal Lahir",
                filled: true,
                fillColor: Colors.grey[200],
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                // bisa tambahin date picker nanti
              },
            ),
            const SizedBox(height: 20),

            // Tombol Simpan
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A994E),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profil berhasil diperbarui")),
                );
              },
              child: const Text("SIMPAN"),
            ),
            const SizedBox(height: 12),

            // Tombol Logout
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("LOGOUT"),
            ),
          ],
        ),
      ),
    );
  }
}

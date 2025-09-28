import 'package:flutter/material.dart';
import 'data.dart';

class PengendaraPage extends StatelessWidget {
  const PengendaraPage({super.key});

  Widget _buildPengendaraCard(String nama, String kendaraan, String noPlat) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: const Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(nama,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text("$kendaraan\n$noPlat"),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // fitur detail / edit nanti bisa ditambahkan
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("👥 Data Pengendara",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          _buildPengendaraCard("Andi Saputra", "Motor - Honda Beat", "BP 1234 XY"),
          _buildPengendaraCard("Budi Santoso", "Mobil - Toyota Avanza", "BP 9876 ZZ"),
          _buildPengendaraCard("Siti Aminah", "Motor - Yamaha Nmax", "BP 5678 AB"),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'data.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  Widget _buildLaporanCard(String judul, String isi, String tanggal) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: const Icon(Icons.report, color: Colors.red, size: 32),
        title: Text(judul,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text("$isi\n$tanggal",
            maxLines: 2, overflow: TextOverflow.ellipsis),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            // fitur tindak lanjut laporan nanti bisa ditambahkan
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
          const Text("📑 Daftar Laporan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          _buildLaporanCard(
              "Laporan Parkir Penuh",
              "Area parkir Grand Batam Mall penuh pada pukul 19:00",
              "27 Sep 2025"),
          _buildLaporanCard(
              "Gangguan Sistem",
              "Mesin tiket parkir di SNL Food tidak berfungsi",
              "26 Sep 2025"),
          _buildLaporanCard(
              "Laporan Pelanggaran",
              "Pengendara parkir di area terlarang",
              "25 Sep 2025"),
        ],
      ),
    );
  }
}

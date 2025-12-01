import 'package:flutter/material.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  Widget _buildLaporanKunjungan({
    required String tanggal,
    required int totalKunjungan,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: const Icon(Icons.calendar_month, color: Colors.blue, size: 34),
        title: Text(
          tanggal,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          "Total Kunjungan: $totalKunjungan",
          style: const TextStyle(fontSize: 15),
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
          const Text(
            "Laporan Harian Kunjungan Parkir",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Contoh data
          _buildLaporanKunjungan(
            tanggal: "30 November 2025",
            totalKunjungan: 145,
          ),
          _buildLaporanKunjungan(
            tanggal: "29 November 2025",
            totalKunjungan: 132,
          ),
          _buildLaporanKunjungan(
            tanggal: "28 November 2025",
            totalKunjungan: 158,
          ),
        ],
      ),
    );
  }
}

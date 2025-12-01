import 'package:flutter/material.dart';

class LokasiPageAdmin extends StatelessWidget {
  const LokasiPageAdmin({super.key});

  Widget _buildLokasiSummary(String nama,
      {required int total, required int occupied}) {
    final kosong = total - occupied;
    final persen = ((occupied / total) * 100).toStringAsFixed(0);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text("Total Slot: $total"),
                Text("Terisi: $occupied | Kosong: $kosong"),
              ],
            ),

            Column(
              children: [
                Text(
                  "$persen%",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: occupied / total > 0.7
                        ? Colors.red
                        : Colors.green[700],
                  ),
                ),
                const Text("Terisi"),
              ],
            ),
          ],
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
            "Lokasi Parkir",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Copy dari dashboard
          _buildLokasiSummary(
            "Grand Mall",
            total: 12,
            occupied: 4,
          ),
          const SizedBox(height: 12),

          _buildLokasiSummary(
            "SNL Food",
            total: 8,
            occupied: 3,
          ),
        ],
      ),
    );
  }
}

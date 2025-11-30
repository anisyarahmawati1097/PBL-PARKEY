import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  final List<Map<String, dynamic>> riwayat;

  const RiwayatPage({super.key, required this.riwayat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A994E),
        title: const Text("Riwayat Parkir", style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        centerTitle: true,
      ),
      body: riwayat.isEmpty
          ? const Center(
              child: Text("Belum ada riwayat parkir", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: riwayat.length,
              itemBuilder: (context, i) {
                final item = riwayat[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_parking, color: Color(0xFF386641)),
                          const SizedBox(width: 8),
                          Text(item["lokasi"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF386641))),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text("${item['merek']} - ${item['plat']}"),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.login, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text("Masuk: ${item["jamMasuk"]}"),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.logout, color: Colors.red),
                          const SizedBox(width: 8),
                          Text("Keluar: ${item["jamKeluar"]}"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.timer_outlined, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text("Durasi: ${item["durasi"]}"),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.payments_outlined, color: Colors.purple),
                          const SizedBox(width: 8),
                          Text("Biaya: Rp ${item["total"]}", style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

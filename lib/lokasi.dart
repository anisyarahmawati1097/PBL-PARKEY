import 'package:flutter/material.dart';

class LokasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B8E4E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Lokasi",
          style: TextStyle(color: Colors.white),
        ),
      ),

      // 🔥 pakai ListView biar scroll & tidak overflow
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const Text(
              "Tempat parkir yang tersedia",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),

            // --- Card Lokasi 1 ---
            lokasiCard(
              "Grand Batam Mall",
              "Jl. Pembangunan, Batu Selicin, Kec. Lubuk Baja, Kota Batam",
              "2.2 Km",
              "assets/gm.jpeg",
            ),

            const SizedBox(height: 12),

            // --- Card Lokasi 2 ---
            lokasiCard(
              "SNL Food Tanjung Uma",
              "Jodoh, kawasan baru, priyangan Jl. Tj Uma, Kota Batam",
              "3.2 Km",
              "assets/snl.jpg",
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk card lokasi
  Widget lokasiCard(String nama, String alamat, String jarak, String assetGambar) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              assetGambar, // ✅ ambil dari assets
              width: 100,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    alamat,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    jarak,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

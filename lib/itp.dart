import 'package:flutter/material.dart';

class ItpPage extends StatelessWidget {
  final String nama;
  final String alamat;
  final String gambar;
  final String deskripsi;
  final String tarifMotor;
  final String tarifMobil;
  final String tarifPickup;
  final String tarifTruk; 

  const ItpPage({
    super.key,
    required this.nama,
    required this.alamat,
    required this.gambar,
    required this.deskripsi,
    required this.tarifMotor,
    required this.tarifMobil,
    required this.tarifPickup,
    required this.tarifTruk,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FAF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B8E4E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          nama,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar + Nama Lokasi
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child: Image.asset(
                      gambar,
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(nama,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(alamat,
                            style: const TextStyle(
                                fontSize: 13, color: Colors.black54)),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(Icons.local_parking,
                                color: Colors.black54, size: 18),
                            SizedBox(width: 6),
                            Text("Parkir",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54)),
                            Spacer(),
                            Icon(Icons.star, color: Colors.orange, size: 18),
                            Icon(Icons.star, color: Colors.orange, size: 18),
                            Icon(Icons.star, color: Colors.orange, size: 18),
                            Icon(Icons.star, color: Colors.orange, size: 18),
                            Icon(Icons.star_border,
                                color: Colors.orange, size: 18),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tentang Fasilitas
            const Text(
              "Tentang Fasilitas Ini",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Text(
              deskripsi,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),

            const SizedBox(height: 20),

            // Harga
            const Text(
              "Harga",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),

            const Text(
              "Tarif Motor",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              tarifMotor,
              style: const TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 12),

            const Text(
              "Tarif Mobil",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              tarifMobil,
              style: const TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 12),

            const Text(
              "Tarif Pickup",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              tarifPickup,
              style: const TextStyle(fontSize: 13),
            ),

            const SizedBox(height: 12),

            const Text(
              "Tarif Truk",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              tarifTruk,
              style: const TextStyle(fontSize: 13), 
            ),
          ],
        ),
      ),
    );
  }
}

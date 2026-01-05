import 'package:flutter/material.dart';
import 'itp.dart';

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
              context,
              "Grand Batam Mall",
              "Jl. Pembangunan, Batu Selicin, Kec. Lubuk Baja, Kota Batam",
              "assets/gm.jpeg",
              deskripsi:
                  "Operated by Centrepark. Lokasi strategis di pusat kota Batam dengan akses mudah ke area perbelanjaan.",
              tarifMotor:
                  "2 Jam Pertama IDR 2000\nJam Berikutnya IDR 1000/Jam",
              tarifMobil:
                  "2 Jam Pertama IDR 4000\nJam Berikutnya IDR 2000/Jam",
              tarifPickup:
                  "2 Jam Pertama IDR 6000\nJam Berikutnya IDR 3000/Jam",
              tarifTruk:
                  "2 Jam Pertama IDR 31020\nJam Berikutnya IDR 4000/Jam",
            ),

            const SizedBox(height: 12),

            // --- Card Lokasi 2 ---
            lokasiCard(
              context,
              "SNL Food Tanjung Uma",
              "Jodoh, kawasan baru, priyangan Jl. Tj Uma, Kota Batam",
              "assets/snl.jpg",
              deskripsi:
                  "Tempat parkir dekat pusat kuliner Tanjung Uma, ramai setiap malam dan aman untuk motor maupun mobil.",
              tarifMotor:
                  "1 Jam Pertama IDR 1000\nJam Berikutnya IDR 1000/Jam",
              tarifMobil:
                  "1 Jam Pertama IDR 3000\nJam Berikutnya IDR 2000/Jam",
              tarifPickup:
                  "1 Jam Pertama IDR 5000\nJam Berikutnya IDR 3000/Jam",
              tarifTruk:
                  "1 Jam Pertama IDR 7000\nJam Berikutnya IDR 4000/Jam",
            ),
          ],
        ),
      ),
    );
  }

  // 🟢 Widget untuk card lokasi (tanpa jarak)
  Widget lokasiCard(
    BuildContext context,
    String nama,
    String alamat,
    String assetGambar, {
    required String deskripsi,
    required String tarifMobil,
    required String tarifMotor,
    required String tarifPickup,
    required String tarifTruk,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItpPage(
              nama: nama,
              alamat: alamat,
              gambar: assetGambar,
              deskripsi: deskripsi,
              tarifMobil: tarifMobil,
              tarifMotor: tarifMotor,
              tarifPickup: tarifPickup,
              tarifTruk: tarifTruk,
            ),
          ),
        );
      },
      child: Card(
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
                assetGambar,
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
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

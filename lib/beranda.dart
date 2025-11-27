import 'package:flutter/material.dart';
import 'aktivitas.dart';
import 'dompet.dart';
import 'akun.dart';
import 'lokasi.dart';
import 'bc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class BerandaPage extends StatefulWidget {
  final String? username;
  final String? email;

  const BerandaPage({super.key, this.username, this.email});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  Map<String, dynamic>? kendaraanTerbaru;

  @override
  void initState() {
    super.initState();
    fetchKendaraanTerbaru(); // panggil saat halaman dibuka
  }

  // Fungsi fetchKendaraanTerbaru taruh di sini
  Future<void> fetchKendaraanTerbaru() async {
    final response = await http.get(Uri.parse("http://192.168.115.131:8000/api/kendaraan/store"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      if (data.isNotEmpty) {
        setState(() {
          kendaraanTerbaru = data.last; // ambil kendaraan terakhir
        });
      }
    } else {
      print("Gagal mengambil data kendaraan: ${response.statusCode}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A994E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A994E),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/logo_parqrin.png',
              height: 32,
              width: 32,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Halo, ${widget.username ?? 'User'}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Mau kemana hari ini?",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _buildBerandaContent(),
    );
  }

  Widget _buildBerandaContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFE0FFC2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.black54),
                hintText: "Cari Tempat Parkir",
                border: InputBorder.none,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LokasiPage(),
                            ),
                          );
                        },
                        child: Column(
                          children: const [
                            Icon(Icons.location_on, size: 40, color: Colors.black87),
                            SizedBox(height: 6),
                            Text(
                              "Lokasi",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                     GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QRCodePage(
          kendaraan: kendaraanTerbaru ?? {
            "id": 0,
            "plat_nomor": "Tidak ada",
          },
        ),
      ),
    );
  },
  child: Column(
    children: const [
      Icon(Icons.qr_code, size: 40, color: Colors.black87),
      SizedBox(height: 6),
      Text(
        "QR",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    ],
  ),
),

                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Tempat parkir terakhir dikunjungi",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _buildParkirCard(
                    "Grand Batam Mall",
                    "Jl. Pembangunan, Batu Selicin, Kec. Lubuk Baja, Kota Batam",
                    "assets/gm.jpeg",
                  ),

                  _buildParkirCard(
                    "SNL Food Tanjung Uma",
                    "Jodoh, kawasan baru phrayangan, Jl. Tj Uma, Kota Batam",
                    "assets/snl.jpg",
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildParkirCard(
    String title,
    String subtitle,
    String imagePath,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 75,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

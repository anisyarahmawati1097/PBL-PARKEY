import 'package:flutter/material.dart';
import 'aktivitas.dart';
import 'riwayat.dart';
import 'akun.dart';
import 'lokasi.dart';
import 'bc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'daftarkendaraan.dart';

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
    fetchKendaraanTerbaru();
  }

  Future<void> fetchKendaraanTerbaru() async {
    final response =
        await http.get(Uri.parse("http://192.168.217.134:8000/api/kendaraan"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      if (data != null && data.isNotEmpty) {
        setState(() {
          kendaraanTerbaru = data.last;
        });
      }
    } else {
      print("Gagal mengambil data kendaraan: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A994E), // solid background
      body: SafeArea(
        child: Column(
          children: [
            // Header solid color
            Container(
              color: const Color(0xFF6A994E), // solid hijau
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo_parqrin.png',
                    height: 70,
                    width: 70,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Halo, ${widget.username ?? 'User'} 👋",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Mau kemana hari ini?",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Container putih bawah
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white, // solid putih
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
                      // Tombol Lokasi & QR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _iconButton(
                            icon: Icons.location_on,
                            label: "Lokasi",
                            color: Colors.green,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => LokasiPage()),
                              );
                            },
                          ),
                          _iconButton(
                            icon: Icons.qr_code,
                            label: "QR",
                            color: Colors.orange,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => DaftarKendaraanPage()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      // Judul daftar parkir
                      const Text(
                        "Tempat parkir terakhir dikunjungi",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // List parkir
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
                      const SizedBox(height: 20),
                  
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      
    );
  }

  Widget _iconButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 36, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildParkirCard(String title, String subtitle, String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000), // shadow sangat ringan, bukan gradasi
            blurRadius: 4,
            offset: Offset(0, 2),
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
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
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

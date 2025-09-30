import 'package:flutter/material.dart';
import 'aktivitas.dart';
import 'dompet.dart';
import 'akun.dart';
import 'lokasi.dart';
import 'bc.dart';
import 'itp.dart'; // import halaman detail

class BerandaPage extends StatefulWidget {
  final String? username;
  final String? email;

  const BerandaPage({super.key, this.username, this.email});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) {
      setState(() => _selectedIndex = 0);
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AktivitasPage()),
      );
    } else if (index == 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fitur Bayar belum tersedia")),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DompetPage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AkunPage(
            username: widget.username ?? "User",
            email: widget.email ?? "user@email.com",
          ),
        ),
      );
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
            Image.asset("assets/logo_parqrin.png", height: 32),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Halo, ${widget.username ?? 'User'}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const SizedBox(height: 4),
                const Text("Mau kemana hari ini?",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
      body: _buildBerandaContent(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF386641),
        selectedItemColor: const Color(0xFFE0FFC2),
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Aktivitas"),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: "Bayar"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Dompet"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
      ),
    );
  }

  Widget _buildBerandaContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE0FFC2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: const [
                Icon(Icons.credit_card, color: Colors.black),
                SizedBox(width: 12),
                Expanded(
                  child: Text("CARD",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text("IDR -", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.black),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0FFC2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.search, color: Colors.black54),
                        hintText: "Cari Tempat Parkir",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LokasiPage()),
                          );
                        },
                        child: Column(children: const [
                          Icon(Icons.location_on, size: 34),
                          SizedBox(height: 6),
                          Text("Lokasi")
                        ]),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QRCodePage(),
                            ),
                          );
                        },
                        child: Column(children: const [
                          Icon(Icons.qr_code, size: 34),
                          SizedBox(height: 6),
                          Text("QR")
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  const Text("Tempat parkir yang tersedia",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  _buildParkirCard(
                    "Grand Batam Mall",
                    "Jl. Pembangunan, Batu Selicin, Kec. Lubuk Baja, Kota Batam",
                    "assets/gm.jpeg",
                    "2.2 Km",
                    deskripsi:
                        "Operated by Centrepark. Lokasi strategis di pusat kota Batam.",
                    tarifMobil:
                        "2 Jam Pertama IDR 5000\nJam Berikutnya IDR 2000/Jam",
                    tarifMotor:
                        "2 Jam Pertama IDR 2000\nJam Berikutnya IDR 1000/Jam",
                  ),
                  _buildParkirCard(
                    "SNL Food Tanjung Uma",
                    "Jodoh, kawasan baru priayang, Jl. Tj Uma, Kota Batam",
                    "assets/snl.jpg",
                    "3.2 Km",
                    deskripsi:
                        "Tempat parkir dekat pusat kuliner Tanjung Uma, ramai setiap malam.",
                    tarifMobil:
                        "1 Jam Pertama IDR 4000\nJam Berikutnya IDR 2000/Jam",
                    tarifMotor:
                        "1 Jam Pertama IDR 1500\nJam Berikutnya IDR 1000/Jam",
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
    String distance, {
    required String deskripsi,
    required String tarifMobil,
    required String tarifMotor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ItpPage(
              nama: title,
              alamat: subtitle,
              gambar: imagePath,
              deskripsi: deskripsi,
              tarifMobil: tarifMobil,
              tarifMotor: tarifMotor,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 6,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 86,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(distance,
                      style: const TextStyle(color: Colors.blue)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

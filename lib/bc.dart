import 'package:flutter/material.dart';

class QRCodePage extends StatelessWidget {
  final Map<String, dynamic> kendaraan;
  const QRCodePage({super.key, required this.kendaraan});

  @override
  Widget build(BuildContext context) {
    // Ambil data dengan aman
    final String kendaraanId = kendaraan["id"]?.toString() ?? "0";
    final String nomorKendaraan =
        kendaraan["plat_nomor"]?.toString() ?? "Tidak ada";
    final String qrPath = kendaraan["qris"];
    // Data QR

    return Scaffold(
      backgroundColor: const Color(0xFF6A994E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A994E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
        title: const Text(
          "QR Code",
          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            color: const Color(0xFF6A994E),
            child: const Text(
              "QR Code ini digunakan pada saat masuk \n"
              "dan keluar dari pusat perbelanjaan.\n"
              "Silahkan Scan QR Code ini",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
          ),
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
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'http://192.168.217.134:8000/' + qrPath,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      nomorKendaraan,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class QRCodePage extends StatelessWidget {
  final Map<String, dynamic> kendaraan;
  const QRCodePage({super.key, required this.kendaraan});

  @override
  Widget build(BuildContext context) {
    // Ambil data dengan aman
    final String nomorKendaraan =
        kendaraan["plat_nomor"]?.toString() ?? "Tidak ada";
    final String qrPath = kendaraan["qris"] ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFF6A994E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A994E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "QR Code",
          style: TextStyle(color: Colors.black),
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
                color: Colors.black,
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
                      'http://151.243.222.93:31020/' + qrPath,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),

                    // Nomer kendaraan
                    Text(
                      nomorKendaraan,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),

                    const SizedBox(height: 10),
                  
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

import 'package:flutter/material.dart';

class QRCodePage extends StatelessWidget {
  const QRCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A994E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A994E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "QR Code",
          style: TextStyle(color: Colors.white),
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
              textAlign: TextAlign.left, // sejajar kiri
              style: TextStyle(color: Colors.white, fontSize: 18), // font diperbesar
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
                    // langsung QR code tanpa Container
                    Image.asset(
                      "assets/bc.png",
                      width: 400,   // lebih besar
                      height: 400,  // lebih besar
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "BP 1234 JH",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20, // teks diperbesar
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

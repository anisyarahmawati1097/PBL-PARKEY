import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main_screen.dart';

class BayarPage extends StatefulWidget {
  final String parkirId;

  const BayarPage({super.key, required this.parkirId});

  @override
  State<BayarPage> createState() => _BayarPageState();
}

class _BayarPageState extends State<BayarPage> {
  final String baseUrl = "http://151.243.222.93:31020";

  int totalPembayaran = 0;
  String paymentStatus = "pending";
  String invoiceId = "";
  String qrUrl = "";

  @override
  void initState() {
    super.initState();
    fetchPembayaran();
  }

  // ===========================
  // GET PEMBAYARAN
  // ===========================
  Future<void> fetchPembayaran() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    final url = Uri.parse("$baseUrl/api/pembayaran/${widget.parkirId}");

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final data = body['data'] ?? {};
        final payment = data['payment'] ?? {};

        setState(() {
          totalPembayaran = data['harga'] ?? 0;
          invoiceId = payment['invoice_id'] ?? "";
          paymentStatus = payment['status'] ?? "pending";
          qrUrl = "$baseUrl/${payment['link_payment']}";
        });
      } else {
        Get.snackbar("Error", "Pembayaran tidak ditemukan");
      }
    } catch (_) {
      Get.snackbar("Error", "Gagal mengambil data pembayaran");
    }
  }

  // ===========================
  // OPEN QR
  // ===========================
  Future<void> openPayment() async {
    if (qrUrl.isEmpty || paymentStatus == "settlement") return;

    final uri = Uri.parse(qrUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Error", "Gagal membuka QRIS");
    }
  }

  // ===========================
  // REFRESH STATUS
  // ===========================
  Future<void> refreshStatus() async {
    if (invoiceId.isEmpty) return;

    final url = Uri.parse("$baseUrl/api/status/$invoiceId");

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      setState(() {
        paymentStatus = data['status'] ?? paymentStatus;
      });

      if (paymentStatus == "settlement") {
        Get.snackbar(
          "Berhasil",
          "Pembayaran berhasil",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (_) {
      Get.snackbar("Error", "Gagal cek status");
    }
  }

  // ===========================
  // STATUS
  // ===========================
  Color getStatusColor() {
    return paymentStatus == "settlement"
        ? const Color(0xFF6A994E)
        : Colors.red;
  }

  String getStatusText() {
    return paymentStatus == "settlement"
        ? "Sudah Dibayar"
        : "Belum Dibayar";
  }

  // ===========================
  // UI
  // ===========================
  @override
  Widget build(BuildContext context) {
    final bool sudahDibayar = paymentStatus == "settlement";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran Parkir"),
        backgroundColor: const Color(0xFF6A994E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Image.network(
              qrUrl,
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            const Text(
              "Scan QR untuk melanjutkan pembayaran",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // ===== BUKA QRIS =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: sudahDibayar ? null : openPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A994E),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Buka QRIS"),
              ),
            ),

            const SizedBox(height: 25),

            // ===== INFO PEMBAYARAN =====
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text("Total"),
                          Text(
                            "Rp $totalPembayaran",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6A994E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Card(
                    color: getStatusColor().withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text("Pembayaran"),
                          Text(
                            getStatusText(),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: getStatusColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ===== MUAT ULANG STATUS =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: refreshStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Muat Ulang Status"),
              ),
            ),

            const SizedBox(height: 15),

            // ===== SELESAI =====
            if (sudahDibayar)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Hapus semua page sampai MainScreen
                    Navigator.popUntil(context, (route) => route.isFirst);

                    // Panggil MainScreen dengan riwayat
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(),
                        settings: const RouteSettings(arguments: "riwayat"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A994E),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Selesai"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

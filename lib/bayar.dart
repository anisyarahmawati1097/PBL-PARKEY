import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BayarPage extends StatefulWidget {
  final String parkirId;

  const BayarPage({super.key, required this.parkirId});

  @override
  State<BayarPage> createState() => _BayarPageState();
}

class _BayarPageState extends State<BayarPage> {
  final String baseUrl = "http://172.20.10.3:8000";

  int totalPembayaran = 0;
  String paymentStatus = "pending";
  String invoiceId = "";
  String qrUrl = ""; // 🔥 URL QRIS MIDTRANS

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
        print("BODY : $body");

        final data = body['data'] ?? {};
        final payment = data['payment'] ?? {};

        final qr_link = payment['link_payment'];
        setState(() {
          totalPembayaran = data['harga'] ?? 0;
          invoiceId = payment['invoice_id'] ?? "";
          paymentStatus = payment['status'] ?? "pending";

          // 🔥 SIMPAN URL QRIS APA ADANYA
          
          qrUrl = "$baseUrl/$qr_link";
        });
      } else {
        Get.snackbar("Error", "Pembayaran tidak ditemukan");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data pembayaran");
    }
  }

  // ===========================
  // OPEN QR (BROWSER / EWALLET)
  // ===========================
  Future<void> openPayment() async {
    if (qrUrl.isEmpty) {
      Get.snackbar("Info", "QR pembayaran belum tersedia");
      return;
    }

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
        Get.off(() => const BayarSukses());
      }
    } catch (_) {
      Get.snackbar("Error", "Gagal cek status");
    }
  }

  Color getStatusColor() {
    switch (paymentStatus) {
      case "pending":
        return Colors.orange;
      case "settlement":
        return const Color(0xFF6A994E);
      default:
        return Colors.red;
    }
  }

  // ===========================
  // UI
  // ===========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran Parkir"),
        backgroundColor: const Color(0xFF6A994E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ================= QR IMAGE =================
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
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // ================= OPEN BUTTON =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: openPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A994E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Buka QRIS", style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 25),

            // ================= TOTAL & STATUS =================
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
                          const Text("Status"),
                          Text(
                            paymentStatus.toUpperCase(),
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

            // ================= REFRESH =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: invoiceId.isEmpty ? null : refreshStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Refresh Status"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================
// HALAMAN SUKSES
// =========================
class BayarSukses extends StatelessWidget {
  const BayarSukses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, size: 120, color: Color(0xFF6A994E)),
            const SizedBox(height: 20),
            const Text(
              "Pembayaran Berhasil!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () => Get.offAllNamed('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A994E),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
              ),
              child: const Text("Kembali ke Beranda"),
            ),
          ],
        ),
      ),
    );
  }
}

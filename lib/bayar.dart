import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BayarPage extends StatefulWidget {
  final String parkirId;

  const BayarPage({
    super.key,
    required this.parkirId,
  });

  @override
  State<BayarPage> createState() => _BayarPageState();
}

class _BayarPageState extends State<BayarPage> {
  final String baseUrl = "http://192.168.156.134:8000/";

  int totalPembayaran = 0;
  String paymentStatus = "pending";
  String invoiceId = "";
  String qrisUrl = "";

  @override
  void initState() {
    super.initState();
    fetchPembayaran();
  }

  // ===========================
  // GET PEMBAYARAN + QRIS
  // ===========================
  Future<void> fetchPembayaran() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final url =
        Uri.parse("${baseUrl}api/pembayaran/${widget.parkirId}");

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
          totalPembayaran = data['total_harga'] ?? 0;
          invoiceId = payment['invoice_id'] ?? "";
          paymentStatus = payment['status'] ?? "pending";

          final linkPayment = payment['link_payment'];
qrisUrl = linkPayment != null && linkPayment.toString().isNotEmpty
    ? "$baseUrl$linkPayment"
    : "";

        });
      } else {
        Get.snackbar(
          "Error",
          "Pembayaran tidak ditemukan (${response.statusCode})",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil data pembayaran");
    }
  }

  // ===========================
  // REFRESH STATUS
  // ===========================
  Future<void> refreshStatus() async {
    if (invoiceId.isEmpty) return;

    final url = Uri.parse("${baseUrl}api/status/$invoiceId");

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      setState(() {
        paymentStatus =
            data['status']?.toString() ?? paymentStatus;
      });

      if (paymentStatus == "settlement") {
        Get.off(() => const BayarSukses());
      }
    } catch (_) {
      Get.snackbar("Error", "Tidak dapat memeriksa status");
    }
  }

  // ===========================
  // STATUS COLOR
  // ===========================
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
  // QRIS WIDGET (FIXED)
  // ===========================
  Widget buildQris() {
    if (qrisUrl.isEmpty) {
      return Column(
        children: const [
          Icon(Icons.qr_code, size: 120, color: Colors.grey),
          SizedBox(height: 8),
          Text("QRIS belum tersedia"),
        ],
      );
    }

    return Image.network(
      qrisUrl,
      height: 280,
      width: 280,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.error, size: 80),
    );
  }

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
            const Text(
              "Scan QRIS untuk melakukan pembayaran",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),

            // ================= QRIS =================
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    buildQris(),
                    const SizedBox(height: 12),
                    Text(
                      "Invoice: ${invoiceId.isEmpty ? '-' : invoiceId}",
                    ),
                  ],
                ),
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

            const SizedBox(height: 30),

            // ================= REFRESH =================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    invoiceId.isEmpty ? null : refreshStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF6A994E),
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  "Refresh Status",
                  style: TextStyle(fontSize: 18),
                ),
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
            const Icon(
              Icons.check_circle,
              size: 120,
              color: Color(0xFF6A994E),
            ),
            const SizedBox(height: 20),
            const Text(
              "Pembayaran Berhasil!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () =>
                  Get.offAllNamed('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF6A994E),
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

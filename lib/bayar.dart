import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BayarPage extends StatefulWidget {
  final int parkirId;
  final int nominal;

  const BayarPage({super.key, required this.parkirId, required this.nominal});

  @override
  State<BayarPage> createState() => _BayarPageState();
}

class _BayarPageState extends State<BayarPage> {
  String invoiceId = "INV-2025001";
  String paymentStatus = "pending";
  late int totalPembayaran;
  String qrisImage =
      "https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=DUMMY_QRIS_MIDTRANS";
  int countdown = 180;
  late final Ticker ticker;

  @override
  void initState() {
    super.initState();
    totalPembayaran = widget.nominal;
    ticker = Ticker();
    ticker.start(
      duration: const Duration(seconds: 180),
      onTick: (sec) => setState(() => countdown = sec),
      onFinish: () => setState(() => paymentStatus = "expired"),
    );
  }

  @override
  void dispose() {
    ticker.stop();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Pembayaran Parkir"),
        centerTitle: true,
        backgroundColor: const Color(0xFF6A994E),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Instruction
            const Text(
              "Scan QRIS untuk melakukan pembayaran",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),

            // QRIS Card
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Image.network(
                        qrisImage,
                        height: 250,
                        errorBuilder: (c, e, s) =>
                            const Icon(Icons.error, size: 80),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Invoice: $invoiceId",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Total Payment Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Column(
                  children: [
                    const Text(
                      "Total Pembayaran",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Rp $totalPembayaran",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A994E),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Payment Status Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: getStatusColor().withOpacity(0.15),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Column(
                  children: [
                    const Text(
                      "Status Pembayaran",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
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
            const SizedBox(height: 20),

            // Countdown Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Column(
                  children: [
                    const Text(
                      "QR berlaku sampai:",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "${countdown ~/ 60}:${(countdown % 60).toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Refresh / Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (paymentStatus == "pending") {
                    setState(() => paymentStatus = "settlement");
                  }
                  if (paymentStatus == "settlement") {
                    Get.to(() => const BayarSukses());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A994E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Refresh Status",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Ticker sederhana
class Ticker {
  int seconds = 0;
  bool running = false;

  void start({
    required Duration duration,
    required Function(int) onTick,
    required Function() onFinish,
  }) async {
    seconds = duration.inSeconds;
    running = true;
    while (running && seconds > 0) {
      await Future.delayed(const Duration(seconds: 1));
      seconds--;
      onTick(seconds);
    }
    if (seconds <= 0) onFinish();
  }

  void stop() {
    running = false;
  }
}

class BayarSukses extends StatelessWidget {
  const BayarSukses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF6A994E), size: 120),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                "Kembali ke Beranda",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

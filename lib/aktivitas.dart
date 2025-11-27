import 'package:flutter/material.dart';
import 'dart:async';

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  // 🔹 Data dummy untuk aktivitas parkir aktif
  final String tempatParkirAktif = "Grand Batam Mall";
  final DateTime waktuMasukAktif =
      DateTime.now().subtract(const Duration(minutes: 37, seconds: 42));

  // 🔹 Data dummy untuk riwayat parkir
  final List<Map<String, dynamic>> riwayatParkir = [
    {
      'tempat': 'SNL Food Tanjung Uma',
      'masuk': DateTime.now().subtract(const Duration(hours: 4, minutes: 15)),
      'keluar': DateTime.now().subtract(const Duration(hours: 3, minutes: 5)),
    },
    {
      'tempat': 'Grand Batam Mall',
      'masuk': DateTime.now().subtract(const Duration(days: 1, hours: 2, minutes: 30)),
      'keluar': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 40)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsed = DateTime.now().difference(waktuMasukAktif);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  int _hitungTarif(Duration durasi) {
    const int tarifAwal = 2000;
    const int tarifPerJam = 1000;
    final totalJam = (durasi.inMinutes / 60).ceil();
    if (totalJam <= 1) return tarifAwal;
    return tarifAwal + ((totalJam - 1) * tarifPerJam);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2FAF5),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF6A994E),    
          title: const Text(
            "Aktivitas",
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: "Aktivitas"),
              Tab(text: "Riwayat"),
            ],
          ),
        ),

        // 🟩 Body Tab
        body: TabBarView(
          children: [
            // === TAB 1: Aktivitas Sedang Berlangsung ===
            Center(
              child: Card(
                margin: const EdgeInsets.all(20),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Aktivitas Sedang Berlangsung",
                        style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Icon(Icons.local_parking, color: Colors.green),
                          const SizedBox(width: 10),
                          Text(
                            tempatParkirAktif,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.orange),
                          const SizedBox(width: 10),
                          Text(
                            "Masuk: ${waktuMasukAktif.hour.toString().padLeft(2, '0')}:${waktuMasukAktif.minute.toString().padLeft(2, '0')} WIB",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.timer, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(
                            "Durasi: ${_formatDuration(_elapsed)}",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.exit_to_app),
                          label: const Text("Akhiri Parkir"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B8E4E),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            // === TAB 2: Riwayat Parkir ===
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: riwayatParkir.length,
              itemBuilder: (context, index) {
                final data = riwayatParkir[index];
                final durasi = data['keluar'].difference(data['masuk']);
                final tarif = _hitungTarif(durasi);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.local_parking,
                        color: Color(0xFF6B8E4E)),
                    title: Text(data['tempat']),
                    subtitle: Text(
                      "Masuk: ${data['masuk'].hour.toString().padLeft(2, '0')}:${data['masuk'].minute.toString().padLeft(2, '0')} WIB\n"
                      "Keluar: ${data['keluar'].hour.toString().padLeft(2, '0')}:${data['keluar'].minute.toString().padLeft(2, '0')} WIB\n"
                      "Durasi: ${_formatDuration(durasi)}\n"
                      "Tarif: Rp $tarif",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

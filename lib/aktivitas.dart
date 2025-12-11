import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AktivitasPage extends StatefulWidget {
  const AktivitasPage({super.key});

  @override
  State<AktivitasPage> createState() => _AktivitasPageState();
}

class _AktivitasPageState extends State<AktivitasPage> {
  List<Map<String, dynamic>> aktivitas = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchAktivitas();

    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchAktivitas();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchAktivitas() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token") ?? "";

  if (token.isEmpty) return;

  final url = Uri.parse("http://192.168.217.134:8000/api/aktivitas-pengendara");

  try {
    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      },
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);

      if (body["status"] == "success") {
        final List<dynamic> listKendaraan = body["data"] ?? [];

        List<Map<String, dynamic>> temp = [];

        // LOOP SEMUA KENDARAAN
        for (var k in listKendaraan) {
          final parkirs = k["parkirs"] ?? [];

          // LOOP SEMUA PARKIR YANG SEDANG AKTIF
          for (var p in parkirs) {
            if (p["masuk"] != null && p["keluar"] == null) {
              temp.add({
                "lokasi": p["id_lokasi"],
                "merek": k["merk"],
                "plat": k["plat_nomor"],
                "masuk": DateTime.parse(p["masuk"]),
                "keluar": null,
              });
            }
          }
        }

        setState(() {
          aktivitas = temp;
        });
      }
    }
  } catch (e) {
    print("Error aktivitas: $e");
  }
}

  String formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.year} ${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  String _formatDurasi(Duration d) {
    return "${d.inHours} jam ${d.inMinutes % 60} menit";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A994E),
        title: const Text("Aktivitas Parkir", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 2,
      ),

      body: aktivitas.isEmpty
          ? const Center(
              child: Text("Belum ada aktivitas parkir", style: TextStyle(fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: aktivitas.length,
              itemBuilder: (context, index) {
                final data = aktivitas[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_parking, color: Color(0xFF386641)),
                          const SizedBox(width: 8),
                          Text(
                            data["lokasi"].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF386641),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "${data['merek']} - ${data['plat']}",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const Divider(height: 24),

                      _infoRow(
                        icon: Icons.login,
                        color: Colors.orange,
                        label: "Masuk",
                        value: formatDate(data["masuk"]),
                      ),

                      data["keluar"] == null
                          ? _infoRow(
                              icon: Icons.access_time_filled,
                              color: Colors.green,
                              label: "Status",
                              value: "Sedang Parkir",
                            )
                          : _infoRow(
                              icon: Icons.logout,
                              color: Colors.red,
                              label: "Keluar",
                              value: formatDate(data["keluar"]),
                            ),

                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 10),
          Text("$label: $value", style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}

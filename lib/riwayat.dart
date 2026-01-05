import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Map<String, dynamic>> riwayat = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  // =========================
  // FETCH RIWAYAT PARKIR
  // =========================
  Future<void> fetchRiwayat() async {
    setState(() => loading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    if (token.isEmpty) {
      setState(() => loading = false);
      return;
    }

    final url = Uri.parse(
      "http://151.243.222.93:31020/api/parkir/aktivitas/riwayat",
    );

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
          final List list = body["data"] ?? [];
          setState(() {
            riwayat = list.map<Map<String, dynamic>>((p) {
              return {
                "lokasi": p["lokasi"]?["nama_lokasi"] ?? "Lokasi",
                "merek": p["kendaraans"]?["merk"] ?? "-",
                "plat": p["kendaraans"]?["plat_nomor"] ?? "-",
                "masuk": _parseDate(p["masuk"]),
                "keluar": _parseDate(p["keluar"]),
                "total": p["total_harga"] ?? 0,
              };
            }).toList();
          });
        }
      }
    } catch (e) {
      debugPrint("Error riwayat: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  // =========================
  // PARSE & FORMAT
  // =========================
  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  String formatDate(DateTime? dt) {
    if (dt == null) return "-";
    return "${dt.day.toString().padLeft(2, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  String formatRupiah(dynamic value) {
    final int number = int.tryParse(value.toString()) ?? 0;
    return "Rp ${number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A994E),
        title: const Text(
          "Riwayat Parkir",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6A994E)),
            )
          : RefreshIndicator(
              onRefresh: fetchRiwayat,
              child: riwayat.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(height: 200),
                        Center(
                          child: Text(
                            "Belum ada riwayat parkir",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: riwayat.length,
                      itemBuilder: (context, index) {
                        final item = riwayat[index];
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
                                  const Icon(
                                    Icons.local_parking,
                                    color: Color(0xFF386641),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item["lokasi"],
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
                                "${item['merek']} - ${item['plat']}",
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
                                value: formatDate(item["masuk"]),
                              ),
                              _infoRow(
                                icon: Icons.logout,
                                color: Colors.red,
                                label: "Keluar",
                                value: formatDate(item["keluar"]),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.payments_outlined,
                                    color: Colors.purple,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    formatRupiah(item["total"]),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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

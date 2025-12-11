import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<Map<String, dynamic>> riwayat = [];
  bool loading = true;

  DateTime? safeParse(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRiwayat();
  }

  Future<void> fetchRiwayat() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    if (token.isEmpty) return;

    final url = Uri.parse(
        "http://192.168.217.134:8000/api/parkir/aktivitas/riwayat");

    try {
      final res = await http.get(url, headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        if (body["status"] == "success") {
          final List data = body["data"];

          setState(() {
            riwayat = data.map<Map<String, dynamic>>((p) {
              return {
                "lokasi": p["lokasi"]?["nama_lokasi"] ?? "-",
                "id_lokasi": p["id_lokasi_data"] ?? "-",
                "merek": p["kendaraans"]?["merk"] ?? "-",
                "plat": p["kendaraans"]?["plat_nomor"] ?? "-",
                "masuk": safeParse(p["masuk"]),
                "keluar": safeParse(p["keluar"]),
                "total": p["total_harga"] ?? 0,
              };
            }).toList();
          });
        }
      }

      setState(() => loading = false);
    } catch (e) {
      print("Error riwayat: $e");
      setState(() => loading = false);
    }
  }

  String formatDate(DateTime? dt) {
    if (dt == null) return "-";
    return "${dt.day.toString().padLeft(2, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.year} ${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
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
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : riwayat.isEmpty
              ? const Center(child: Text("Belum ada riwayat parkir"))
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
    const Icon(Icons.local_parking, color: Color(0xFF386641)),
    const SizedBox(width: 8),
    Text(
      item['id_lokasi']?.toString() ?? "-", // Menampilkan ID Lokasi
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
                                fontSize: 15, fontWeight: FontWeight.w500),
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
                              const Icon(Icons.payments_outlined,
                                  color: Colors.purple),
                              const SizedBox(width: 10),
                              Text(
                                "Biaya: Rp ${item["total"]}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                            ],
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

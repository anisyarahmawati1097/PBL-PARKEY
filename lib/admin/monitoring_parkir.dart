import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'daftarpengendaramasuk.dart';

class LokasiPageAdmin extends StatefulWidget {
  const LokasiPageAdmin({super.key});

  @override
  State<LokasiPageAdmin> createState() => _LokasiPageAdminState();
}

class _LokasiPageAdminState extends State<LokasiPageAdmin> {
  int? lokasiId;
  String lokasiNama = "";
  int totalSlot = 0;
  int occupied = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadLokasi();
  }

  // ============================================================
  // LOAD DATA SLOT LOKASI
  // ============================================================
  Future<void> loadLokasi() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  lokasiId = prefs.getInt("lokasi_id");
  lokasiNama = prefs.getString("nama_lokasi") ?? "";

  if (lokasiId == null) {
    setState(() => loading = false);
    return;
  }

  try {
    final url = "http://192.168.156.134:8000/api/slots/status";
    final res = await http.post(
      Uri.parse(url),
      body: {
        "lokasi_id": lokasiId.toString(),
      },
    );

    print("STATUS SLOT API: ${res.statusCode}");
    print("BODY SLOT API: ${res.body}");

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      setState(() {
        totalSlot = data["total"] ?? 0;
        occupied = data["occupied"] ?? 0;
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  } catch (e) {
    print("ERROR SLOT API: $e");
    setState(() => loading = false);
  }
}


  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSisaSlotCard(),
          const SizedBox(height: 16),
          _buildDaftarKendaraanCard(context),
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================
  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          "MONITORING PARKIR | ",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        const Icon(Icons.location_on, color: Colors.red, size: 26),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            lokasiNama.toUpperCase(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CARD STATUS SLOT
  // ============================================================
  Widget _buildSisaSlotCard() {
    final kosong = totalSlot - occupied;
    final persen = totalSlot == 0
        ? "0"
        : ((occupied / totalSlot) * 100).toStringAsFixed(0);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // KIRI
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Status Slot",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text("Total Slot : $totalSlot"),
                Text("Terisi     : $occupied"),
                Text("Kosong    : $kosong"),
              ],
            ),

            // KANAN
            Column(
              children: [
                Text(
                  "$persen%",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: (occupied / (totalSlot == 0 ? 1 : totalSlot)) > 0.7
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
                const Text("Terisi"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CARD KE HALAMAN DAFTAR KENDARAAN MASUK
  // ============================================================
  Widget _buildDaftarKendaraanCard(BuildContext context) {
    return InkWell(
      onTap: () {
        if (lokasiId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DaftarKendaraanPage(
                lokasiId: lokasiId!,
                lokasiNama: lokasiNama,
              ),
            ),
          );
        }
      },
      child: Card(
        elevation: 3,
        color: Colors.green[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.motorcycle,
                  color: Colors.green[800],
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                "Daftar Kendaraan Masuk",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

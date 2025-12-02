import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'bc.dart';

class DaftarKendaraanPage extends StatefulWidget {
  @override
  _DaftarKendaraanPageState createState() => _DaftarKendaraanPageState();
}

class _DaftarKendaraanPageState extends State<DaftarKendaraanPage> {
  List kendaraan = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchKendaraan();
  }

  Future<void> fetchKendaraan() async {
    setState(() => loading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("user_id");

    if (userId == null) {
      setState(() => loading = false);
      print("User tidak ditemukan dalam SharedPreferences");
      return;
    }

    final response = await http.get(
      Uri.parse("http://192.168.14.134:8000/api/kendaraan?user_id=$userId")
    );

    if (response.statusCode == 200) {
      setState(() {
        kendaraan = jsonDecode(response.body)['data'];
        loading = false;
      });
    } else {
      setState(() => loading = false);
      print("Gagal fetch kendaraan: ${response.statusCode}");
    }
  }

  Future<void> _refreshFromTambah() async {
    bool? refreshed = await Navigator.pushNamed(context, "/tambah-kendaraan");
    if (refreshed == true) {
      fetchKendaraan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Kendaraan"),
        backgroundColor: const Color(0xFF6A994E),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : kendaraan.isEmpty
              ? const Center(child: Text("Belum ada kendaraan"))
              : ListView.builder(
                  itemCount: kendaraan.length,
                  itemBuilder: (context, index) {
                    final item = kendaraan[index];

                    return Card(
                      color: const Color.fromARGB(255, 181, 223, 140),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.directions_car, size: 40),
                        title: Text(
                          (item["plat_nomor"] ?? "").toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Text(item["jenis"] ?? "Kendaraan"),
                        trailing: const Icon(Icons.chevron_right, size: 32),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QRCodePage(kendaraan: item),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

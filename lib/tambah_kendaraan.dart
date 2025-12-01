import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // <= TAMBAHAN
import 'bc.dart';

class TambahKendaraanPage extends StatefulWidget {
  const TambahKendaraanPage({super.key});

  @override
  State<TambahKendaraanPage> createState() => _TambahKendaraanPageState();
}

class _TambahKendaraanPageState extends State<TambahKendaraanPage> {
  String jenisKendaraan = "Mobil";
  final nomorPlatController = TextEditingController();
  final merkController = TextEditingController();
  final modelController = TextEditingController();
  final warnaController = TextEditingController();
  final tahunController = TextEditingController();

  File? foto;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => foto = File(picked.path));
    }
  }

  Future<void> simpanKendaraan() async {
    if (nomorPlatController.text.isEmpty ||
        merkController.text.isEmpty ||
        modelController.text.isEmpty ||
        warnaController.text.isEmpty ||
        tahunController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua data wajib diisi")),
      );
      return;
    }

    // === Ambil user_id dari SharedPreferences ===
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("user_id");

    final userJson = prefs.getString("user");
    if (userJson == null) return;

    final user = jsonDecode(userJson);
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User tidak ditemukan, silakan login ulang")),
      );
      return;
    }

    var url = Uri.parse("http://192.168.110.224:8000/api/kendaraan/store");
    var request = http.MultipartRequest("POST", url);

    request.fields["plat_nomor"] = nomorPlatController.text;
    request.fields["jenis"] = jenisKendaraan;
    request.fields["merk"] = merkController.text;
    request.fields["model"] = modelController.text;
    request.fields["warna"] = warnaController.text;
    request.fields["tahun"] = tahunController.text;
    request.fields["pemilik"] = "User"; // bebas nanti bisa dari DB
    request.fields["user_id"] = userId; // <= SUDAH TERTAUT KE USER LOGIN

    if (foto != null) {
      request.files.add(await http.MultipartFile.fromPath("foto", foto!.path));
    }

    var response = await request.send();

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menambah kendaraan (${response.statusCode})")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kendaraan"),
        backgroundColor: const Color(0xFF6A994E),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Pilih Jenis Kendaraan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              children: [
                _jenisChip("Mobil", Icons.directions_car),
                _jenisChip("Motor", Icons.two_wheeler),
                _jenisChip("Truk", Icons.local_shipping),
                _jenisChip("Pickup", Icons.fire_truck),
              ],
            ),
            const SizedBox(height: 20),
            textField(nomorPlatController, "Plat Nomor Kendaraan"),
            const SizedBox(height: 12),
            textField(merkController, "Merk Kendaraan"),
            const SizedBox(height: 12),
            textField(modelController, "Model Kendaraan"),
            const SizedBox(height: 12),
            textField(tahunController, "Tahun Pembuatan", inputType: TextInputType.number),
            const SizedBox(height: 12),
            textField(warnaController, "Warna Kendaraan"),
            const SizedBox(height: 20),
            const Text("Unggah Foto Kendaraan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: foto == null
                      ? const Text("Sentuh untuk mengunggah foto")
                      : Image.file(foto!, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: simpanKendaraan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF386641),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text("Simpan Kendaraan"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textField(TextEditingController c, String label,
      {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: c,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade200,
      ),
    );
  }

  Widget _jenisChip(String label, IconData icon) {
    return ChoiceChip(
      avatar: Icon(icon,
          size: 20,
          color: jenisKendaraan == label ? Colors.white : Colors.black54),
      label: Text(label),
      selected: jenisKendaraan == label,
      onSelected: (selected) => setState(() => jenisKendaraan = label),
      selectedColor: const Color(0xFF6A994E),
      labelStyle:
          TextStyle(color: jenisKendaraan == label ? Colors.white : Colors.black),
    );
  }
}

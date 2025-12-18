import 'dart:convert';
import 'package:http/http.dart' as http;

class KendaraanService {
  // Ganti IP sesuai Laravel serve di komputer atau emulator
  static const String baseUrl = "http://172.20.10.3:8000/api";

 static Future<List<dynamic>> getKendaraanByLokasi(int lokasiId) async {
  final url = Uri.parse("$baseUrl/lokasi/$lokasiId/pengendara");

  try {
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      return data["data"] ?? [];
    } else {
      throw Exception("Gagal mengambil data (status: ${res.statusCode})");
    }
  } catch (e) {
    throw Exception("Error koneksi: $e");
  }
}

}

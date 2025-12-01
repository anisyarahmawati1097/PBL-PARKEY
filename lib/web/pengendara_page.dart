import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DetailPengendaraPage.dart'; // halaman detail kendaraan

class PengendaraPage extends StatefulWidget {
  const PengendaraPage({super.key});

  @override
  State<PengendaraPage> createState() => _PengendaraPageState();
}

class _PengendaraPageState extends State<PengendaraPage> {
  List<dynamic> users = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future fetchUsers() async {
    final res = await http.get(
      Uri.parse("http://192.168.110.224:8000/api/users"),
    );

    if (res.statusCode == 200) {
      setState(() {
        users = jsonDecode(res.body);
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  Widget _buildUserCard(dynamic user) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: const Icon(Icons.person, color: Colors.blue),
        ),
        title: Text(
          user['name'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(user['email']),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPengendaraPage(
                userId: user['id'],
                namaPengendara: user['name'],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          const SizedBox(height: 20),

          if (loading) const Center(child: CircularProgressIndicator()),

          if (!loading && users.isEmpty)
            const Text("Tidak ada pengguna"),

          for (var user in users) _buildUserCard(user),
        ],
      ),
    );
  }
}

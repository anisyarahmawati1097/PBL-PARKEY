import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DetailPengendaraPage.dart';

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
    try {
      final res = await http.get(
        Uri.parse("http://192.168.156.134:8000/api/users"),
      );

      if (res.statusCode == 200) {
        setState(() {
          users = jsonDecode(res.body);
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Widget _buildUserCard(dynamic user) {
    return Card(
      elevation: 4,
      shadowColor: Colors.green.withOpacity(0.2),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.green[100],
          child: const Icon(Icons.person, color: Colors.green),
        ),
        title: Text(
          user['name'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(user['email']),
        trailing: const Icon(Icons.chevron_right, color: Colors.green),
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
    return Container(
      color: Colors.grey[100], // background lembut
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Daftar Pengendara",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              if (loading)
                const Center(child: CircularProgressIndicator(color: Colors.green)),
              if (!loading && users.isEmpty)
                const Center(
                  child: Text(
                    "Tidak ada pengguna",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              if (!loading && users.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (_, i) => _buildUserCard(users[i]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DompetPage extends StatefulWidget {
  const DompetPage({super.key});

  @override
  State<DompetPage> createState() => _DompetPageState();
}

class _DompetPageState extends State<DompetPage> {
  // status koneksi e-wallet
  bool isDanaConnected = false;
  bool isOvoConnected = false;
  bool isGopayConnected = false;
  bool isShopeePayConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Dompet Saya"),
        backgroundColor: const Color(0xFF6A994E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  // DANA
                  ListTile(
                    leading: Image.asset("assets/dana.jpg", width: 40),
                    title: const Text("Hubungkan ke DANA"),
                    subtitle: Text(isDanaConnected ? "Tersambung" : "Belum tersambung"),
                    trailing: Icon(
                      isDanaConnected ? Icons.check_circle : Icons.link,
                      color: isDanaConnected ? Colors.green : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        isDanaConnected = !isDanaConnected;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isDanaConnected
                              ? "DANA berhasil dihubungkan"
                              : "DANA diputuskan"),
                        ),
                      );
                    },
                  ),
                  const Divider(),

                  // OVO
                  ListTile(
                    leading: Image.asset("assets/ovo.jpg", width: 40),
                    title: const Text("Hubungkan ke OVO"),
                    subtitle: Text(isOvoConnected ? "Tersambung" : "Belum tersambung"),
                    trailing: Icon(
                      isOvoConnected ? Icons.check_circle : Icons.link,
                      color: isOvoConnected ? Colors.green : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        isOvoConnected = !isOvoConnected;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isOvoConnected
                              ? "OVO berhasil dihubungkan"
                              : "OVO diputuskan"),
                        ),
                      );
                    },
                  ),
                  const Divider(),

                  // GoPay
                  ListTile(
                    leading: Image.asset("assets/gopay.png", width: 40),
                    title: const Text("Hubungkan ke GoPay"),
                    subtitle: Text(isGopayConnected ? "Tersambung" : "Belum tersambung"),
                    trailing: Icon(
                      isGopayConnected ? Icons.check_circle : Icons.link,
                      color: isGopayConnected ? Colors.green : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        isGopayConnected = !isGopayConnected;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isGopayConnected
                              ? "GoPay berhasil dihubungkan"
                              : "GoPay diputuskan"),
                        ),
                      );
                    },
                  ),
                  const Divider(),

                  // ShopeePay
                  ListTile(
                    leading: Image.asset("assets/shpy.png", width: 40),
                    title: const Text("Hubungkan ke ShopeePay"),
                    subtitle: Text(isShopeePayConnected ? "Tersambung" : "Belum tersambung"),
                    trailing: Icon(
                      isShopeePayConnected ? Icons.check_circle : Icons.link,
                      color: isShopeePayConnected ? Colors.green : Colors.grey,
                    ),
                    onTap: () {
                      setState(() {
                        isShopeePayConnected = !isShopeePayConnected;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isShopeePayConnected
                              ? "ShopeePay berhasil dihubungkan"
                              : "ShopeePay diputuskan"),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Riwayat Hubungan (contoh)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Riwayat Koneksi",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.link, color: Colors.green),
                    title: Text("DANA tersambung"),
                    subtitle: Text("24 Sep 2025"),
                  ),
                  ListTile(
                    leading: Icon(Icons.link, color: Colors.green),
                    title: Text("OVO tersambung"),
                    subtitle: Text("23 Sep 2025"),
                  ),
                  ListTile(
                    leading: Icon(Icons.link, color: Colors.green),
                    title: Text("GoPay tersambung"),
                    subtitle: Text("22 Sep 2025"),
                  ),
                  ListTile(
                    leading: Icon(Icons.link, color: Colors.green),
                    title: Text("ShopeePay tersambung"),
                    subtitle: Text("21 Sep 2025"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

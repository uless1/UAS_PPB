import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_page.dart';
import 'kelola_produk_page.dart';
import 'laporan_penjualan_page.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Kelola Produk'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => KelolaProdukPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.analytics),
            title: Text('Laporan Penjualan'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LaporanPenjualanPage()));
            },
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('role'); // Hapus status login admin
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/login_page.dart';
import 'keranjang_page.dart';
import '../models/produk_model.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Produk> menuList = [
    Produk(
        nama: 'Tomat',
        deskripsi:
            'Tomat merah segar, kaya akan vitamin C dan sempurna untuk salad atau masakan sehat Anda.',
        harga: 20000,
        gambar: 'assets/images/tomat.jpg',
        stok: 10),
    Produk(
        nama: 'Bayam',
        deskripsi:
            'Bayam segar dengan daun hijau yang kaya zat besi, ideal untuk menjaga stamina tubuh.',
        harga: 15000,
        gambar: 'assets/images/bayam.jpeg',
        stok: 20),
    Produk(
        nama: 'Kangkung',
        deskripsi:
            'Kangkung hijau yang renyah dan segar, cocok untuk tumisan yang menggugah selera.',
        harga: 18000,
        gambar: 'assets/images/kangkung.jpg',
        stok: 15),
    // Tambahkan produk lainnya jika diperlukan
  ];

  List<Produk> keranjang = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Sayuria'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context); // Panggil fungsi logout saat tombol ditekan
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pilih Sayur dan Buah',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Image.asset(
                      menuList[index].gambar, // Menampilkan gambar produk
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                      menuList[index].nama,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(menuList[index].deskripsi),
                        SizedBox(height: 4),
                        Text(
                          'Rp ${menuList[index].harga}',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          keranjang.add(menuList[index]);
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                KeranjangPage(keranjang: keranjang),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Pesan'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.green,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Pembelian: Rp. ${_getTotalPenjualan()}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                if (keranjang.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KeranjangPage(keranjang: keranjang),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: Text(
                'Keranjang (${keranjang.length})',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getTotalPenjualan() {
    return keranjang.fold(0, (total, produk) => total + produk.harga);
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('role'); // Hapus status login user
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}

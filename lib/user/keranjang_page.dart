import 'package:flutter/material.dart';
import '../models/produk_model.dart';
import '../shared/database_service.dart';

class KeranjangPage extends StatefulWidget {
  final List<Produk> keranjang;
  DatabaseService _dbService = DatabaseService();

  KeranjangPage({required this.keranjang});

  @override
  _KeranjangPageState createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  final TextEditingController _nominalController = TextEditingController();

  int _getTotalHarga() {
    return widget.keranjang.fold(0, (total, produk) => total + produk.harga);
  }

  void showPaymentOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pilih Metode Pembayaran"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text("Kartu Kredit/Debit"),
                onTap: () {
                  Navigator.pop(context);
                  _showPaymentDialog("Kartu Kredit/Debit");
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text("E-Wallet"),
                onTap: () {
                  Navigator.pop(context);
                  _showPaymentDialog("E-Wallet");
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text("Tunai"),
                onTap: () {
                  Navigator.pop(context);
                  _showPaymentDialog("Tunai");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentDialog(String metode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Masukkan Nominal Pembayaran"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Nominal Pembayaran',
                  hintText: 'Masukkan nominal',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog input nominal
                _handlePayment(metode);
              },
              child: Text('Bayar'),
            ),
          ],
        );
      },
    );
  }

  void _handlePayment(String metode) async {
    // Mendapatkan nominal yang dimasukkan
    int nominal = int.tryParse(_nominalController.text) ?? 0;

    // Print untuk debugging nominal dan total harga
    print(
        "Metode: $metode, Nominal: $nominal, Total Harga: ${_getTotalHarga()}");

    if (nominal >= _getTotalHarga()) {
      // Simpan produk ke database
      for (var produk in widget.keranjang) {
        await widget._dbService.insertProduk(produk);
      }

      // Tampilkan dialog resi pembayaran
      print("Menampilkan dialog pembayaran berhasil...");

      showDialog(
        context: context,
        barrierDismissible:
            false, // Dialog tidak bisa ditutup dengan tap di luar
        builder: (context) {
          return AlertDialog(
            title: Text("Pembayaran Berhasil"),
            content: SingleChildScrollView(
              // Tambahkan ini untuk menghindari overflow
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      "Terima kasih telah melakukan pembayaran dengan metode $metode."),
                  Text(
                      "Jumlah yang dibayar: Rp $nominal\nTotal harga: Rp ${_getTotalHarga()}"),
                  SizedBox(height: 20),
                  Text(
                      "Resi Pembayaran: #${DateTime.now().millisecondsSinceEpoch}"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    widget.keranjang.clear(); // Kosongkan keranjang
                  });
                  Navigator.pop(context); // Tutup dialog
                },
                child: Text("Tutup"),
              ),
            ],
          );
        },
      );
    } else {
      // Jika nominal kurang dari total harga
      print("Pembayaran gagal, nominal kurang dari total harga.");

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Pembayaran Gagal"),
          content: Text(
            "Nominal yang dibayar kurang dari total harga. Silakan periksa kembali.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Tutup"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja'),
      ),
      body: widget.keranjang.isEmpty
          ? Center(child: Text('Keranjang kosong'))
          : ListView.builder(
              itemCount: widget.keranjang.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.asset(
                    widget.keranjang[index].gambar,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(widget.keranjang[index].nama),
                  subtitle: Text("Harga: Rp ${widget.keranjang[index].harga}"),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total: Rp ${_getTotalHarga()}",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            ElevatedButton(
              onPressed: showPaymentOptions,
              child: Text('Bayar Sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}

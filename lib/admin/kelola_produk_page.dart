import 'package:flutter/material.dart';
import '../models/produk_model.dart';
import '../shared/database_service.dart';

class KelolaProdukPage extends StatefulWidget {
  @override
  _KelolaProdukPageState createState() => _KelolaProdukPageState();
}

class _KelolaProdukPageState extends State<KelolaProdukPage> {
  List<Produk> produkList = [
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
    Produk(
        nama: 'Bawang merah',
        deskripsi:
            'Bawang yang fresh yang renyah dan segar, cocok untuk tumisan yang menggugah selera.',
        harga: 500,
        gambar: 'assets/images/bawangmerah.jpg',
        stok: 500),
    Produk(
        nama: 'Brokoli',
        deskripsi: ' Brokoli segar yang menggugah selera untuk di sop.',
        harga: 18000,
        gambar: 'assets/images/brokoli.jpeg',
        stok: 15),
  ];
  DatabaseService _dbService = DatabaseService();

  @override
  void initState() {
    super.initState();
    _loadProduk();
  }

  void _loadProduk() async {
    List<Produk> list = await _dbService.getProdukList();
    setState(() {
      produkList = list;
    });
  }

  void tambahProduk(Produk produk) async {
    await _dbService.insertProduk(produk);
    _loadProduk();
  }

  void hapusProduk(int id) async {
    await _dbService.deleteProduk(id);
    _loadProduk();
  }

  void showAddProdukDialog() {
    TextEditingController namaController = TextEditingController();
    TextEditingController deskripsiController = TextEditingController();
    TextEditingController hargaController = TextEditingController();
    TextEditingController stokController = TextEditingController();
    TextEditingController gambarController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Tambah Produk"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(labelText: 'Nama Produk'),
                ),
                TextField(
                  controller: deskripsiController,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                ),
                TextField(
                  controller: hargaController,
                  decoration: InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stokController,
                  decoration: InputDecoration(labelText: 'Stok'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: gambarController,
                  decoration: InputDecoration(labelText: 'URL Gambar'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Produk newProduk = Produk(
                  nama: namaController.text,
                  deskripsi: deskripsiController.text,
                  harga: int.parse(hargaController.text),
                  stok: int.parse(stokController.text),
                  gambar: gambarController.text,
                );
                tambahProduk(newProduk);
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Produk'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Daftar Produk',
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
              itemCount: produkList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: produkList[index].gambar.isNotEmpty
                        ? Image.asset(
                            produkList[index].gambar,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.image),
                    title: Text(
                      produkList[index].nama,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(produkList[index].deskripsi),
                        SizedBox(height: 4),
                        Text(
                          'Rp ${produkList[index].harga}',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            hapusProduk(produkList[index].id!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddProdukDialog,
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}

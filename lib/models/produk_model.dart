class Produk {
  int? id;
  String nama;
  String deskripsi;
  int harga;
  String gambar;
  int stok;

  Produk({
    this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.gambar,
    required this.stok,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
      'harga': harga,
      'gambar': gambar,
      'stok': stok,
    };
  }

  static Produk fromMap(Map<String, dynamic> map) {
    return Produk(
      id: map['id'],
      nama: map['nama'],
      deskripsi: map['deskripsi'],
      harga: map['harga'],
      gambar: map['gambar'],
      stok: map['stok'],
    );
  }
}

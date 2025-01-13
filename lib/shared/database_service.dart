import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/produk_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'sayuria.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE produk (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        deskripsi TEXT,
        harga INTEGER,
        gambar TEXT,
        stok INTEGER
      )
    ''');
  }

  Future<int> insertProduk(Produk produk) async {
    Database db = await database;
    return await db.insert('produk', produk.toMap());
  }

  Future<List<Produk>> getProdukList() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('produk');
    return List.generate(maps.length, (i) {
      return Produk.fromMap(maps[i]);
    });
  }

  Future<int> updateProduk(Produk produk) async {
    Database db = await database;
    return await db.update(
      'produk',
      produk.toMap(),
      where: 'id = ?',
      whereArgs: [produk.id],
    );
  }

  Future<void> deleteProduk(int id) async {
    Database db = await database;
    await db.delete('produk', where: 'id = ?', whereArgs: [id]);
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  // Tạo instance Singleton (chỉ khởi tạo 1 lần duy nhất trong toàn app)
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Mở database, nếu chưa có thì khởi tạo
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_manager.db');
    return _database!;
  }

  // Khởi tạo Database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1, // Phiên bản DB
      onCreate: _createDB,
    );
  }

  // Tạo bảng 'transactions'
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const textNullable = 'TEXT';

    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        title $textType,
        category $textType,
        amount $intType,
        isIncome $intType, 
        date $textType,
        note $textNullable
      )
    ''');
  }

  // ==========================================
  // CÁC HÀM CRUD (CREATE, READ, UPDATE, DELETE)
  // ==========================================

  // 1. Thêm một giao dịch mới (CREATE)
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction.toMap());
  }

  // 2. Lấy tất cả giao dịch, sắp xếp theo ngày mới nhất (READ)
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await instance.database;

    // orderBy: 'date DESC' giúp giao dịch mới nhất hiện lên trên cùng
    final result = await db.query('transactions', orderBy: 'date DESC');

    return result.map((json) => TransactionModel.fromMap(json)).toList();
  }

  // 3. Sửa một giao dịch (UPDATE)
  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await instance.database;

    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // 4. Xóa một giao dịch (DELETE)
  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;

    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 5. Đóng database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

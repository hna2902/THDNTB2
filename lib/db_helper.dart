// lib/db_helper.dart

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'transaction_model.dart'; // Import model của chúng ta

class DBHelper {
  static const String _tableName = 'transactions';

  // Hàm khởi tạo database
  static Future<sql.Database> _database() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(appDir.path, 'transactions.db');

    return sql.openDatabase(
      dbPath,
      onCreate: (db, version) {
        // Chạy lệnh SQL để tạo bảng khi db được tạo lần đầu
        return db.execute(
          'CREATE TABLE $_tableName(id TEXT PRIMARY KEY, description TEXT, amount REAL, date TEXT, category TEXT, isExpense INTEGER)',
        );
      },
      version: 1, // Quản lý phiên bản khi bạn thay đổi cấu trúc bảng
    );
  }

  // Hàm Thêm (Create)
  static Future<void> insertTransaction(Transaction transaction) async {
    final db = await DBHelper._database();
    await db.insert(
      _tableName,
      transaction.toMap(), // Dùng hàm toMap() ta vừa tạo
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  // Hàm Đọc (Read)
  static Future<List<Transaction>> getTransactions() async {
    final db = await DBHelper._database();

    // Sắp xếp theo ngày mới nhất lên trước
    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      orderBy: 'date DESC',
    );

    // Chuyển List<Map> thành List<Transaction>
    return List.generate(maps.length, (i) {
      return Transaction.fromMap(maps[i]); // Dùng hàm fromMap()
    });
  }

  // (Tùy chọn) Bạn có thể thêm hàm Xóa (Delete) hoặc Cập nhật (Update) ở đây
  // static Future<void> deleteTransaction(String id) async {
  //   final db = await DBHelper._database();
  //   await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  // }
}

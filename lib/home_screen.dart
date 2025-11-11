// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'transaction_model.dart';
import 'add_transaction_screen.dart';
import 'analysis_screen.dart';
import 'db_helper.dart'; // <--- 1. IMPORT DB_HELPER

// 2. CHUYỂN THÀNH STATEFULWIDGET
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 3. Biến để lưu trữ "tương lai" của dữ liệu
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    // 4. Gọi hàm lấy dữ liệu khi màn hình được tải
    _refreshTransactions();
  }

  // 5. Hàm để lấy (hoặc làm mới) danh sách
  void _refreshTransactions() {
    setState(() {
      _transactionsFuture = DBHelper.getTransactions();
    });
  }

  // 6. Hàm để mở màn hình Thêm mới và chờ kết quả
  void _startAddTransaction(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (ctx) => const AddTransactionScreen()),
    ).then((_) {
      // 7. Sau khi màn hình Thêm mới đóng lại, LÀM MỚI danh sách
      _refreshTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Chi tiêu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () async {
              // 8. Khi sang màn hình biểu đồ, ta cần dữ liệu thật
              final transactions =
                  await _transactionsFuture; // Lấy list từ future
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => AnalysisScreen(
                    transactions: transactions, // Truyền dữ liệu thật
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // 9. DÙNG FUTUREBUILDER ĐỂ HIỂN THỊ DỮ LIỆU
      body: FutureBuilder<List<Transaction>>(
        future: _transactionsFuture, // Theo dõi future này
        builder: (context, snapshot) {
          // Trạng thái Đang tải...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Trạng thái Bị lỗi
          if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
          }

          // Trạng thái Có dữ liệu
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có giao dịch nào.'));
          }

          // Khi có dữ liệu, gán vào biến và dùng ListView
          final transactions = snapshot.data!;
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tx = transactions[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Icon(categoryIcons[tx.category]),
                  ),
                  title: Text(
                    tx.description,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${tx.date.day}/${tx.date.month}/${tx.date.year}',
                  ),
                  trailing: Text(
                    '${tx.isExpense ? '-' : '+'} ${tx.amount.toStringAsFixed(0)}đ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: tx.isExpense ? Colors.red : Colors.green,
                    ),
                  ),
                  // (Tùy chọn) Thêm hành động Xóa
                  // onLongPress: () async {
                  //   await DBHelper.deleteTransaction(tx.id);
                  //   _refreshTransactions();
                  // },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _startAddTransaction(context), // 10. GỌI HÀM MỚI
      ),
    );
  }
}

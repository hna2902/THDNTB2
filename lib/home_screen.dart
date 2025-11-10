// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'transaction_model.dart'; // Import model
import 'add_transaction_screen.dart'; // Import màn hình Thêm
import 'analysis_screen.dart'; // Import màn hình Phân tích

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  // --- DỮ LIỆU GIẢ (DUMMY DATA) ĐỂ DEMO ---
  final List<Transaction> dummyTransactions = [
    Transaction(
      id: 't1',
      description: 'Cà phê Highland',
      amount: 55000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.anUong,
    ),
    Transaction(
      id: 't2',
      description: 'Lương tháng 11',
      amount: 10000000,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.thuNhap,
      isExpense: false, // Đây là thu nhập
    ),
    Transaction(
      id: 't3',
      description: 'Đi Grab về nhà',
      amount: 28000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: Category.diChuyen,
    ),
    Transaction(
      id: 't4',
      description: 'Xem phim Lotte',
      amount: 120000,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: Category.giaiTri,
    ),
    Transaction(
      id: 't5',
      description: 'Mua sắm quần áo',
      amount: 750000,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: Category.muaSam,
    ),
  ];
  // ------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Chi tiêu'),
        actions: [
          // Nút để chuyển qua màn hình Biểu đồ
          IconButton(
            icon: const Icon(Icons.pie_chart),
            onPressed: () {
              // --- ĐIỀU HƯỚNG SANG MÀN HÌNH BIỂU ĐỒ ---
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => AnalysisScreen(
                    transactions: dummyTransactions, // Truyền dữ liệu giả sang
                  ),
                ),
              );
              // ------------------------------------
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dummyTransactions.length,
        itemBuilder: (ctx, index) {
          final tx = dummyTransactions[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            child: ListTile(
              // Lấy icon từ model
              leading: CircleAvatar(
                radius: 30,
                // Lấy icon tương ứng từ map
                child: Icon(categoryIcons[tx.category]),
              ),
              title: Text(
                tx.description,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${tx.date.day}/${tx.date.month}/${tx.date.year}',
              ),
              // Hiển thị số tiền
              trailing: Text(
                '${tx.isExpense ? '-' : '+'} ${tx.amount.toStringAsFixed(0)}đ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: tx.isExpense ? Colors.red : Colors.green,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // --- ĐIỀU HƯỚNG SANG MÀN HÌNH FORM THÊM MỚI ---
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const AddTransactionScreen(),
            ),
          );
          // ---------------------------------------
        },
      ),
    );
  }
}
// lib/analysis_screen.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'transaction_model.dart'; // Import model

class AnalysisScreen extends StatelessWidget {
  // Chúng ta sẽ nhận danh sách giao dịch từ HomeScreen
  final List<Transaction> transactions;

  const AnalysisScreen({Key? key, required this.transactions})
      : super(key: key);

  // --- LOGIC GIẢ ĐỂ DEMO BIỂU ĐỒ ---
  // Hàm này sẽ xử lý danh sách giao dịch và nhóm chúng lại theo danh mục
  Map<Category, double> get categorySpending {
    Map<Category, double> spendingData = {};

    // Khởi tạo map
    for (var category in Category.values) {
      if (category != Category.thuNhap) { // Không tính Thu nhập vào chi tiêu
        spendingData[category] = 0.0;
      }
    }

    // Tính tổng chi tiêu cho mỗi danh mục
    for (var tx in transactions) {
      if (tx.isExpense) {
        spendingData.update(tx.category, (value) => value + tx.amount);
      }
    }
    // Lọc bỏ những danh mục không có chi tiêu
    spendingData.removeWhere((key, value) => value == 0);
    return spendingData;
  }

  // Chuyển đổi dữ liệu đã nhóm thành các 'lát bánh' (PieChartSectionData)
  List<PieChartSectionData> get pieChartSections {
    final spending = categorySpending;
    if (spending.isEmpty) {
      return [
        PieChartSectionData(
          value: 1,
          title: 'Không có dữ liệu',
          color: Colors.grey,
          radius: 100,
        )
      ];
    }
    
    final totalSpending = spending.values.reduce((sum, item) => sum + item);

    return spending.entries.map((entry) {
      final category = entry.key;
      final amount = entry.value;
      final percentage = (amount / totalSpending) * 100;

      return PieChartSectionData(
        value: amount,
        title: '${percentage.toStringAsFixed(1)}%', // Hiển thị %
        color: _getColorForCategory(category), // Lấy màu
        radius: 100, // Kích thước 'lát bánh'
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  // Hàm helper lấy màu (bạn có thể tự định nghĩa)
  Color _getColorForCategory(Category category) {
    switch (category) {
      case Category.anUong:
        return Colors.red;
      case Category.diChuyen:
        return Colors.blue;
      case Category.muaSam:
        return Colors.purple;
      case Category.giaiTri:
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  // ------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phân tích Chi tiêu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Tỷ lệ Chi tiêu theo Danh mục',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            // Đây là widget Biểu đồ
            SizedBox(
              height: 300, // Cần cho PieChart một kích thước cụ thể
              child: PieChart(
                PieChartData(
                  sections: pieChartSections, // Lấy dữ liệu đã xử lý ở trên
                  sectionsSpace: 2, // Khoảng cách giữa các 'lát bánh'
                  centerSpaceRadius: 40, // Lỗ hổng ở giữa
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Phần Chú thích (Legend)
            Expanded(
              child: ListView(
                children: categorySpending.entries.map((entry) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getColorForCategory(entry.key),
                      radius: 10,
                    ),
                    title: Text(entry.key.name),
                    trailing: Text('${entry.value.toStringAsFixed(0)}đ'),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
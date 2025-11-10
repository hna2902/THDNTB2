// lib/transaction_model.dart

import 'package:flutter/material.dart';

// Dùng enum để quản lý danh mục, rất quan trọng cho biểu đồ
enum Category { anUong, diChuyen, muaSam, giaiTri, thuNhap }

// Tạo một map để gán icon và màu sắc cho dễ
const categoryIcons = {
  Category.anUong: Icons.fastfood,
  Category.diChuyen: Icons.directions_car,
  Category.muaSam: Icons.shopping_bag,
  Category.giaiTri: Icons.movie,
  Category.thuNhap: Icons.attach_money,
};

class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final Category category;
  final bool isExpense; // True = Chi tiêu (đỏ), False = Thu nhập (xanh)

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    this.isExpense = true, // Mặc định là chi tiêu
  });
}
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
  final bool isExpense;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    this.isExpense = true,
  });

  // --- THÊM HÀM NÀY ---
  // Chuyển Transaction object -> Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(), // Chuyển DateTime sang String để lưu
      'category': category.name, // Chuyển enum sang String
      'isExpense': isExpense ? 1 : 0, // Chuyển bool sang int
    };
  }

  // --- VÀ THÊM HÀM NÀY ---
  // Chuyển Map -> Transaction object
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      date: DateTime.parse(map['date']), // Chuyển String về DateTime
      category: Category.values.firstWhere(
        (e) => e.name == map['category'], // Chuyển String về enum
      ),
      isExpense: map['isExpense'] == 1, // Chuyển int về bool
    );
  }
}

// lib/add_transaction_screen.dart

import 'package:flutter/material.dart';
import 'transaction_model.dart'; // Import model

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  // Dùng để xác thực (validate) Form
  final _formKey = GlobalKey<FormState>();

  // Dùng để lấy giá trị từ các trường nhập liệu
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  // Biến tạm để lưu giá trị người dùng chọn
  Category _selectedCategory = Category.anUong;
  DateTime _selectedDate = DateTime.now();

  // Hàm hiển thị bộ chọn ngày
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  // Hàm xử lý khi nhấn nút "Lưu"
  void _submitData() {
    // Kiểm tra xem form có hợp lệ không
    if (_formKey.currentState!.validate()) {
      // Nếu hợp lệ, lấy dữ liệu
      final enteredAmount = double.tryParse(_amountController.text);
      final enteredDescription = _descriptionController.text;

      if (enteredAmount == null || enteredAmount <= 0) {
        // Có thể thêm 1 thông báo lỗi ở đây
        return;
      }

      // TODO: Lưu dữ liệu này vào Sqflite/Hive
      // Tạm thời, chúng ta chỉ đóng màn hình này lại
      print('Dữ liệu đã nhập:');
      print('Mô tả: $enteredDescription');
      print('Số tiền: $enteredAmount');
      print('Ngày: $_selectedDate');
      print('Danh mục: $_selectedCategory');

      // Quay lại màn hình trước
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm Giao dịch mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Gắn key cho Form
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Trường nhập Mô tả
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Mô tả'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mô tả';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Trường nhập Số tiền
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Số tiền'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số tiền';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Vui lòng nhập số hợp lệ';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Số tiền phải lớn hơn 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Bộ chọn Danh mục
                DropdownButtonFormField<Category>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(labelText: 'Danh mục'),
                  items: Category.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      // Lấy tên enum (vd: anUong, diChuyen...)
                      child: Text(category.name), 
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 10),

                // Bộ chọn Ngày
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Ngày đã chọn: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: const Text(
                        'Chọn ngày',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Nút Lưu
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Lưu Giao dịch'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
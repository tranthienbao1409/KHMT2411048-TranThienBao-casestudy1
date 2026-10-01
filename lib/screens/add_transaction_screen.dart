import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../database/database_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool _isExpense = true;
  final TextEditingController _titleController = TextEditingController(); // Thêm Title Controller
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Lưu trữ ngày được chọn
  String _selectedCategory = 'Ăn uống';
  
  // Ánh xạ danh mục với icon (đơn giản)
  final List<String> _expenseCategories = ['Ăn uống', 'Di chuyển', 'Mua sắm', 'Giáo dục'];
  final List<String> _incomeCategories = ['Thu nhập', 'Tiền thưởng', 'Đầu tư'];

  // Cấu hình icon/màu sắc dựa theo danh mục (Giống bên HomeScreen)
  Map<String, dynamic> _getCategoryStyle(String category) {
    switch (category) {
      case 'Ăn uống': return {'icon': Icons.restaurant, 'color': const Color(0xFFF97316)};
      case 'Di chuyển': return {'icon': Icons.directions_car, 'color': const Color(0xFF3B82F6)};
      case 'Thu nhập': return {'icon': Icons.savings, 'color': const Color(0xFF22C55E)};
      case 'Mua sắm': return {'icon': Icons.shopping_cart, 'color': const Color(0xFFA855F7)};
      case 'Giáo dục': return {'icon': Icons.school, 'color': const Color(0xFF14B8A6)};
      default: return {'icon': Icons.category, 'color': const Color(0xFF64748B)};
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _isExpense = !widget.transaction!.isIncome;
      _titleController.text = widget.transaction!.title;
      _amountController.text = widget.transaction!.amount.toString();
      _selectedDate = widget.transaction!.date;
      _selectedCategory = widget.transaction!.category;
      _noteController.text = widget.transaction!.note ?? '';
    } else {
      _selectedCategory = _isExpense ? _expenseCategories[0] : _incomeCategories[0];
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // Hàm mở hộp thoại chọn ngày
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1868D5), // Màu nền header xanh dương
              onPrimary: Colors.white, // Màu chữ header trắng
              onSurface: Colors.black, // Màu chữ body đen
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Hàm định dạng ngày thành dd/MM/yyyy
  String get _formattedDate {
    final day = _selectedDate.day.toString().padLeft(2, '0');
    final month = _selectedDate.month.toString().padLeft(2, '0');
    final year = _selectedDate.year.toString();
    return '$day/$month/$year';
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Thêm giao dịch',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle Button (Chi tiêu / Thu nhập)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isExpense = true;
                        _selectedCategory = _expenseCategories[0];
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isExpense
                              ? const Color(0xFFFF5252)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Chi tiêu',
                            style: TextStyle(
                              color: _isExpense ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _isExpense = false;
                        _selectedCategory = _incomeCategories[0];
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isExpense
                              ? const Color(0xFF22C55E) // Đổi thành màu xanh lá khi chọn Thu nhập
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Thu nhập',
                            style: TextStyle(
                              color: !_isExpense
                                  ? Colors.white // Chữ màu trắng
                                  : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Danh mục
            _buildLabel('Danh mục'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedCategory,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  items: (_isExpense ? _expenseCategories : _incomeCategories).map((String category) {
                    final style = _getCategoryStyle(category);
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: style['color'],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              style['icon'],
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(category, style: const TextStyle(fontSize: 16)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tiêu đề giao dịch
            _buildLabel('Tên khoản thu/chi'),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'VD: Ăn phở, Đổ xăng, Lương tháng...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1868D5)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Số tiền
            _buildLabel('Số tiền'),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Nhập số tiền',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                suffixText: 'đ',
                suffixStyle:
                    const TextStyle(color: Colors.black, fontSize: 16),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1868D5)),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Ngày giao dịch
            _buildLabel('Ngày giao dịch'),
            InkWell(
              onTap: () => _selectDate(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formattedDate, style: const TextStyle(fontSize: 16)),
                    Icon(Icons.calendar_today,
                        color: Colors.grey.shade500, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Ghi chú
            _buildLabel('Ghi chú'),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Nhập ghi chú (tùy chọn)',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1868D5)),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                // Lấy số tiền và loại bỏ các ký tự không phải số
                final amountText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
                final amount = int.tryParse(amountText);
                
                if (amount != null && amount > 0) {
                  // Khởi tạo TransactionModel
                  final newTransaction = TransactionModel(
                    id: widget.transaction?.id,
                    title: _titleController.text.isNotEmpty 
                        ? _titleController.text 
                        : _selectedCategory, // Ưu tiên tên tự điền, nếu trống lấy tên danh mục
                    category: _selectedCategory,
                    amount: amount,
                    isIncome: !_isExpense,
                    date: _selectedDate,
                    note: _noteController.text,
                  );

                  // Lưu vào Database
                  if (widget.transaction == null) {
                    await DatabaseHelper.instance.insertTransaction(newTransaction);
                  } else {
                    await DatabaseHelper.instance.updateTransaction(newTransaction);
                  }
                  
                  // Trả về true để HomeScreen biết có thay đổi
                  if (!context.mounted) return;
                  Navigator.pop(context, true);
                } else {
                  // Báo lỗi nhập thiếu số tiền
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập số tiền hợp lệ')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1868D5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Lưu',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'add_transaction_screen.dart';
import '../widgets/home_widgets.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<TransactionModel> _transactions = [];
  int _totalIncome = 0;
  int _totalExpense = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  // Load danh sách giao dịch từ DB
  Future<void> loadTransactions() async {
    setState(() => _isLoading = true);
    final transactions = await DatabaseHelper.instance.getAllTransactions();
    
    // Nếu DB trống, tạo dữ liệu mẫu (mock data)
    if (transactions.isEmpty) {
      final mockData = [
        TransactionModel(title: 'Ăn trưa', category: 'Ăn uống', amount: 50000, isIncome: false, date: DateTime(2024, 9, 3)),
        TransactionModel(title: 'Xăng xe', category: 'Di chuyển', amount: 100000, isIncome: false, date: DateTime(2024, 9, 3)),
        TransactionModel(title: 'Lương tháng 9', category: 'Thu nhập', amount: 8000000, isIncome: true, date: DateTime(2024, 9, 1)),
        TransactionModel(title: 'Mua sắm', category: 'Mua sắm', amount: 300000, isIncome: false, date: DateTime(2024, 8, 31)),
        TransactionModel(title: 'Học phí', category: 'Giáo dục', amount: 500000, isIncome: false, date: DateTime(2024, 8, 30)),
      ];
      for (var item in mockData) {
        await DatabaseHelper.instance.insertTransaction(item);
      }
      _transactions = await DatabaseHelper.instance.getAllTransactions();
    } else {
      _transactions = transactions;
    }

    _calculateTotals();
    setState(() => _isLoading = false);
  }

  // Tính toán số dư
  void _calculateTotals() {
    _totalIncome = 0;
    _totalExpense = 0;
    for (var tx in _transactions) {
      if (tx.isIncome) {
        _totalIncome += tx.amount;
      } else {
        _totalExpense += tx.amount;
      }
    }
  }

  int get _balance => _totalIncome - _totalExpense;

  // Cấu hình icon/màu sắc dựa theo danh mục
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

  // Hàm định dạng ngày
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Hàm định dạng số tiền (ví dụ: 50000 -> 50.000)
  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: [
        BalanceCard(balance: _balance),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: 'TỔNG THU NHẬP',
                amount: '${_formatCurrency(_totalIncome)} đ',
                icon: Icons.arrow_downward,
                color: Color(0xFF22C55E),
                backgroundColor: Color(0xFFF0FDF4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                title: 'TỔNG CHI TIÊU',
                amount: '${_formatCurrency(_totalExpense)} đ',
                icon: Icons.arrow_upward,
                color: Color(0xFFEF4444),
                backgroundColor: Color(0xFFFEF2F2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Giao dịch gần đây',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Xem tất cả',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5), // ~0.02 opacity
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _transactions.length,
            separatorBuilder: (context, index) => const Divider(
                height: 1, indent: 70, endIndent: 16, color: Color(0xFFF1F5F9)),
            itemBuilder: (context, index) {
              final tx = _transactions[index];
              final style = _getCategoryStyle(tx.category);
              
              return TransactionItem(
                icon: style['icon'],
                iconColor: style['color'],
                title: tx.title,
                subtitle: tx.category,
                date: _formatDate(tx.date),
                amount: '${tx.isIncome ? '+' : '-'}${_formatCurrency(tx.amount)} đ',
                isIncome: tx.isIncome,
                onTap: () async {
                  // Mở màn hình Thêm/Sửa giao dịch (chế độ sửa)
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTransactionScreen(transaction: tx),
                    ),
                  );
                  // Reload lại data nếu có thay đổi
                  if (result == true) {
                    loadTransactions();
                  }
                },
              );
            },
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

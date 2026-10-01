import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../widgets/home_widgets.dart';
import 'add_transaction_screen.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => TransactionListScreenState();
}

class TransactionListScreenState extends State<TransactionListScreen> {
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final transactions = await DatabaseHelper.instance.getAllTransactions();
    if (mounted) {
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    }
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Map<String, dynamic> _getCategoryStyle(String category) {
    switch (category) {
      case 'Ăn uống': return {'icon': Icons.restaurant, 'color': const Color(0xFFF97316)};
      case 'Di chuyển': return {'icon': Icons.directions_car, 'color': const Color(0xFF3B82F6)};
      case 'Thu nhập': return {'icon': Icons.savings, 'color': const Color(0xFF22C55E)};
      case 'Tiền thưởng': return {'icon': Icons.card_giftcard, 'color': const Color(0xFF22C55E)};
      case 'Đầu tư': return {'icon': Icons.trending_up, 'color': const Color(0xFF22C55E)};
      case 'Mua sắm': return {'icon': Icons.shopping_cart, 'color': const Color(0xFFA855F7)};
      case 'Giáo dục': return {'icon': Icons.school, 'color': const Color(0xFF14B8A6)};
      default: return {'icon': Icons.category, 'color': const Color(0xFF64748B)};
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_transactions.isEmpty) {
      return const Center(
        child: Text(
          'Chưa có giao dịch nào',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 80),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final tx = _transactions[index];
        final style = _getCategoryStyle(tx.category);
        
        return Column(
          children: [
            TransactionItem(
              icon: style['icon'],
              iconColor: style['color'],
              title: tx.title,
              subtitle: tx.category,
              date: _formatDate(tx.date),
              amount: '${tx.isIncome ? '+' : '-'}${_formatCurrency(tx.amount)} đ',
              isIncome: tx.isIncome,
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTransactionScreen(transaction: tx),
                  ),
                );
                if (result == true) {
                  loadTransactions();
                }
              },
            ),
            if (index < _transactions.length - 1)
              const Divider(height: 1, indent: 70, endIndent: 16, color: Color(0xFFF1F5F9)),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/database_helper.dart';
import '../models/transaction_model.dart';


class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;
  
  // Dữ liệu tính toán
  final Map<String, int> _categoryExpenses = {};
  int _totalExpense = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    final transactions = await DatabaseHelper.instance.getAllTransactions();
    
    if (mounted) {
      _transactions = transactions;
      _calculateStatistics();
      setState(() => _isLoading = false);
    }
  }

  void _calculateStatistics() {
    _categoryExpenses.clear();
    _totalExpense = 0;

    for (var tx in _transactions) {
      if (!tx.isIncome) {
        _totalExpense += tx.amount;
        if (_categoryExpenses.containsKey(tx.category)) {
          _categoryExpenses[tx.category] = _categoryExpenses[tx.category]! + tx.amount;
        } else {
          _categoryExpenses[tx.category] = tx.amount;
        }
      }
    }
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  }

  Map<String, dynamic> _getCategoryStyle(String category) {
    switch (category) {
      case 'Ăn uống': return {'icon': Icons.restaurant, 'color': const Color(0xFFF97316)};
      case 'Di chuyển': return {'icon': Icons.directions_car, 'color': const Color(0xFF3B82F6)};
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

    if (_totalExpense == 0) {
      return const Center(
        child: Text(
          'Chưa có dữ liệu chi tiêu',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    // Chuyển Map thành List và sắp xếp giảm dần theo số tiền chi
    var sortedCategories = _categoryExpenses.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Tạo dữ liệu cho PieChart
    List<PieChartSectionData> pieSections = [];
    for (var entry in sortedCategories) {
      final style = _getCategoryStyle(entry.key);
      final percentage = (entry.value / _totalExpense) * 100;
      
      pieSections.add(
        PieChartSectionData(
          color: style['color'],
          value: entry.value.toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Khối Biểu đồ tròn
        Container(
          height: 250,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  sections: pieSections,
                  borderData: FlBorderData(show: false),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tổng chi',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${_formatCurrency(_totalExpense)} đ',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        const Text(
          'Top chi tiêu nhiều nhất',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),

        // Danh sách thống kê
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: sortedCategories.map((entry) {
              final style = _getCategoryStyle(entry.key);
              final isLast = entry.key == sortedCategories.last.key;
              
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: style['color'],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(style['icon'], color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          '-${_formatCurrency(entry.value)} đ',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, indent: 70, endIndent: 16, color: Color(0xFFF1F5F9)),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 80), // Khoảng trống cho FAB
      ],
    );
  }
}

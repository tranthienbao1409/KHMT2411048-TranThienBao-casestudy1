import 'transaction_model.dart';

class FilterModel {
  int transactionType; // 0: Tất cả, 1: Thu nhập, 2: Chi tiêu
  String category;
  int timeRange; // 0: Hôm nay, 1: 7 ngày qua, 2: Tháng này, 3: Tùy chỉnh, 4: Tất cả thời gian
  DateTime? startDate;
  DateTime? endDate;

  FilterModel({
    this.transactionType = 0,
    this.category = 'Tất cả danh mục',
    this.timeRange = 4, // Mặc định là Tất cả thời gian
    this.startDate,
    this.endDate,
  });

  // Hàm hỗ trợ lọc dữ liệu trực tiếp trong bộ nhớ
  bool match(TransactionModel tx) {
    // 1. Lọc theo Loại giao dịch
    if (transactionType == 1 && !tx.isIncome) return false;
    if (transactionType == 2 && tx.isIncome) return false;

    // 2. Lọc theo Danh mục
    if (category != 'Tất cả danh mục' && tx.category != category) return false;

    // 3. Lọc theo Khoảng thời gian
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);

    if (timeRange == 0 && txDate != today) return false; // Hôm nay
    
    if (timeRange == 1 && txDate.isBefore(today.subtract(const Duration(days: 7)))) {
      return false; // 7 ngày qua
    }
    
    if (timeRange == 2 && (tx.date.month != now.month || tx.date.year != now.year)) {
      return false; // Tháng này
    }
    
    if (timeRange == 3 && startDate != null && endDate != null) {
      // Tùy chỉnh
      final start = DateTime(startDate!.year, startDate!.month, startDate!.day);
      final end = DateTime(endDate!.year, endDate!.month, endDate!.day, 23, 59, 59);
      if (tx.date.isBefore(start) || tx.date.isAfter(end)) return false;
    }

    return true; // Thỏa mãn mọi điều kiện
  }
}

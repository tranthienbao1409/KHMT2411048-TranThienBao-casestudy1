class TransactionModel {
  final int? id;
  final String title;
  final String category; // Ví dụ: 'Ăn uống', 'Di chuyển'
  final int amount; // Số tiền (ví dụ: 50000)
  final bool isIncome; // true: Thu nhập (+), false: Chi tiêu (-)
  final DateTime date;
  final String? note;

  TransactionModel({
    this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.note,
  });

  // Chuyển đối tượng thành Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'isIncome': isIncome ? 1 : 0, // SQLite không có kiểu bool, dùng 1 và 0
      'date': date.toIso8601String(), // Lưu ngày dưới dạng Text (ISO 8601)
      'note': note,
    };
  }

  // Khởi tạo đối tượng từ Map (khi đọc từ SQLite ra)
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      category: map['category'],
      amount: map['amount'],
      isIncome: map['isIncome'] == 1,
      date: DateTime.parse(map['date']),
      note: map['note'],
    );
  }

  // Tạo một bản sao chép của model (dùng khi cập nhật)
  TransactionModel copyWith({
    int? id,
    String? title,
    String? category,
    int? amount,
    bool? isIncome,
    DateTime? date,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      isIncome: isIncome ?? this.isIncome,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}

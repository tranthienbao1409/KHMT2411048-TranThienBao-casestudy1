import 'package:flutter/material.dart';
import '../models/filter_model.dart';

class FilterScreen extends StatefulWidget {
  final FilterModel currentFilter;

  const FilterScreen({super.key, required this.currentFilter});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late int _transactionType;
  late String _category;
  late int _timeRange;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _allCategories = [
    'Tất cả danh mục',
    'Ăn uống',
    'Di chuyển',
    'Mua sắm',
    'Giáo dục',
    'Thu nhập',
    'Tiền thưởng',
    'Đầu tư'
  ];

  @override
  void initState() {
    super.initState();
    // Copy giá trị từ filter hiện tại
    _transactionType = widget.currentFilter.transactionType;
    _category = widget.currentFilter.category;
    _timeRange = widget.currentFilter.timeRange;
    _startDate = widget.currentFilter.startDate ?? DateTime.now();
    _endDate = widget.currentFilter.endDate ?? DateTime.now();
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, int value) {
    return InkWell(
      onTap: () => setState(() {
        _transactionType = value;
        if (value == 1 && !_allCategories.skip(5).contains(_category)) {
          _category = 'Tất cả danh mục';
        } else if (value == 2 && !_allCategories.skip(1).take(4).contains(_category)) {
          _category = 'Tất cả danh mục';
        }
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _transactionType == value,
                onChanged: (_) => setState(() => _transactionType = value),
                activeColor: const Color(0xFF1868D5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(String title, int value) {
    return InkWell(
      onTap: () => setState(() => _timeRange = value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Radio<int>(
                value: value,
                groupValue: _timeRange,
                onChanged: (_) => setState(() => _timeRange = value),
                activeColor: const Color(0xFF1868D5),
              ),
            ),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(bool isStart) async {
    final initialDate = isStart ? _startDate! : _endDate!;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1868D5),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate!.isBefore(_startDate!)) _endDate = _startDate;
        } else {
          _endDate = picked;
          if (_startDate!.isAfter(_endDate!)) _startDate = _endDate;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
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
          'Bộ lọc',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Loại giao dịch'),
            _buildCheckbox('Tất cả', 0),
            _buildCheckbox('Thu nhập', 1),
            _buildCheckbox('Chi tiêu', 2),

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
                  value: _category,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  items: _allCategories.map((String category) {
                    // Logic ẩn bớt danh mục nếu chọn riêng Thu Nhập hoặc Chi Tiêu
                    if (_transactionType == 1 && category != 'Tất cả danh mục' && !_allCategories.skip(5).contains(category)) {
                      return null;
                    }
                    if (_transactionType == 2 && category != 'Tất cả danh mục' && !_allCategories.skip(1).take(4).contains(category)) {
                      return null;
                    }

                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category, style: const TextStyle(fontSize: 16)),
                    );
                  }).whereType<DropdownMenuItem<String>>().toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() => _category = newValue);
                    }
                  },
                ),
              ),
            ),

            _buildLabel('Khoảng thời gian'),
            _buildRadio('Tất cả thời gian', 4),
            _buildRadio('Hôm nay', 0),
            _buildRadio('7 ngày qua', 1),
            _buildRadio('Tháng này', 2),
            _buildRadio('Tùy chỉnh', 3),

            if (_timeRange == 3) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickDate(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(_formatDate(_startDate!)),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('-', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickDate(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(_formatDate(_endDate!)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 40),
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
              onPressed: () {
                final newFilter = FilterModel(
                  transactionType: _transactionType,
                  category: _category,
                  timeRange: _timeRange,
                  startDate: _startDate,
                  endDate: _endDate,
                );
                Navigator.pop(context, newFilter);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1868D5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Áp dụng',
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

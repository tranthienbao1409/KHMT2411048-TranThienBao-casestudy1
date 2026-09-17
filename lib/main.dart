import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E65C9),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Bạn có thể thêm font tuỳ chỉnh vào pubspec.yaml sau
      ),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              const Spacer(flex: 2), // Đẩy nội dung ra giữa màn hình
              
              // Custom Widget vẽ icon chiếc ví
              const WalletIcon(),
              
              const SizedBox(height: 48),
              
              // Tiêu đề
              const Text(
                'Expense Manager',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: 0.5,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Mô tả
              const Text(
                'Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const Spacer(flex: 3), // Đẩy nút bấm xuống cuối
              
              // Nút Bắt đầu
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Xử lý sự kiện khi bấm nút
                    print("Bắt đầu clicked!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1868D5), // Màu xanh của nút
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8), // Khoảng cách an toàn với cạnh dưới
            ],
          ),
        ),
      ),
    );
  }
}

// Widget tự custom vẽ lại cái ví giống hệt trong ảnh thiết kế
class WalletIcon extends StatelessWidget {
  const WalletIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 110,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Lớp tiền màu xanh lá cây đậm (tờ nằm phía sau)
          Positioned(
            top: 15,
            left: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF539C56),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Lớp tiền màu xanh lá cây nhạt (tờ nằm phía trước)
          Positioned(
            top: 5,
            child: Container(
              width: 90,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF81C784),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Thân ví màu xanh dương
          Container(
            width: 140,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF2276E3),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          // Phần quai cài của ví
          Positioned(
            right: 0,
            bottom: 22,
            child: Container(
              width: 45,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF155CB9), // Xanh dương đậm hơn
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

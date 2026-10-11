import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Cá nhân',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 1. Khối thông tin người dùng
          Container(
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE2E8F0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 36,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Người dùng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'user@example.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF1868D5)),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Khối Cài đặt chung
          const Text(
            'CÀI ĐẶT CHUNG',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
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
              children: [
                _buildListTile(
                  icon: Icons.account_balance_wallet,
                  iconColor: const Color(0xFF3B82F6),
                  title: 'Cài đặt ngân sách',
                  subtitle: 'Quản lý hạn mức chi tiêu',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _buildListTile(
                  icon: Icons.security,
                  iconColor: const Color(0xFF22C55E),
                  title: 'Quyền và Tài khoản',
                  subtitle: 'Bảo mật, đăng nhập sinh trắc học',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _buildListTile(
                  icon: Icons.notifications,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Thông báo',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _buildListTile(
                  icon: Icons.language,
                  iconColor: const Color(0xFF8B5CF6),
                  title: 'Ngôn ngữ',
                  trailing: const Text(
                    'Tiếng Việt',
                    style: TextStyle(color: Color(0xFF64748B)),
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Khối Khác
          const Text(
            'KHÁC',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
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
              children: [
                _buildListTile(
                  icon: Icons.help_outline,
                  iconColor: const Color(0xFF64748B),
                  title: 'Trung tâm trợ giúp',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _buildListTile(
                  icon: Icons.star_rate,
                  iconColor: const Color(0xFFEAB308),
                  title: 'Đánh giá ứng dụng',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _buildListTile(
                  icon: Icons.logout,
                  iconColor: const Color(0xFFEF4444),
                  title: 'Đăng xuất',
                  titleColor: const Color(0xFFEF4444),
                  hideArrow: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          const Center(
            child: Text(
              'Phiên bản 1.0.0',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // Widget hỗ trợ để tạo từng hàng (Row) trong mục cài đặt
  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Color? titleColor,
    Widget? trailing,
    bool hideArrow = false,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withAlpha(25), // ~10% opacity
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: titleColor ?? const Color(0xFF0F172A),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            )
          : null,
      trailing: hideArrow
          ? null
          : trailing ?? const Icon(Icons.chevron_right, color: Color(0xFFCBD5E1)),
      onTap: onTap,
    );
  }
}

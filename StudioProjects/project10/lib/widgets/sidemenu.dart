import 'package:flutter/material.dart';
import '../pages/dashboard.dart';
import '../pages/book.dart';
import '../pages/user_list_page.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF2C5CC5),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF244CB3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu_book, size: 40, color: Colors.white),
                SizedBox(height: 10),
                Text("BookAdmin", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          _buildMenuItem(context, "Dashboard", Icons.dashboard, const DashboardPage()),
          _buildMenuItem(context, "Kelola Genre", Icons.category, null),
          _buildMenuItem(context, "Kelola User", Icons.person, const UserListPage()),
          _buildMenuItem(context, "Kelola Buku", Icons.book, const BookPage()),
          _buildMenuItem(context, "Tulis Buku", Icons.edit, null),
          const Divider(color: Colors.white54),
          _buildMenuItem(context, "Logout", Icons.logout, null),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Widget? page) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        if (page != null) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
        }
      },
    );
  }
}
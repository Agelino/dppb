  import 'package:flutter/material.dart';
  import 'forum_page.dart';
  import 'genre_page.dart';
  

  class DashboardUserPage extends StatelessWidget {
    const DashboardUserPage({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard User"),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔵 PROFILE CARD
              _buildProfileCard(),

              const SizedBox(height: 20),

              // 🔵 STATISTIK USER
              const Text(
                "Aktivitas Kamu",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  _buildStatCard("Buku Dibaca", "12", Colors.deepPurple),
                  const SizedBox(width: 10),
                  _buildStatCard("Forum Aktif", "5", Colors.teal),
                ],
              ),

              const SizedBox(height: 30),

              // 🔵 QUICK MENU
              const Text(
                "Menu Cepat",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              _buildMenuButton(
                context,
                Icons.forum,
                "Masuk Forum Diskusi",
                    () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ForumPage())),
              ),

              const SizedBox(height: 10),

              _buildMenuButton(
                context,
                Icons.menu_book,
                "Genre Buku",
                    () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => GenrePage())),
              ),

              const SizedBox(height: 30),

              // 🔵 REKOMENDASI BUKU
              const Text(
                "Rekomendasi Buku",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),
              _buildBookItem("Atomic Habits", "James Clear"),
              _buildBookItem("Clean Code", "Robert C. Martin"),
              _buildBookItem("The Psychology of Money", "Morgan Housel"),
            ],
          ),
        ),
      );
    }

    // === WIDGET PROFILE ===
    Widget _buildProfileCard() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade600,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("User", style: TextStyle(fontSize: 18, color: Colors.white)),
                Text("Selamat datang kembali!",
                    style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ],
        ),
      );
    }

    // === WIDGET STAT CARD ===
    Widget _buildStatCard(String title, String value, Color color) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
      );
    }

    // === WIDGET MENU BUTTON ===
    Widget _buildMenuButton(
        BuildContext context, IconData icon, String label, Function onTap) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => onTap(),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      );
    }

    // === WIDGET BOOK RECOMMEND ===
    Widget _buildBookItem(String title, String author) {
      return Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.book, size: 40, color: Colors.blue),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(author, style: TextStyle(color: Colors.grey.shade600)),
              ],
            )
          ],
        ),
      );
    }
  }

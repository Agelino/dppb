import 'package:flutter/material.dart';
import '../widgets/sidemenu.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, String>> newsList = [
      {
        "title": "Event Bedah Buku 2024",
        "desc": "Mengundang penulis ternama untuk membedah karya...",
        "image": "asset/feby.jpeg",
        "time": "Admin - 10 menit lalu"
      },
      {
        "title": "Update Fitur Peminjaman",
        "desc": "Sekarang peminjaman buku bisa dilakukan lewat aplikasi...",
        "image": "asset/sharone.jpeg",
        "time": "System - 1 jam lalu"
      },
      {
        "title": "Pemenang Lomba Menulis",
        "desc": "Selamat kepada para pemenang lomba cerpen bulan ini...",
        "image": "asset/adzra.jpeg",
        "time": "Admin - 5 jam lalu"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      drawer: const SideMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text("Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            Row(
              children: [
                _buildStatCard("Total Buku", "120", Colors.blue),
                const SizedBox(width: 10),
                _buildStatCard("Total User", "45", Colors.orange),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatCard("Genre", "8", Colors.purple),
                const SizedBox(width: 10),
                _buildStatCard("Review", "312", Colors.green),
              ],
            ),

            const SizedBox(height: 25),


            const Text("Berita & Aktivitas Terbaru", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return _buildNewsItem(news);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(count, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(title, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  // berita nya
  Widget _buildNewsItem(Map<String, String> news) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              news['image']!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),

          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(news['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text(
                  news['desc']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 5),
                Text(news['time']!, style: const TextStyle(fontSize: 10, color: Colors.blue)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
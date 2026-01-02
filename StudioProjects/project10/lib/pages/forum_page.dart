import 'package:flutter/material.dart';
import 'forum_detail_page.dart';

class ForumPage extends StatefulWidget {
  final String newTitle;
  final String newDesc;

  ForumPage({required this.newTitle, required this.newDesc});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<Map<String, String>> dummyTopics = [
    {
      'judul': 'Diskusi Novel Fantasi',
      'deskripsi': 'Ayo bahas novel fantasi favoritmu!',
    },
    {
      'judul': 'Rekomendasi Buku Horor',
      'deskripsi': 'Share buku horor paling menyeramkan!',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Tambah data baru di sini, BUKAN di build()
    if (widget.newTitle.isNotEmpty) {
      dummyTopics.insert(0, {
        'judul': widget.newTitle,
        'deskripsi': widget.newDesc,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("Daftar Forum Diskusi"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: dummyTopics.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ForumDetailPage(
                      title: dummyTopics[index]['judul']!),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 6,
                      color: Colors.black12,
                      offset: Offset(0, 3))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dummyTopics[index]['judul']!,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    dummyTopics[index]['deskripsi'] ?? "",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

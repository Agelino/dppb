import 'package:flutter/material.dart';
import 'forum_page.dart';

class AddForumPage extends StatefulWidget {
  @override
  _AddForumPageState createState() => _AddForumPageState();
}

class _AddForumPageState extends State<AddForumPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text("Tambah Topik Diskusi"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Judul Topik",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Deskripsi",
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700),
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ForumPage(
                        newTitle: titleController.text,
                        newDesc: descController.text,
                      ),
                    ),
                  );
                }
              },
              child: Text("Lanjut", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

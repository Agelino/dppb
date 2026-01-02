import 'package:flutter/material.dart';

class ForumDetailPage extends StatefulWidget {
  final String title;
  ForumDetailPage({required this.title});

  @override
  _ForumDetailPageState createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final List<String> comments = [
    "Menurutku bukunya seru banget!",
    "Aku suka tokoh villain-nya!",
  ];

  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade400,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(comments[index]),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black26,
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: "Tambahkan komentar...",
                      filled: true,
                      fillColor: Colors.blue.shade100,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (commentController.text.trim().isNotEmpty) {
                      setState(() {
                        comments.add(commentController.text.trim());
                      });
                      commentController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: StadiumBorder(),
                  ),
                  child: Icon(Icons.send, color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

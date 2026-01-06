import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/forum_model.dart';
import '../models/comment_model.dart';
import '../services/api.dart';

class ForumDetailPage extends StatefulWidget {
  final ForumModel forum;
  const ForumDetailPage({super.key, required this.forum});

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  final TextEditingController commentC = TextEditingController();
  late Future<List<CommentModel>> comments;

  // 🔴 PAKAI TOKEN LOGIN ASLI
  final String token = '9|hyRJQXqnwMXl40RzwNWoxrYDZ1clMDt7Ghgfkv4S8eae6060';

  @override
  void initState() {
    super.initState();
    comments = fetchComments();
  }

  // ======================
  // FETCH KOMENTAR
  // ======================
  Future<List<CommentModel>> fetchComments() async {
    final res = await http.get(
      Uri.parse('$baseUrl/forum/${widget.forum.id}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal mengambil komentar');
    }

    final json = jsonDecode(res.body);
    final List list = json['data']['comments'] ?? [];

    return list.map((e) => CommentModel.fromJson(e)).toList();
  }

  // ======================
  // KIRIM KOMENTAR
  // ======================
  Future<void> sendComment() async {
    if (commentC.text.trim().isEmpty) return;

    final res = await http.post(
      Uri.parse('$baseUrl/forum/comment'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'topic_id': widget.forum.id,
        'isi': commentC.text,
      }),
    );

    if (res.statusCode == 201) {
      commentC.clear();
      setState(() {
        comments = fetchComments();
      });
    } else {
      debugPrint(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim komentar')),
      );
    }
  }

  // ======================
  // UI
  // ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Forum')),
      body: Column(
        children: [
          // 🔹 ISI FORUM
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.forum.judul,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(widget.forum.isi),
              ],
            ),
          ),

          const Divider(),

          // 🔹 LIST KOMENTAR
          Expanded(
            child: FutureBuilder<List<CommentModel>>(
              future: comments,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('Belum ada komentar'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    final c = snapshot.data![i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(
                          c.user,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(c.isi),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 🔹 INPUT KOMENTAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentC,
                    decoration: const InputDecoration(
                      hintText: 'Tulis komentar...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

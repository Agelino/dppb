import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user_list.dart';
import '../models/komentar_model.dart';

class KomentarPage extends StatefulWidget {
  final int bookId;
  final int page;

  const KomentarPage({
    super.key,
    required this.bookId,
    required this.page,
  });

  @override
  State<KomentarPage> createState() => _KomentarPageState();
}

class _KomentarPageState extends State<KomentarPage> {
  final TextEditingController commentController = TextEditingController();
  List<Komentar> comments = [];
  bool isLoading = true;

  static const String api = 'http://127.0.0.1:8000/api';

  @override
  void initState() {
    super.initState();
    getComments();
  }

  // GET KOMENTAR
  Future<void> getComments() async {
    try {
      final res = await http.get(
        Uri.parse('$api/komentar/${widget.bookId}/${widget.page}'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final List list = decoded['data'];

        setState(() {
          comments = list.map((e) => Komentar.fromJson(e)).toList();
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  // POST KOMENTAR
  Future<void> addComment() async {
    if (commentController.text.trim().isEmpty) return;

    final res = await http.post(
      Uri.parse('$api/komentar'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer $authToken",
      },
      body: {
        "book_id": widget.bookId.toString(),
        "page": widget.page.toString(),
        "komentar": commentController.text,
      },
    );

    if (res.statusCode == 201) {
      commentController.clear();
      getComments();
      snackbar("Komentar berhasil dikirim");
    } else {
      snackbar("Gagal mengirim komentar");
    }
  }

  // DELETE KOMENTAR
  Future<void> deleteComment(int id) async {
    final res = await http.delete(
      Uri.parse('$api/komentar/$id'),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    if (res.statusCode == 200) {
      getComments();
      snackbar("Komentar dihapus");
    } else {
      snackbar("Tidak punya akses");
    }
  }

  void snackbar(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Komentar")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "Tulis komentar...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: addComment,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: comments.isEmpty
                      ? const Center(child: Text("Belum ada komentar"))
                      : ListView.builder(
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final c = comments[index];

                            final bool isOwn =
                                currentUser != null &&
                                c.userId == currentUser!.id;

                            return ListTile(
                              title: Text(
                                c.username,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(c.komentar),
                              trailing: isOwn
                                  ? IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          deleteComment(c.id),
                                    )
                                  : null,
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

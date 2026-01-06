import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user_list.dart';
import 'genre_page.dart';
import 'komentar.dart';

class FullBacaanPage2 extends StatefulWidget {
  final int bookId;

  const FullBacaanPage2({super.key, required this.bookId});

  @override
  State<FullBacaanPage2> createState() => _FullBacaanPage2State();
}

class _FullBacaanPage2State extends State<FullBacaanPage2> {
  double fontSize = 15;
  bool isLoading = true;

  String judul = '';
  String chapter = 'Chapter 2';
  String isi = '';

  final TextEditingController commentController = TextEditingController();
  List comments = [];

  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // ================= GET BACAAAN + KOMENTAR =================
  Future<void> getBacaanLanjutan() async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/books/${widget.bookId}?page=2'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      final decoded = jsonDecode(res.body);

      if (res.statusCode == 200) {
        setState(() {
          judul = decoded['data']['title'];
          isi = decoded['data']['content'] ?? '';
          comments = decoded['data']['komentar'] ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      snackbar("Gagal memuat bacaan lanjutan");
    }
  }

  // ================= ADD COMMENT =================
  Future<void> addComment() async {
    if (commentController.text.trim().isEmpty) return;

    try {
      final res = await http.post(
        Uri.parse('$baseUrl/comments'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: {
          "book_id": widget.bookId.toString(),
          "komentar": commentController.text.trim(),
        },
      );

      if (res.statusCode == 200) {
        commentController.clear();
        getBacaanLanjutan();
        snackbar("Komentar berhasil dikirim");
      }
    } catch (e) {
      snackbar("Gagal mengirim komentar");
    }
  }

  void snackbar(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  void changeFont(double delta) {
    setState(() {
      if (delta == 0) {
        fontSize = 15;
      } else {
        fontSize = (fontSize + delta).clamp(13, 22);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getBacaanLanjutan();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffEFEFF0),
      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: const Color(0xff6F98D9),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Lanjutan Bacaan",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )
                ],
              ),
            ),

            // ================= CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      judul,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff27496D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(chapter,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.grey)),

                    const SizedBox(height: 20),

                    // FONT CONTROL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                            onPressed: () => changeFont(-1),
                            child: const Text("A -")),
                        const SizedBox(width: 8),
                        OutlinedButton(
                            onPressed: () => changeFont(0),
                            child: const Text("A")),
                        const SizedBox(width: 8),
                        OutlinedButton(
                            onPressed: () => changeFont(1),
                            child: const Text("A +")),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ISI BACAAN
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        isi,
                        style: TextStyle(fontSize: fontSize, height: 1.7),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ================= NAVIGATION =================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const GenrePage()),
                            );
                          },
                          child: const Text('Daftar Buku'),
                        ),
                        ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => KomentarPage(
                                bookId: widget.bookId,
                                page: 2, 
                              ),
                            ),
                          );
                        },
                        child: const Text('Komentar'),
                      ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

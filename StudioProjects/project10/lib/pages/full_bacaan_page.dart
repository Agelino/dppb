import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/book_model.dart';
import 'full_bacaan_page_2.dart'; 
import 'genre_page.dart';      
import 'komentar.dart';    

class FullBacaanPage extends StatefulWidget {
  final int bookId;

  const FullBacaanPage({super.key, required this.bookId});

  @override
  State<FullBacaanPage> createState() => _FullBacaanPageState();
}

class _FullBacaanPageState extends State<FullBacaanPage> {
  late Future<Book> book;
  double fontSize = 15;

  static const String baseUrl = 'http://localhost:8000/api';

  @override
  void initState() {
    super.initState();
    book = fetchBook();
  }

  Future<Book> fetchBook() async {
    final res = await http.get(Uri.parse('$baseUrl/books/${widget.bookId}'));

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      return Book.fromJson(decoded['data']);
    } else {
      throw Exception('Gagal memuat bacaan');
    }
  }

  void showAction() {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListTile(
        leading: const Icon(Icons.favorite),
        title: const Text('Tambah ke favorit'),
        onTap: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ditambahkan ke favorit')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Baca Buku'),
        backgroundColor: const Color(0xff6F98D9),
        actions: [
          IconButton(onPressed: showAction, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: FutureBuilder<Book>(
        future: book,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final b = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                Text('${b.author} • ${b.year}',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),

                // tombol pengubah font
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: () => setState(() => fontSize--),
                        child: const Text('A-')),
                    const SizedBox(width: 8),
                    OutlinedButton(
                        onPressed: () => setState(() => fontSize = 15),
                        child: const Text('A')),
                    const SizedBox(width: 8),
                    OutlinedButton(
                        onPressed: () => setState(() => fontSize++),
                        child: const Text('A+')),
                  ],
                ),

                const SizedBox(height: 20),

                // konten buku
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    b.content,
                    style: TextStyle(fontSize: fontSize, height: 1.7),
                  ),
                ),

                const SizedBox(height: 30),

                // tombol navigasi
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  FullBacaanPage2(bookId: widget.bookId)),
                        );
                      },
                      child: const Text('Selanjutnya'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const GenrePage()),
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
                            page: 1, 
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
          );
        },
      ),
    );
  }
}

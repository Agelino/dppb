import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/book_model.dart';
import '../widgets/book_card.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({super.key});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  late Future<List<Book>> books;

  // ✅ URL BENAR
  static const String baseUrl = 'http://127.0.0.1:8000/api/books';

  @override
  void initState() {
    super.initState();
    books = fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    // ✅ JANGAN TAMBAH /books LAGI
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);

      // ✅ SESUAI STRUKTUR POSTMAN
      final List list = decoded['data']['data'];

      return list.map((e) => Book.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil buku');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semua Buku')),
      body: FutureBuilder<List<Book>>(
        future: books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Gagal memuat buku'));
          }

          final data = snapshot.data!;

          if (data.isEmpty) {
            return const Center(child: Text('Buku tidak tersedia'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.6,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return BookCard(book: data[index]);
            },
          );
        },
      ),
    );
  }
}

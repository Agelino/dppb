import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/book_model.dart';
import '../pages/full_bacaan_page.dart';

class GenrePage extends StatefulWidget {
  const GenrePage({super.key});

  @override
  State<GenrePage> createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  late Future<List<Book>> books;

  static const String baseUrl =
      'http://127.0.0.1:8000/api/books'; 

  @override
  void initState() {
    super.initState();
    books = fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      final List list = decoded['data']['data']; // ✅ FIX

      return list.map((e) => Book.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat buku');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FA),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'Genre Buku',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR (UI only)
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari buku...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📚 GRID BUKU
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: books,
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Gagal memuat buku'));
                }

                final data = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final book = data[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                FullBacaanPage(bookId: book.id),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black12.withOpacity(0.05),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // 🖼 COVER + LOVE ICON
                            Expanded(
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: (book.image ?? '')
                                            .isNotEmpty
                                        ? Image.network(
                                            book.image,
                                            width:
                                                double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors
                                                .grey.shade200,
                                            child:
                                                const Center(
                                              child: Icon(
                                                Icons.book,
                                                size: 40,
                                                color:
                                                    Colors.grey,
                                              ),
                                            ),
                                          ),
                                  ),

                                  // ❤️ LOVE ICON
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(
                                                context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                '${book.title} ditambahkan ke favorit'),
                                            duration:
                                                const Duration(
                                                    seconds: 1),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding:
                                            const EdgeInsets.all(
                                                6),
                                        decoration:
                                            BoxDecoration(
                                          color: Colors.white,
                                          shape:
                                              BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black12,
                                              blurRadius: 4,
                                            )
                                          ],
                                        ),
                                        child: const Icon(
                                          Icons
                                              .favorite_border,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 📘 INFO
                            Padding(
                              padding:
                                  const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    maxLines: 2,
                                    overflow: TextOverflow
                                        .ellipsis,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    book.author,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

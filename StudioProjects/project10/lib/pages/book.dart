import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/book_model.dart';
import '../widgets/sidemenu.dart';
import 'create.dart';
import 'edit.dart';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late List<Book> books;

  @override
  void initState() {
    super.initState();
    books = [];
    _fetchBooks();
  }

  // ===== FETCH DATA (GANTI DUMMY) =====
  Future<void> _fetchBooks() async {
    final response =
        await http.get(Uri.parse("http://10.0.2.2:8000/api/books"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        books = data.map((e) => Book.fromJson(e)).toList();
      });
    }
  }

  // Refresh (LOGIKA TETAP)
  void _refresh() {
    _fetchBooks();
  }

  // Delete (LOGIKA TETAP)
  void _delete(int id) async {
    await http.delete(
      Uri.parse("http://10.0.2.2:8000/api/books/$id"),
    );

    setState(() {
      books.removeWhere((b) => b.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Buku dihapus")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Buku"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          const CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage('asset/agelino.jpg'),
          ),
          const SizedBox(width: 15),
        ],
      ),
      drawer: const SideMenu(),
      body: Column(
        children: [
          // ===== FILTER & ADD =====
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreatePage(),
                      ),
                    ).then((_) => _refresh());
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("Tambah Buku"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 15),
                const Text("|  Filter by Genre: ",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                _buildFilterChip("All Books", true),
                _buildFilterChip("Pemrograman", false),
                _buildFilterChip("Novel", false),
              ],
            ),
          ),

          // ===== GRID =====
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return _bookCard(book);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookCard(Book book) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: book.imagePath != null && book.imagePath!.isNotEmpty
                  ? Image.network(book.imagePath!, fit: BoxFit.cover)
                  : const Center(child: Icon(Icons.book)),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("Author: ${book.author}",
                      style: const TextStyle(fontSize: 11)),
                  Text("Year: ${book.year}",
                      style: const TextStyle(fontSize: 11)),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _smallBtn(Colors.cyan, Icons.visibility, () {}),
                      _smallBtn(Colors.blue, Icons.edit, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditPage(book: book)),
                        ).then((_) => _refresh());
                      }),
                      _smallBtn(
                          Colors.red, Icons.delete, () => _delete(book.id)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: OutlinedButton(
        onPressed: () {},
        child: Text(label),
      ),
    );
  }

  Widget _smallBtn(
      Color color, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }
}

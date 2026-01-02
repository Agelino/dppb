import 'package:flutter/material.dart';
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
  // Fungsi Refresh
  void _refresh() {
    setState(() {});
  }

  // Fungsi Hapus
  void _delete(String id) {
    setState(() => dummyBooks.removeWhere((b) => b.id == id));
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CreatePage())
                    ).then((_) => _refresh());
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text("Tambah Buku"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                ),
                const SizedBox(width: 15),
                const Text("|  Filter by Genre: ", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 5),
                _buildFilterChip("All Books", true),
                _buildFilterChip("Pemrograman", false),
                _buildFilterChip("Novel", false),
              ],
            ),
          ),

          // --- GRID BUKU ---
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7, // Rasio tinggi kartu
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: dummyBooks.length,
              itemBuilder: (context, index) {
                final book = dummyBooks[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 2, blurRadius: 5)
                    ],
                  ),
                  child: Column(
                    children: [

                      Expanded(
                        flex: 3,
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                            child: (book.imagePath != null && book.imagePath!.isNotEmpty)
                                ? Image.asset(
                              book.imagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.broken_image, color: Colors.grey),
                                        Text("File not found", style: TextStyle(fontSize: 10)),
                                      ],
                                    )
                                );
                              },
                            )
                                : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.book, size: 20, color: Colors.grey),
                                Text("No Image", style: TextStyle(fontSize: 10, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // --- BAGIAN INFO ---
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  book.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                              ),
                              const SizedBox(height: 5),
                              Text("Author: ${book.author}", style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                              Text("Year: ${book.year}", style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                              const Spacer(),

                              // Tombol Aksi
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _smallBtn(Colors.cyan, Icons.visibility, () {}),
                                  _smallBtn(Colors.blue, Icons.edit, () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => EditPage(book: book))
                                    ).then((_) => _refresh());
                                  }),
                                  _smallBtn(Colors.red, Icons.delete, () => _delete(book.id)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
        style: OutlinedButton.styleFrom(
          backgroundColor: isActive ? Colors.blue : Colors.white,
          foregroundColor: isActive ? Colors.white : Colors.blue,
          side: const BorderSide(color: Colors.blue),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          minimumSize: const Size(0, 30),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _smallBtn(Color color, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }
}
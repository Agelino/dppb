import 'package:flutter/material.dart';
import '../models/book_model.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveData() {
    if (_formKey.currentState!.validate()) {
      final newBook = Book(
        id: DateTime.now().millisecondsSinceEpoch, 
        title: _titleController.text,
        author: _authorController.text,
        genre: _genreController.text,
        year: int.parse(_yearController.text), 
        description: _contentController.text, 
        content: _contentController.text,
        coverImage: '',
      );

      // NOTE: nanti ganti ke API POST
      // sementara hanya pop balik
      Navigator.pop(context, newBook);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Buku berhasil ditambahkan!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Tambah Buku Baru"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Isi form di bawah untuk menambahkan buku",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildInput(
                            "Judul Buku",
                            _titleController,
                            "Contoh: Laskar Pelangi",
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          flex: 1,
                          child: _buildInput(
                            "Tahun",
                            _yearController,
                            "2024",
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    _buildInput(
                      "Penulis",
                      _authorController,
                      "Nama Pengarang",
                    ),
                    const SizedBox(height: 20),

                    _buildInput(
                      "Genre / Kategori",
                      _genreController,
                      "Novel, Pemrograman",
                    ),
                    const SizedBox(height: 20),

                    _buildInput(
                      "Deskripsi / Sinopsis",
                      _contentController,
                      "Tulis deskripsi singkat...",
                      maxLines: 5,
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Batal"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: _saveData,
                          icon: const Icon(Icons.save, size: 18),
                          label: const Text("Simpan Buku"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType:
              isNumber ? TextInputType.number : TextInputType.text,
          validator: (value) =>
              value == null || value.isEmpty ? '$label wajib diisi' : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../models/book_model.dart';

class EditPage extends StatefulWidget {
  final Book book;
  const EditPage({super.key, required this.book});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _yearController;
  late TextEditingController _authorController;
  late TextEditingController _genreController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.book.title);
    _yearController =
        TextEditingController(text: widget.book.year.toString());
    _authorController =
        TextEditingController(text: widget.book.author);
    _genreController =
        TextEditingController(text: widget.book.genre);
    _contentController =
        TextEditingController(text: widget.book.content);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final updatedBook = Book(
        id: widget.book.id, 
        title: _titleController.text,
        author: _authorController.text,
        genre: _genreController.text,
        year: int.parse(_yearController.text),
        description: _contentController.text,
        content: _contentController.text,
        image: widget.book.image, 
      );

      Navigator.pop(context, updatedBook);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Book"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Book: ${widget.book.title}",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10)
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: _buildInput(
                                "Title", _titleController)),
                        const SizedBox(width: 15),
                        Expanded(
                            child: _buildInput(
                                "Year", _yearController)),
                      ],
                    ),
                    const SizedBox(height: 15),
                    _buildInput("Author", _authorController),
                    const SizedBox(height: 15),
                    _buildInput("Genre", _genreController),
                    const SizedBox(height: 15),
                    _buildInput("Content", _contentController,
                        maxLines: 5),
                    const SizedBox(height: 20),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Book Cover Image",
                        style:
                            TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 100,
                      width: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image,
                          color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _save,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text("Update Book",
                              style:
                                  TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                          child: const Text("Cancel",
                              style:
                                  TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label,
      TextEditingController controller,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType:
              label == "Year" ? TextInputType.number : null,
          validator: (val) =>
              val == null || val.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4)),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}

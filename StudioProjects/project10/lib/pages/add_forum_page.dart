import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../services/api.dart';

class AddForumPage extends StatefulWidget {
  const AddForumPage({super.key});

  @override
  State<AddForumPage> createState() => _AddForumPageState();
}

class _AddForumPageState extends State<AddForumPage> {
  final judulC = TextEditingController();
  final isiC = TextEditingController();

  // 🔴 GANTI DENGAN TOKEN LOGIN KAMU
  final String token = '19|oG7d36MIjRao5GU9lQwSko5pBxLrEZGOrbLxjFija112761b';

  List<dynamic> genres = [];
  int? selectedGenreId;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  @override
  void dispose() {
    judulC.dispose();
    isiC.dispose();
    super.dispose();
  }

  // ========================
  // FETCH GENRE (INI PENTING)
  // ========================
  Future<void> fetchGenres() async {
    final res = await http.get(
      Uri.parse('$baseUrl/genres'),
      headers: {'Accept': 'application/json'},
    );

    final Map<String, dynamic> json = jsonDecode(res.body);

    setState(() {
      genres = json['data'];               // ⬅️ WAJIB
      selectedGenreId = genres.first['id']; // ⬅️ AUTO SELECT
    });

    debugPrint('GENRES: $genres');
  }

  // ========================
  // SUBMIT FORUM
  // ========================
  Future<void> submitForum() async {
    if (selectedGenreId == null ||
        judulC.text.isEmpty ||
        isiC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi semua data')),
      );
      return;
    }

    setState(() => loading = true);

    final res = await http.post(
      Uri.parse('$baseUrl/forum'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'genre_id': selectedGenreId,
        'judul': judulC.text,
        'isi': isiC.text,
      }),
    );

    setState(() => loading = false);

    if (res.statusCode == 201 || res.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      debugPrint(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambah forum')),
      );
    }
  }

  // ========================
  // UI
  // ========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Forum')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: genres.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  // DROPDOWN GENRE
                  DropdownButtonFormField<int>(
                    value: selectedGenreId,
                    decoration: const InputDecoration(
                      labelText: 'Genre',
                      border: OutlineInputBorder(),
                    ),
                    items: genres.map<DropdownMenuItem<int>>((g) {
                      return DropdownMenuItem<int>(
                        value: g['id'],
                        child: Text(g['nama_genre']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGenreId = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: judulC,
                    decoration: const InputDecoration(
                      labelText: 'Judul',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: isiC,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Isi',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: loading ? null : submitForum,
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Simpan'),
                  ),
                ],
              ),
      ),
    );
  }
}

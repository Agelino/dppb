import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/forum_model.dart';
import '../services/api.dart';
import 'add_forum_page.dart';
import 'edit_forum_page.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  late Future<List<ForumModel>> forums;

  // 🔴 GANTI DENGAN TOKEN LOGIN KAMU
  final String token =
      '19|oG7d36MIjRao5GU9lQwSko5pBxLrEZGOrbLxjFija112761b';

  @override
  void initState() {
    super.initState();
    forums = fetchForum();
  }

  // =========================
  // FETCH FORUM
  // =========================
  Future<List<ForumModel>> fetchForum() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/forum'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // 🔥 WAJIB
        },
      );

      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('BODY: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil forum');
      }

      final Map<String, dynamic> json = jsonDecode(response.body);

      return (json['data'] as List)
          .map((e) => ForumModel.fromJson(e))
          .toList();
    } catch (e) {
      debugPrint('ERROR FETCH FORUM: $e');
      rethrow;
    }
  }

  // =========================
  // DELETE FORUM
  // =========================
  Future<void> deleteForum(int id) async {
    await http.delete(
      Uri.parse('$baseUrl/forum/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    setState(() {
      forums = fetchForum();
    });
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forum Diskusi')),

      // ➕ TAMBAH FORUM
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddForumPage()),
          );

          if (result == true) {
            setState(() {
              forums = fetchForum();
            });
          }
        },
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder<List<ForumModel>>(
        future: forums,
        builder: (context, snapshot) {

          // ⏳ LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ ERROR
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // 📭 KOSONG
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada forum'));
          }

          final data = snapshot.data!;

          // 📋 LIST FORUM
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    data[i].judul,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    data[i].isi,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // 🔥 BISA DIPENCET
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EditForumPage(forum: data[i]),
                      ),
                    ).then((_) {
                      setState(() {
                        forums = fetchForum();
                      });
                    });
                  },

                  // ⋮ MENU
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditForumPage(forum: data[i]),
                          ),
                        ).then((_) {
                          setState(() {
                            forums = fetchForum();
                          });
                        });
                      } else if (value == 'delete') {
                        deleteForum(data[i].id);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                          value: 'edit', child: Text('Edit')),
                      PopupMenuItem(
                          value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

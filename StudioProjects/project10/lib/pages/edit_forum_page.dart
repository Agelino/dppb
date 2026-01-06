import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/forum_model.dart';
import '../services/api.dart';

class EditForumPage extends StatefulWidget {
  final ForumModel forum;
  const EditForumPage({super.key, required this.forum});

  @override
  State<EditForumPage> createState() => _EditForumPageState();
}

class _EditForumPageState extends State<EditForumPage> {
  late TextEditingController judulC;
  late TextEditingController isiC;

  final String token = 'PASTE_TOKEN_LOGIN_KAMU';

  @override
  void initState() {
    super.initState();
    judulC = TextEditingController(text: widget.forum.judul);
    isiC = TextEditingController(text: widget.forum.isi);
  }

  Future<void> update() async {
    await http.put(
      Uri.parse('$baseUrl/forum/${widget.forum.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'judul': judulC.text,
        'isi': isiC.text,
      }),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Forum')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: judulC),
            TextField(controller: isiC),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: update, child: const Text('Update')),
          ],
        ),
      ),
    );
  }
}

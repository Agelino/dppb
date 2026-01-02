import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/reading_history_model.dart';
import '../models/global_data.dart';

class ReadingHistoryViewPage extends StatefulWidget {
  const ReadingHistoryViewPage({super.key});

  @override
  State<ReadingHistoryViewPage> createState() =>
      _ReadingHistoryViewPageState();
}

class _ReadingHistoryViewPageState
    extends State<ReadingHistoryViewPage> {
  ReadingHistory? history;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final id =
        ModalRoute.of(context)!.settings.arguments as int;
    fetchDetail(id);
  }

  Future<void> fetchDetail(int id) async {
    final res = await http.get(
      Uri.parse(
          "http://127.0.0.1:8000/api/kelola-riwayat-baca/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      setState(() {
        history = ReadingHistory.fromJson(decoded['data']);
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Riwayat")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User: ${history!.username}"),
                  Text("Buku: ${history!.bookTitle}"),
                  Text("Progress: ${history!.progress}%"),
                  Text("Last Read: ${history!.lastReadAt}"),
                ],
              ),
            ),
    );
  }
}

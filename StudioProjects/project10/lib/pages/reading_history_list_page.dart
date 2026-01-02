import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/reading_history_model.dart';
import '../models/global_data.dart';
import 'reading_history_view_page.dart';
import 'reading_history_edit_page.dart';

class ReadingHistoryListPage extends StatefulWidget {
  const ReadingHistoryListPage({super.key});

  @override
  State<ReadingHistoryListPage> createState() =>
      _ReadingHistoryListPageState();
}

class _ReadingHistoryListPageState extends State<ReadingHistoryListPage> {
  List<ReadingHistory> histories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistories();
  }

  Future<void> fetchHistories() async {
    final res = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/kelola-riwayat-baca"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      setState(() {
        histories = (decoded['data'] as List)
            .map((e) => ReadingHistory.fromJson(e))
            .toList();
        isLoading = false;
      });
    }
  }

  Future<void> deleteHistory(int id) async {
    await http.delete(
      Uri.parse(
          "http://127.0.0.1:8000/api/kelola-riwayat-baca/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );
    fetchHistories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Riwayat Baca")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: histories.length,
              itemBuilder: (context, i) {
                final h = histories[i];
                return Card(
                  child: ListTile(
                    title: Text(h.bookTitle),
                    subtitle:
                        Text("${h.username} • ${h.progress}%"),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'view') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ReadingHistoryViewPage(),
                              settings:
                                  RouteSettings(arguments: h.id),
                            ),
                          );
                        } else if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ReadingHistoryEditPage(),
                              settings:
                                  RouteSettings(arguments: h.id),
                            ),
                          ).then((_) => fetchHistories());
                        } else if (value == 'delete') {
                          deleteHistory(h.id);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                            value: 'view', child: Text("View")),
                        PopupMenuItem(
                            value: 'edit', child: Text("Edit")),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text("Delete",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/global_data.dart';

class ReadingHistoryEditPage extends StatefulWidget {
  const ReadingHistoryEditPage({super.key});

  @override
  State<ReadingHistoryEditPage> createState() =>
      _ReadingHistoryEditPageState();
}

class _ReadingHistoryEditPageState
    extends State<ReadingHistoryEditPage> {
  late int id;
  TextEditingController progressC = TextEditingController();
  TextEditingController lastReadC = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    id = ModalRoute.of(context)!.settings.arguments as int;
  }

  Future<void> updateHistory() async {
    await http.put(
      Uri.parse(
          "http://127.0.0.1:8000/api/kelola-riwayat-baca/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
      body: {
        "progress": progressC.text,
        "last_read_at": lastReadC.text,
      },
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Riwayat Baca")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: progressC,
              decoration:
                  const InputDecoration(labelText: "Progress (%)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: lastReadC,
              decoration:
                  const InputDecoration(labelText: "Last Read"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateHistory,
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}

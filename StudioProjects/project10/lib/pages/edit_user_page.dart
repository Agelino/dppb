import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/global_data.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late int userId;

  TextEditingController usernameC = TextEditingController();
  TextEditingController socialC = TextEditingController();

  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = ModalRoute.of(context)!.settings.arguments as int;
    fetchUser();
  }

  // ================= GET DETAIL =================
  Future<void> fetchUser() async {
    final res = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/users/$userId"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final user = UserModel.fromJson(decoded['data']);

      setState(() {
        usernameC.text = user.username;
        socialC.text = user.socialMedia;
        isLoading = false;
      });
    }
  }

  // ================= UPDATE =================
  Future<void> saveUser() async {
    final res = await http.put(
      Uri.parse("http://127.0.0.1:8000/api/users/$userId"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
      body: {
        "username": usernameC.text,
        "social_media": socialC.text,
      },
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User berhasil diperbarui")),
      );
      Navigator.pop(context, true);
    } else {
      print(res.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal update user")),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit User")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameC,
              decoration: const InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: socialC,
              decoration: const InputDecoration(
                labelText: "Social Media",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveUser,
                child: const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

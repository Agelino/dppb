import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/global_data.dart';

class ViewUserPage extends StatefulWidget {
  const ViewUserPage({super.key});

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  late int userId;
  UserModel? user;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userId = ModalRoute.of(context)!.settings.arguments as int;
    fetchUserDetail();
  }

  // ================= GET DETAIL USER =================
  Future<void> fetchUserDetail() async {
    final res = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/users/$userId"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      setState(() {
        user = UserModel.fromJson(decoded['data']);
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengambil detail user")),
      );
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail User")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[300],
                backgroundImage: user!.fotoProfil.isNotEmpty
                    ? NetworkImage(
                    "http://127.0.0.1:8000/storage/${user!.fotoProfil}")
                    : null,
                child: user!.fotoProfil.isEmpty
                    ? const Icon(Icons.person,
                    size: 80, color: Colors.grey)
                    : null,
              ),

              const SizedBox(height: 30),

              Text(
                user!.username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                user!.socialMedia,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

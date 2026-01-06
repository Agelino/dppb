import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user_list.dart';

class ViewUserPage extends StatefulWidget {
  const ViewUserPage({super.key});

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  late int userId;
  late String authToken;

  UserModel? user;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    userId = args['userId'];
    authToken = args['token'];

    fetchUserDetail();
  }

  Future<void> fetchUserDetail() async {
    try {
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
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail User")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
              ? const Center(child: Text("User tidak ditemukan"))
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: user!.fotoProfil.isNotEmpty
                            ? NetworkImage(
                                "http://127.0.0.1:8000/image/${user!.fotoProfil}",
                              )
                            : null,
                        child: user!.fotoProfil.isEmpty
                            ? const Icon(Icons.person, size: 80)
                            : null,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        user!.username,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        user!.socialMedia,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

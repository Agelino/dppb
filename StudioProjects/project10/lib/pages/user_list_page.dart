import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user_list.dart';
import '../widgets/sidemenu.dart';
import 'edit_user_page.dart';
import 'view_user_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<UserModel> users = [];
  TextEditingController searchC = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // ================= GET USERS =================
  Future<void> fetchUsers() async {
    try {
      final res = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/users"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        setState(() {
          users = (decoded['data'] as List)
              .map((e) => UserModel.fromJson(e))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        showSnack("Gagal mengambil data user (${res.statusCode})");
      }
    } catch (e) {
      setState(() => isLoading = false);
      showSnack("Error: $e");
    }
  }

  // ================= SEARCH =================
  void searchUser() {
    String text = searchC.text.toLowerCase();
    setState(() {
      users = users
          .where((u) => u.username.toLowerCase().contains(text))
          .toList();
    });
  }

  // ================= DELETE USER =================
  Future<void> deleteUser(int id) async {
    final res = await http.delete(
      Uri.parse("http://127.0.0.1:8000/api/users/$id"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      },
    );

    if (res.statusCode == 200) {
      fetchUsers();
      showSnack("User berhasil dihapus");
    } else {
      showSnack("Gagal menghapus user (${res.statusCode})");
    }
  }

  // ================= DIALOG HAPUS =================
  void showDeleteDialog(int userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus User"),
        content: const Text(
          "Apakah kamu yakin ingin menghapus user ini?\nTindakan ini tidak bisa dibatalkan.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteUser(userId); // 🔥 HAPUS BARU DI SINI
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  // ================= SNACKBAR =================
  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar User"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      drawer: const SideMenu(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // SEARCH BAR
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchC,
                          decoration: const InputDecoration(
                            hintText: "Cari username...",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: searchUser,
                        child: const Text("Cari"),
                      ),
                    ],
                  ),
                ),

                // LIST USER
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, i) {
                      final u = users[i];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: ClipOval(
                              child: (u.fotoProfil.isNotEmpty)
                                  ? Image.network(
                                      "http://127.0.0.1:8000/image/${u.fotoProfil}",
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (_, __, ___) =>
                                              const Icon(Icons.person),
                                    )
                                  : const Icon(Icons.person),
                            ),
                          ),
                          title: Text(
                            u.username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(u.socialMedia),
                          trailing: PopupMenuButton(
                            onSelected: (value) {
                              if (value == "lihat") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ViewUserPage(),
                                    settings: RouteSettings(
                                      arguments: {
                                        'userId': u.id,
                                        'token': authToken,
                                      },
                                    ),
                                  ),
                                );
                              } else if (value == "edit") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EditUserPage(),
                                    settings:
                                        RouteSettings(arguments: u.id),
                                  ),
                                ).then((_) => fetchUsers());
                              } else if (value == "hapus") {
                                showDeleteDialog(u.id); // 🔥 DIALOG
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                  value: "lihat", child: Text("Lihat")),
                              PopupMenuItem(
                                  value: "edit", child: Text("Edit")),
                              PopupMenuItem(
                                value: "hapus",
                                child: Text(
                                  "Hapus",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

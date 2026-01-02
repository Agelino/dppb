// lib/pages/user_list_page.dart

import 'package:flutter/material.dart';
import '../models/global_data.dart';
import '../widgets/sidemenu.dart';
import 'edit_user_page.dart'; // Import Halaman Edit
import 'view_user_page.dart'; // Import Halaman View (BARU)

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<UserModel> users = [];
  TextEditingController searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    users = dummyUsers;
  }

  void searchUser() {
    String text = searchC.text.toLowerCase();
    setState(() {
      users = dummyUsers
          .where((u) => u.username.toLowerCase().contains(text))
          .toList();
    });
  }

  void deleteUser(int id) {
    setState(() {
      dummyUsers.removeWhere((u) => u.id == id);
      users = List.from(dummyUsers);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User dihapus")),
    );
  }

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
      body: Column(
        children: [
          // Search Bar
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
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
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

          // List User
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, i) {
                final u = users[i];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                    // Foto Profil Asset
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: u.fotoProfil.isNotEmpty
                          ? AssetImage(u.fotoProfil) as ImageProvider
                          : null,
                      child: u.fotoProfil.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                      backgroundColor: Colors.grey[300],
                    ),

                    title: Text(u.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(u.socialMedia),

                    // Menu Pilihan (Lihat, Edit, Hapus)
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "hapus") {
                          deleteUser(u.id);
                        }
                        else if (value == "edit") {
                          // Ke Halaman Edit
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditUserPage(),
                              settings: RouteSettings(arguments: u.id),
                            ),
                          ).then((_) {
                            setState(() => users = dummyUsers); // Refresh data
                          });
                        }
                        else if (value == "lihat") {
                          // <--- KE HALAMAN VIEW (BARU)
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ViewUserPage(),
                              settings: RouteSettings(arguments: u.id), // Kirim ID
                            ),
                          );
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: "lihat", child: Text("Lihat")),
                        PopupMenuItem(value: "edit", child: Text("Edit")),
                        PopupMenuItem(value: "hapus", child: Text("Hapus", style: TextStyle(color: Colors.red))),
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
import 'package:flutter/material.dart';
import '../models/global_data.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late int userId;
  late UserModel user;

  TextEditingController usernameC = TextEditingController();
  TextEditingController socialC = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


    userId = ModalRoute.of(context)!.settings.arguments as int;

    user = dummyUsers.firstWhere((u) => u.id == userId);

    usernameC.text = user.username;
    socialC.text = user.socialMedia;
  }

  void saveUser() {
    user.username = usernameC.text;
    user.socialMedia = socialC.text;

    Navigator.pop(context); // Kembali ke list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit User")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Username",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: usernameC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Social Media",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: socialC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveUser,
                child: const Text("Simpan Perubahan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:project10/pages/dashboard.dart';
import 'package:project10/pages/dashboard_user.dart';

import '../models/global_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  bool isLoading = false;

  // ================= LOGIN FUNCTION =================
  Future<void> login() async {
    if (emailC.text.isEmpty || passwordC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan password wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/login"),
        headers: {
          "Accept": "application/json",
        },
        body: {
          "email": emailC.text,
          "password": passwordC.text,
        },
      );

      final decoded = jsonDecode(res.body);

      if (res.statusCode == 200 && decoded['success'] == true) {
        // ================= SIMPAN TOKEN =================
        authToken = decoded['data']['token'];

        // ================= SIMPAN USER LOGIN (INI WAJIB) =================
        currentUser = UserModel.fromJson(decoded['data']['user']);

        // ================= SIMPAN ROLE =================
        userRole = decoded['data']['user']['role'];

        debugPrint("LOGIN BERHASIL");
        debugPrint("USER ID   : ${currentUser!.id}");
        debugPrint("USERNAME  : ${currentUser!.username}");
        debugPrint("ROLE      : $userRole");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login berhasil")),
        );

        // ================= REDIRECT =================
        if (userRole == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DashboardUserPage()),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(decoded['message'] ?? "Login gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Email",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Password",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: passwordC,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

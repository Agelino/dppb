import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/user_list.dart';
import 'dashboard.dart';
import 'dashboard_user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  bool isLoading = false;

  // ================= LOGIN =================
  Future<void> login() async {
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
      print("LOGIN RESPONSE => $decoded");

      if (res.statusCode == 200 && decoded['success'] == true) {

        // 🔥 AMBIL TOKEN (AMAN UNTUK SEMUA FORMAT)
        authToken =
            decoded['token'] ??
            decoded['data']?['token'] ??
            decoded['data']?['access_token'] ??
            decoded['data']?['token']?['plainTextToken'] ??
            '';

        userRole =
            decoded['user']?['role'] ??
            decoded['data']?['user']?['role'] ??
            '';

        print("TOKEN FINAL => $authToken");
        print("ROLE FINAL => $userRole");

        if (authToken.isEmpty) {
          throw Exception("TOKEN KOSONG DARI API LOGIN");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login berhasil")),
        );

        // ===== REDIRECT =====
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
            const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: passwordC,
              obscureText: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/pages/view_user_page.dart

import 'package:flutter/material.dart';
import '../models/global_data.dart';

class ViewUserPage extends StatelessWidget {
  const ViewUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Ambil ID user dari arguments yang dikirim halaman List
    final int userId = ModalRoute.of(context)!.settings.arguments as int;

    // 2. Cari data user di database dummy berdasarkan ID
    final UserModel user = dummyUsers.firstWhere((u) => u.id == userId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail User"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // --- TAMPILKAN FOTO DARI ASSET ---
              CircleAvatar(
                radius: 80, // Ukuran lebih besar untuk detail
                backgroundColor: Colors.grey[300],
                backgroundImage: user.fotoProfil.isNotEmpty
                    ? AssetImage(user.fotoProfil) as ImageProvider
                    : null,
                child: user.fotoProfil.isEmpty
                    ? const Icon(Icons.person, size: 80, color: Colors.grey)
                    : null,
              ),

              const SizedBox(height: 30),

              // --- DATA USERNAME ---
              Text(
                user.username,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // --- DATA SOCIAL MEDIA ---
              Text(
                user.socialMedia,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blueGrey,
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text("Kembali"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
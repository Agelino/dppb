import 'package:flutter/material.dart';

class FullBacaanPage2 extends StatefulWidget {
  @override
  State<FullBacaanPage2> createState() => _FullBacaanPage2State();
}

class _FullBacaanPage2State extends State<FullBacaanPage2> {
  double fontSize = 15;
  final TextEditingController commentController = TextEditingController();

  List<Map<String, String>> comments = [];

  void changeFont(double delta) {
    setState(() {
      if (delta == 0) {
        fontSize = 15;
      } else {
        fontSize = (fontSize + delta).clamp(13, 22);
      }
    });
  }

  void addComment() {
    if (commentController.text.trim().isEmpty) return;

    setState(() {
      comments.insert(0, {
        "nama": "kamu",
        "komentar": commentController.text.trim(),
        "waktu": "now",
      });
    });

    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffEFEFF0),
      body: SafeArea(
        child: Column(
          children: [
            // ---------------- HEADER ----------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              color: const Color(0xff6F98D9),
              child: Row(
                children: [
                  // TOMBOL KEMBALI
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: "Cari buku di sini..",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    "Safae",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),

            // ---------------- KONTEN ----------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      "Laut Bercerita",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff27496D),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Chapter 1 (Lanjutan)",
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // FONT CONTROL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(child: const Text("A -"), onPressed: () => changeFont(-1)),
                        const SizedBox(width: 8),
                        OutlinedButton(child: const Text("A"), onPressed: () => changeFont(0)),
                        const SizedBox(width: 8),
                        OutlinedButton(child: const Text("A +"), onPressed: () => changeFont(1)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // TEXT BOX
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)
                        ],
                      ),
                      child: Text(
                        "Saat pesawat memasuki wilayah tropis, awan tipis bergelantung di kejauhan. "
                        "Laut memantulkan cahaya matahari seperti kaca besar yang memanjang tanpa ujung.\n\n"
                        "Aku menarik napas panjang. Masih banyak hal yang belum benar-benar selesai. "
                        "Pertanyaan-pertanyaanku menggantung, seolah menunggu untuk dijawab.\n\n"
                        "Ada masa lalu yang belum sempat kupahami. Namun perjalanan ini harus tetap kulalui.\n"
                        "Barangkali, di sebuah sudut waktu, jawaban itu akan kutemukan.",
                        style: TextStyle(fontSize: fontSize, height: 1.7),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // KOMENTAR INPUT
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: commentController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Write a comment...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: addComment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff6F98D9),
                          ),
                          child: const Text("Kirim"),
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    // LIST KOMENTAR
                    Column(
                      children: comments.map((c) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.blue.shade200,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(c["nama"]!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(c["komentar"]!),
                                    const SizedBox(height: 4),
                                    Text(
                                      c["waktu"]!,
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

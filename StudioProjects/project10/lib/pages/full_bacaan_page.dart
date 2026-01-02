import 'package:flutter/material.dart';
import 'full_bacaan_page_2.dart'; // tambahkan halaman berikutnya

class FullBacaanPage extends StatefulWidget {
  const FullBacaanPage({super.key});

  @override
  State<FullBacaanPage> createState() => _FullBacaanPageState();
}

class _FullBacaanPageState extends State<FullBacaanPage> {
  double fontSize = 15;
  final TextEditingController commentController = TextEditingController();

  List<Map<String, String>> comments = [
    {
      "nama": "sharonne_wonmally",
      "komentar": "buku nya sangat menginspirasi",
      "waktu": "3 days ago"
    },
    {
      "nama": "adzraaditama",
      "komentar": "akuu suka cerita ini",
      "waktu": "3 days ago"
    },
  ];

  void changeFont(double value) {
    setState(() {
      if (value == 0) {
        fontSize = 15;
      } else {
        fontSize = (fontSize + value).clamp(13, 22);
      }
    });
  }

  void addComment() {
    if (commentController.text.trim().isEmpty) return;

    setState(() {
      comments.insert(0, {
        "nama": "kamu",
        "komentar": commentController.text,
        "waktu": "now"
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
                  const Icon(Icons.menu, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Laut Bercerita",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff27496D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Chapter 1",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // ---------------- FONT CONTROLS ----------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () => changeFont(-1),
                          child: const Text("A -"),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => changeFont(0),
                          child: const Text("A"),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: () => changeFont(1),
                          child: const Text("A +"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ---------------- READING BOX ----------------
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Text(
                        "Pesawat berbadan besar yang kutumpangi melaju cepat meninggalkan London. "
                        "Penerbangan ini nonstop menuju Singapura. Gadis dengan rambut dikucir dan "
                        "seperangkat touchscreen ditangan, berisi coret-coret daftar pertanyaan...",
                        style: TextStyle(fontSize: fontSize, height: 1.7),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---------------- NEXT BUTTON ----------------
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FullBacaanPage2(),
                            ),
                          );
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: const Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(height: 1, color: Colors.grey[300]),
                    const SizedBox(height: 20),

                    // ---------------- COMMENT INPUT ----------------
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
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
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

                    // ---------------- COMMENT LIST ----------------
                    Column(
                      children: comments.map((c) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.blue[200],
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      c["nama"]!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(c["komentar"]!),
                                    const SizedBox(height: 4),
                                    Text(
                                      c["waktu"]!,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    )
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

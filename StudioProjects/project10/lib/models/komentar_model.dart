class Komentar {
  final int id;
  final int userId;
  final int bookId;
  final String username;
  final String komentar;
  final String createdAt;

  Komentar({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.username,
    required this.komentar,
    required this.createdAt,
  });

  factory Komentar.fromJson(Map<String, dynamic> json) {
    return Komentar(
      id: json['id'],
      userId: json['user_id'],
      bookId: json['book_id'],
      username: json['username'],
      komentar: json['komentar'],
      createdAt: json['created_at'],
    );
  }
}

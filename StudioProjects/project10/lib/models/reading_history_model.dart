class ReadingHistory {
  final int id;
  final String username;
  final String bookTitle;
  final int progress;
  final String lastReadAt;

  ReadingHistory({
    required this.id,
    required this.username,
    required this.bookTitle,
    required this.progress,
    required this.lastReadAt,
  });

  factory ReadingHistory.fromJson(Map<String, dynamic> json) {
    return ReadingHistory(
      id: json['id'],
      username: json['user']['username'],
      bookTitle: json['book']['judul'],
      progress: json['progress'],
      lastReadAt: json['last_read_at'],
    );
  }
}

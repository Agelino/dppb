class ForumModel {
  final int id;
  final int genreId;
  final int userId;
  final String judul;
  final String isi;

  ForumModel({
    required this.id,
    required this.genreId,
    required this.userId,
    required this.judul,
    required this.isi,
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    return ForumModel(
      id: json['id'],
      genreId: json['genre_id'],
      userId: json['user_id'],
      judul: json['judul'],
      isi: json['isi'],
    );
  }
}

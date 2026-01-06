class CommentModel {
  final int id;
  final String isi;
  final String user;
  final int likes;
  final List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.isi,
    required this.user,
    required this.likes,
    required this.replies,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      isi: json['isi'] ?? '',
      user: json['user']?['username'] ?? 'Anonim',
      likes: json['likes'] ?? 0,
      replies: json['replies'] != null
          ? (json['replies'] as List)
              .map((e) => CommentModel.fromJson(e))
              .toList()
          : [],
    );
  }
}

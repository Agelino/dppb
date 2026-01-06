class Book {
  final int id;
  final String title;
  final String author;
  final String genre;
  final int year;
  final String description;
  final String content;
  final String image;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    required this.year,
    required this.description,
    required this.content,
    required this.image,
  });

String? get imagePath => image;

  factory Book.fromJson(Map<String, dynamic> json) {
  return Book(
    id: json['id'],
    title: json['title'],
    author: json['author'],
    genre: json['genre'],
    year: json['year'],
    description: json['description'] ?? '',
    content: json['content'] ?? '',
    image: json['image_path'] ?? '', 
  );
}
}



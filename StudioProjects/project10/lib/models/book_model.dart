class Book {
  String id;
  String title;
  String author;
  String year;
  String genre;
  String content;
  String? imagePath;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.genre,
    required this.content,
    this.imagePath,
  });
}


List<Book> dummyBooks = [
  Book(
    id: '1',
    title: 'Ayam Jago',
    author: 'Agelino',
    year: '2021',
    genre: 'Hobi',
    content: 'Panduan merawat ayam...',
    imagePath: 'asset/sharone.jpeg',
  ),
  Book(
    id: '2',
    title: 'Resep Nusantara',
    author: 'Chef Juna',
    year: '2022',
    genre: 'Masakan',
    content: 'Kumpulan resep terbaik...',
    imagePath: 'asset/adzra.jpeg',
  ),
  Book(
    id: '3',
    title: 'Sejarah Romawi',
    author: 'Mrs. Roma',
    year: '1973',
    genre: 'Sejarah',
    content: 'Sejarah kerajaan romawi...',
    imagePath: 'asset/adzra.jpeg',
  ),
];
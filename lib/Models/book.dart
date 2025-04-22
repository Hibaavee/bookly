class Book {
  final String title;
  final String author;
  final int? coverId;
  final int? publishYear;

  Book({
    required this.title,
    required this.author,
    this.coverId,
    this.publishYear,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'No Title',
      author: (json['author_name'] as List?)?.first ?? 'Unknown Author',
      coverId: json['cover_i'],
      publishYear: json['first_publish_year'],
    );
  }

  String get coverImageUrl => coverId != null
      ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
      : 'https://via.placeholder.com/150';
}

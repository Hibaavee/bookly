import 'package:bookly/Service/webservice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';


final searchQueryProvider = StateProvider<String>((ref) => "flutter");

final bookListProvider = FutureProvider<List<Book>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  return await BookService.fetchBooks(query);
});

final filteredBooksProvider = Provider<List<Book>>((ref) {
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final booksAsync = ref.watch(bookListProvider);

  return booksAsync.maybeWhen(
    data: (books) => books
        .where((book) =>
            book.title.toLowerCase().startsWith(query)) // 👈 Fine-tune match
        .toList(),
    orElse: () => [],
  );
});

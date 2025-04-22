import 'package:bookly/Service/webservice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';


final searchQueryProvider = StateProvider<String>((ref) => "flutter");

final bookListProvider = FutureProvider<List<Book>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  return await BookService.fetchBooks(query);
});

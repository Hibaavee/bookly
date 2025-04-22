import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  static Future<List<Book>> fetchBooks(String query) async {
    final url = Uri.parse('https://openlibrary.org/search.json?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final List docs = jsonBody['docs'];

      return docs.map((doc) => Book.fromJson(doc)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}



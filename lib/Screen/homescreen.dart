import 'package:bookly/Provider/book_provider.dart';
import 'package:bookly/Screen/detailsscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(bookListProvider);
    final filtererdbooks = ref.watch(filteredBooksProvider);
    final query = ref.watch(searchQueryProvider);

    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2; 
    
    if (screenWidth > 600 && screenWidth <= 900) {
      crossAxisCount = 3; 
    } else if (screenWidth > 900) {
      crossAxisCount = 4; 
    }

    return WillPopScope(
    onWillPop: () async {
      if (query.isNotEmpty) {
        ref.read(searchQueryProvider.notifier).state = ""; 
        return false; 
      }
      return true; 
    },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Bookly'),
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                // Search bar with rounded corners and padding
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search books...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    onChanged: (text) {
                      ref.read(searchQueryProvider.notifier).state = text;
                    },
                  ),
                ),
                const SizedBox(height: 16),
      
                // Book list as a GridView inside a scrollable column
                booksAsync.when(
                  data: (books) => books.isEmpty
                      ? const Center(child: Text("No books found."))
                      : GridView.builder(
                          shrinkWrap: true, 
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.6, 
                          ),
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book = books[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookDetailScreen(book: book),
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: book.coverImageUrl,
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: double.infinity,
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.book),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        book.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        book.author,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text("Error: $err")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

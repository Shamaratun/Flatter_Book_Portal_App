import 'package:flutter/material.dart';
import '../model/book.dart';
import '../services/book_service.dart';
import 'book_details_screen.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  final BookService _bookService = BookService();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    final books = await _bookService.getAllBooks();
    setState(() {
      _allBooks = books;
      _filteredBooks = books;
    });
  }

  void _performSearch() {
    String authorQuery = _authorController.text.toLowerCase().trim();
    String categoryQuery = _categoryController.text.toLowerCase().trim();

    setState(() {
      _filteredBooks = _allBooks.where((book) {
        final matchesAuthor = authorQuery.isEmpty ||
            book.authorNames.any((author) =>
                author.toLowerCase().contains(authorQuery));
        final matchesCategory = categoryQuery.isEmpty ||
            book.bookCategory.toLowerCase().contains(categoryQuery);
        return matchesAuthor && matchesCategory;
      }).toList();
    });
  }

  @override
  void dispose() {
    _authorController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Online Book Management')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search Fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _authorController,
                    decoration: InputDecoration(
                      hintText: 'Search by author name',
                      prefixIcon: const Icon(Icons.person_search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(
                      hintText: 'Search by category',
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.search, size: 30),
                  onPressed: _performSearch,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Book Grid
            Expanded(
              child: _filteredBooks.isEmpty
                  ? const Center(child: Text('No books found'))
                  : GridView.builder(
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.65,
                ),
                itemCount: _filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = _filteredBooks[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        // Book Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                          child: book.bookImageUrl != null
                              ? Image.network(
                            "http://10.0.2.2:8082/api/auth/image/${book.bookImageUrl}",
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                              : const Icon(Icons.book, size: 100),
                        ),

                        // Book Info
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.bookName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Author: ${book.authorNames.join(', ')}",
                                style: const TextStyle(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Category: ${book.bookCategory}",
                                style: const TextStyle(fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "Rating: ${book.bookRating}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "৳${book.bookPrice.toStringAsFixed(2)}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        // Action Buttons
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add_shopping_cart),
                                onPressed: () async {
                                  try {
                                    await _bookService.addToCart(book);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content:
                                          Text('Added to cart')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                          content:
                                          Text('Error: $e')),
                                    );
                                  }
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.info_outline,
                                    color: Colors.redAccent),
                                // icon: const Icon(Icons.info_outline),
                                // label: const Text('View Details'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookDetailsScreen(book: book),
                                    ),
                                  );
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.favorite,
                                    color: Colors.redAccent),
                                onPressed: () async {
                                  try {
                                    await _bookService
                                        .addToFavourites(book);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Added to favourite')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                          content:
                                          Text('Error: $e')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

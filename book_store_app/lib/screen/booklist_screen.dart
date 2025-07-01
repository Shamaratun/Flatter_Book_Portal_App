import 'package:flutter/material.dart';

import '../model/book.dart';
import '../services/book_service.dart';

class BookListScreen extends StatefulWidget {
  const BookListScreen({super.key});

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  // final ApiService _apiService =ApiService();
  final BookService _bookService = BookService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(' Online book Management')),
      body: FutureBuilder<List<Book>>(
        future: _bookService.getAllBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No book found'));
          }
          final books = snapshot.data!;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return ListTile(
                leading: book.bookImageUrl != null
                    // ? Image.network(
                    //     book.bookImageUrl!,
                    //     width: 50,
                    //     height: 50,
                    //     fit: BoxFit.cover,
                    //   ) alternative line of 43-53
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.network(
                            "http://10.0.2.2:8082/api/auth/image/${book.bookImageUrl}",
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const Icon(Icons.person),
                title: Text(book.bookName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(book.authorNames.toString()),
                    Text(book.bookCategory),
                    Text(book.bookIsbnNumber.toString()),
                    Text(book.bookRating.toString()),
                    Text('৳${book.bookPrice.toStringAsFixed(2)}'),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.add_shopping_cart_sharp),
                  onPressed: () async {
                    try {
                      await _bookService.addToCart(book.id!);
                      setState(() {});
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                ),
                // return FutureBuilder<List<Book>>(
                //   future: _bookService.getAllBooks(),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(child: CircularProgressIndicator());
                //     }
                //     if (snapshot.hasError) {
                //       return Center(child: Text('Error ${snapshot.error}'));
                //     }
                //     if (!snapshot.hasData || snapshot.data!.isEmpty) {
                //       return const Center(child: Text('No book found'));
                //     }
                //     final books = snapshot.data!;
                //     return ListView.builder(
                //       itemCount: books.length,
                //       itemBuilder: (context, index) {
                //         final book = books[index];
                //         return ListTile(
                //           title: Text(book.id.toString() + book.bookName),
                //           subtitle: Text(book.bookPrice.toString()),
              );
            },
          );
        },
      ),
    );
  }
}

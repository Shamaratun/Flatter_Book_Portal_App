import 'package:flutter/material.dart';
import '../model/book.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.bookName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: book.bookImageUrl != null
                    ? Image.network(
                  "http://10.0.2.2:8082/api/auth/image/${book.bookImageUrl}",
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 100),
                )
                    : const Icon(Icons.book, size: 100),
              ),
            ),
            const SizedBox(height: 20),

            // Book Details
            Text("Authors: ${book.authorNames.join(', ')}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Category: ${book.bookCategory}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("ISBN: ${book.bookIsbnNumber}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Price: ৳${book.bookPrice.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text("Rating: ${book.bookRating} / 5", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text("Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(
              book.bookDescription.isNotEmpty ? book.bookDescription : 'No description available.',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

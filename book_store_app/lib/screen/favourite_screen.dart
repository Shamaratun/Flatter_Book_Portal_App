import 'package:flutter/material.dart';
import '../model/book.dart';
import '../services/favourite_service.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final FavouriteService _favouriteService = FavouriteService();
  List<Book> _favourites = [];

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final favs = await _favouriteService.getFavourites();
    setState(() {
      _favourites = favs;
    });
  }

  Future<void> _removeFromFavourites(int bookId) async {
    await _favouriteService.removeFavourite(bookId);
    _loadFavourites();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from favourites')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourite Books')),
      body: _favourites.isEmpty
          ? const Center(child: Text('No favourite books yet'))
          : ListView.builder(
        itemCount: _favourites.length,
        itemBuilder: (context, index) {
          final book = _favourites[index];

          // ✅ Safely check if book.id is null
          final bookId = book.id;
          if (bookId == null) return const SizedBox();

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: ListTile(
              leading: book.bookImageUrl != null
                  ? Image.network(
                "http://10.0.2.2:8082/api/auth/image/${book.bookImageUrl}",
                width: 50,
                fit: BoxFit.cover,
              )
                  : const Icon(Icons.book, size: 50),
              title: Text(book.bookName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Author: ${book.authorNames.join(', ')}"),
                  Text("Category: ${book.bookCategory}"),
                  Text("৳${book.bookPrice.toStringAsFixed(2)}"),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () => _removeFromFavourites(bookId),
              ),
            ),
          );
        },
      ),
    );
  }
}

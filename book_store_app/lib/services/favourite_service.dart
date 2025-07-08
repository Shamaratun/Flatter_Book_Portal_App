import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/book.dart';

class FavouriteService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _favKey = 'favourite_items';

  Future<void> addToFavourites(Book book) async {
    try {
      final favJson = await _secureStorage.read(key: _favKey);
      List<Book> favourites = [];

      if (favJson != null) {
        final List<dynamic> decoded = jsonDecode(favJson);
        for (var item in decoded) {
          try {
            favourites.add(Book.fromJson(item));
          } catch (_) {}
        }
      }

      // Avoid duplicates
      bool alreadyExists = favourites.any((b) => b.id == book.id);
      if (!alreadyExists) {
        favourites.add(book);
      }

      await _secureStorage.write(
        key: _favKey,
        value: jsonEncode(favourites.map((b) => b.toJson()).toList()),
      );
    } catch (e) {
      print("Error adding to favourites: $e");
      rethrow;
    }
  }

  Future<List<Book>> getFavourites() async {
    final favJson = await _secureStorage.read(key: _favKey);
    if (favJson != null) {
      try {
        final List<dynamic> data = jsonDecode(favJson);
        return data.map((item) => Book.fromJson(item)).toList();
      } catch (_) {}
    }
    return [];
  }

  Future<void> removeFavourite(int bookId) async {
    final favJson = await _secureStorage.read(key: _favKey);
    if (favJson == null) return;

    final List<dynamic> data = jsonDecode(favJson);
    List<Book> favourites = [];

    for (var item in data) {
      try {
        favourites.add(Book.fromJson(item));
      } catch (_) {}
    }

    favourites.removeWhere((b) => b.id == bookId);

    await _secureStorage.write(
      key: _favKey,
      value: jsonEncode(favourites.map((b) => b.toJson()).toList()),
    );
  }

  Future<void> clearFavourites() async {
    await _secureStorage.delete(key: _favKey);
  }

  Future<bool> isFavourite(int bookId) async {
    final favs = await getFavourites();
    return favs.any((b) => b.id == bookId);
  }
}

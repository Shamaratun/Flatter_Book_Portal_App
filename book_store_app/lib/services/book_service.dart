import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../model/author.dart';
import '../model/book.dart';
import '../model/cart_item.dart';

final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

class BookService {
  // static const String baseUrl = 'http://192.168.100.21:8082';
  static const String baseUrl = 'http://10.0.2.2:8082';

  Future<List<Author>> getAllAuthors() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/get/all/authors'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Author.fromJson(json)).toList();
    } else {
      throw Exception("failed to load Authors");
    }
  }

  Future<List<Book>> getAllBooks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/user/get/all/books'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      var list = data.map((json) => Book.fromJson(json)).toList();
      return list;
    } else {
      throw Exception("failed to load Books");
    }
  }

  Future<Book> getAllBookById() async {
    final response = await http.get(Uri.parse('$baseUrl/book'));
    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to load Book");
    }
  }

  Future<Book> saveBook(Book book) async {
    final response = await http.post(
      Uri.parse('$baseUrl/book'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(book.toJson()),
    );
    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to save book");
    }
  }

  Future<Book> updateBook(int id, Book book) async {
    final response = await http.put(
      Uri.parse('$baseUrl/book/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(book.toJson()),
    );
    if (response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("failed to update book");
    }
  }

  Future<void> deleteBook(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/book/$id'));
    if (response.statusCode != 200) {
      throw Exception("failed to delete book");
    }
  }

  Future<void> addToCart(Book book) async {
    try {
      final cartJson = await _secureStorage.read(key: 'cart_items');
      List<CartItem> cart = [];

      if (cartJson != null) {
        final List<dynamic> decoded = jsonDecode(cartJson);

        // ✅ Try to parse safely, skip corrupted items
        for (var item in decoded) {
          try {
            cart.add(CartItem.fromJson(item));
          } catch (e) {
          }
        }
      }

      // Check if item already exists
      int index = cart.indexWhere((item) => item.book.id == book.id);
      if (index != -1) {
        cart[index].quantity += 1;
      } else {
        cart.add(CartItem(book: book));
      }

      await _secureStorage.write(
        key: 'cart_items',
        value: jsonEncode(cart.map((item) => item.toJson()).toList()),
      );
    } catch (e) {
      print(e);
      rethrow; // or show a user-friendly message
    }
  }


  Future<List<CartItem>> getLocalCart() async {
    final cartJson = await _secureStorage.read(key: 'cart_items');
    if (cartJson != null) {
      List<dynamic> data = jsonDecode(cartJson);
      return data.map((item) => CartItem.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> saveCart(List<CartItem> cart) async {
    await _secureStorage.write(
      key: 'cart_items',
      value: jsonEncode(cart.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> clearLocalCart() async {
    await _secureStorage.delete(key: 'cart_items');
  }

  Future<void> removeItem(int index) async {
    final jsonString = await _secureStorage.read(key: 'cart_items');
    if (jsonString == null) return;

    List<dynamic> cartList = jsonDecode(jsonString);

    if (index < 0 || index >= cartList.length) return;

    cartList.removeAt(index); // Remove item at the given index

    // Save updated cart list
    await _secureStorage.write(
      key: 'cart_items',
      value: jsonEncode(cartList),
    );
  }
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

  Future<void> removeFavourite(String bookId) async {
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

  Future<bool> isFavourite(String bookId) async {
    final favs = await getFavourites();
    return favs.any((b) => b.id == bookId);
  }

}

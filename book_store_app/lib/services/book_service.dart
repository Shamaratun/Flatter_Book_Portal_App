import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/author.dart';
import '../model/book.dart';

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
  Future<void> addToCart(int id) async {
    final response = await http.post(Uri.parse('$baseUrl/book/$id'));
    if (response.statusCode != 200) {
      throw Exception("failed to add in cart ");
    }
  }



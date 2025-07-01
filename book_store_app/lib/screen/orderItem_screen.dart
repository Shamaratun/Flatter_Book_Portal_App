// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class OrderitemScreen extends StatefulWidget {
//   const OrderitemScreen({super.key});
//
//   @override
//   State<OrderitemScreen> createState() => _OrderitemScreenState();
// }
//
// class _OrderitemScreenState extends State<OrderitemScreen> {
// }
//
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//       appBar: AppBar(title: const Text(' OrderList Management')),
//       body: FutureBuilder<List<Orderitem>>(
//       future: _orderItemService.getAllBooks(),
//   builder: (context, snapshot) {
//   if (snapshot.connectionState == ConnectionState.waiting) {
//   return const Center(child: CircularProgressIndicator());
//   }
//   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//   return const Center(child: Text('No order found'));
//   }
//   final orderItems = snapshot.data!;
//   return ListView.builder(
//   itemCount: orderItems.length,
//   itemBuilder: (context, index) {
//   final book = orderItems[index];
//   return ListTile(
//   leading: book.bookImageUrl != null
//   // ? Image.network(
//   //     book.bookImageUrl!,
//   //     width: 50,
//   //     height: 50,
//   //     fit: BoxFit.cover,
//   //   ) alternative line of 43-53
//   ? ClipRRect(
//   borderRadius: BorderRadius.circular(8.0),
//   child: SizedBox(
//   width: 50,
//   height: 50,
//   child: Image.network(
//   "http://10.0.2.2:8082/api/auth/image/${book.bookImageUrl}",
//   fit: BoxFit.cover,
//   ),
//   ),
//   )
//       : const Icon(Icons.person),
//   title: Text(book.bookName),
//   subtitle: Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//   Text(book.authorName),
//   Text(book.bookCategory),
//   Text(book.bookIsbnNumber.toString()),
//   Text(book.bookRating.toString()),
//   Text('৳${book.bookPrice.toStringAsFixed(2)}'),
//   ],
//   ),
//   trailing: IconButton(
//   icon: const Icon(Icons.add_card_sharp),
//   onPressed: () async {
//   try {
//   await _orderItemService.deleteBook(book.id!);
//   setState(() {});
//   } catch (e) {
//   ScaffoldMessenger.of(
//   context,
//   ).showSnackBar(SnackBar(content: Text('Error: $e')));
//   }
//   },
//   ),
//   }
//   }

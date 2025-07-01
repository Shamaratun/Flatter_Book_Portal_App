package com.meme.onlinebookportal.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import com.meme.onlinebookportal.dto.*;
import com.meme.onlinebookportal.model.*;
import com.meme.onlinebookportal.service.*;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

@RestController
@RequestMapping(value = "/api/admin")
public class AdminController {
private BookService service;
private  final  FileStorageService storageService;
    private final BookService bookService;
    private final AuthorService authorService;
    private final OrderService orderService;
    private final UserService userService;

    public AdminController(BookService bookService, AuthorService authorService, OrderService orderService,
                           UserService userService,FileStorageService storageService) {
        this.bookService = bookService;
        this.authorService = authorService;
        this.orderService = orderService;
        this.userService = userService;
        this.storageService= storageService;
    }


    @PostMapping(value = "/add/book", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> addNewBook(
            @RequestPart("book") @Valid AddBookDto addBookDto,
            @RequestPart("image") MultipartFile imageFile) {

        Book book = bookService.addNewBook(addBookDto, imageFile);
        return new ResponseEntity<>(book, HttpStatus.CREATED);
    }

//    @PostMapping("/{bookId}/upload")
//    public ResponseEntity<?> uploadFile(@RequestBody UpdateBookDto , @RequestParam("file") MultipartFile file) {
//
//        try {
//            String saveFileName = storageService.storeFile(file);
//            String accessUrl = ServletUriComponentsBuilder.fromCurrentContextPath().path("/imageurl/")
//                    .path(saveFileName).toUriString();
//
//            Book bookById = service.getBookById(UpdateBookDto);
//            bookById.setBookImageUrl(accessUrl);
//
//            service.updateBook(UpdateBookDto, file);
//
//            return ResponseEntity.ok(Map.of("message", "File uploaded", "url", accessUrl));
//        } catch (Exception e) {
//
//            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("error", e.getMessage()));
//        }
//
//    }
    @GetMapping("/get/all/books")
    public ResponseEntity<?> getAllBooks() {
        List<BookResponseDto> books = bookService.getAllBooksByAdmin();
        return new ResponseEntity<>(books, HttpStatus.OK);
    }

    @PutMapping(value = "/update/book", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<?> updateBook(@RequestPart("book") @Valid UpdateBookDto updateBookDto,
                                        @RequestPart(value = "image", required = false) MultipartFile image
    ) throws IOException {
        Book book = bookService.updateBook(updateBookDto, image);
        return new ResponseEntity<>(book, HttpStatus.OK);
    }

    @DeleteMapping("/delete/book")
    public ResponseEntity<Void> deleteBook(@RequestParam Long id) {
        bookService.deleteBookById(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    // author
    @PostMapping("/add/author")
    public ResponseEntity<?> addNewAuthor(@RequestBody AddAuthorDto addAuthorDto) {
        Author author = authorService.addNewAuthor(addAuthorDto);
        return new ResponseEntity<>(author, HttpStatus.CREATED);
    }

    @GetMapping("/get/all/authors")
    public ResponseEntity<?> getAllAuthors() {
        List<AuthorResponseDto> author = authorService.getAllAuthorsByAdmin();
        return new ResponseEntity<>(author, HttpStatus.OK);
    }


    @PutMapping("/update/author")
    public ResponseEntity<?> editAuthor(@RequestBody UpdateAuthorDto updateAuthorDto) {
        Author author = authorService.updateAuthor(updateAuthorDto);
        return new ResponseEntity<>(author, HttpStatus.OK);
    }

    @DeleteMapping("/delete/author")
    public ResponseEntity<Void> deleteAuthor(@RequestParam Long id) {
        authorService.deleteAuthor(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/get/all/order")
    public ResponseEntity<?> getAllOrders() {
        List<OrderResponseDto> orders = orderService.getAllOrders();
        return new ResponseEntity<>(orders, HttpStatus.OK);
    }

    @DeleteMapping("/delete/order")
    public ResponseEntity<Void> deleteOrderById(@RequestParam Long id) {
        orderService.deleteOrderById(id);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("/get/all/users")
    public ResponseEntity<?> getAllUsers() {
        List<User> users = userService.getAllUsers();
        return new ResponseEntity<>(users, HttpStatus.OK);
    }

    @GetMapping("/get/profile/info")
    public ResponseEntity<?> getMyProfileInfo(@RequestParam Long id) {
        User user = userService.getMyProfile(id);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @PutMapping("/order/delivered")
    public ResponseEntity<?> orderDelivered(@RequestParam Long orderId) {
        Order order = orderService.orderDelivered(orderId);
        return new ResponseEntity<>( HttpStatus.OK);
    }

    @PutMapping("/order/completed")
    public ResponseEntity<?> orderCompleted(@RequestParam Long orderId) {
        Order order = orderService.orderCompleted(orderId);
        return new ResponseEntity<>( HttpStatus.OK);
    }


    @PutMapping("/order/cancelled")
    public ResponseEntity<?> orderCancelled(@RequestParam Long orderId) {
        Order order = orderService.orderCancelled(orderId);
        return new ResponseEntity<>( HttpStatus.OK);
    }


//    @PostMapping("/order/shipped")
//    public ResponseEntity<?> orderShipped(@RequestParam Long id) {
//        OrderShipped shipped = orderShippedService.orderShipped(id);
//        return new ResponseEntity<>(shipped, HttpStatus.CREATED);
//    }
//
//    @GetMapping("/get/all/shipped/order")
//    public ResponseEntity<?> getAllShippedOrder() {
//        List<ShippedOrderResponseDto> users = orderShippedService.getAllShippedOrder();
//        return new ResponseEntity<>(users, HttpStatus.OK);
//    }
}
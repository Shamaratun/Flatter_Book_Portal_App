package com.meme.onlinebookportal.controller;

import com.meme.onlinebookportal.dto.*;
import com.meme.onlinebookportal.model.Order;
import com.meme.onlinebookportal.model.User;
import com.meme.onlinebookportal.service.AuthorService;
import com.meme.onlinebookportal.service.BookService;
import com.meme.onlinebookportal.service.OrderService;
import com.meme.onlinebookportal.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/api/user")
public class UserController {

    private final BookService bookService;
    private final OrderService orderService;
    private final AuthorService authorService;
    private final UserService userService;

    public UserController(BookService bookService, OrderService orderService, AuthorService authorService, UserService userService) {
        this.bookService = bookService;
        this.orderService = orderService;
        this.authorService = authorService;
        this.userService = userService;
    }

    @GetMapping("/get/all/books")
    public ResponseEntity<?> getAllBooks() {
        List<BookResponseDto> bookList = bookService.getAllBooks();
        return new ResponseEntity<>(bookList, HttpStatus.OK) ;
    }

    @GetMapping("/get/all/authors")
    public ResponseEntity<?> getAllAuthors() {
        List<AuthorResponseDto> authorList = authorService.getAllAuthors();
        return new ResponseEntity<>(authorList, HttpStatus.OK) ;
    }

    @PostMapping("/order/request")
    public ResponseEntity<?> placeOrder(@RequestBody OrderRequestDto orderRequestDto) {
        OrderResponseDto orderRequest = orderService.placeOrderRequest(orderRequestDto);
        return new ResponseEntity<>(orderRequest,HttpStatus.CREATED);
    }
    @GetMapping("/get/my/all/order")
    public ResponseEntity<?> getAllOrdersByMe(@RequestParam Long id ) {
        List<OrderResponseDto> orders = orderService.getAllOrdersByMe(id);
        return new ResponseEntity<>(orders, HttpStatus.OK);
    }

    @GetMapping("/get/my/info")
    public ResponseEntity<?> getMyInfo(@RequestParam Long id ) {
        User user = userService.getMyInfo(id);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }

    @PutMapping("/edit/my/info")
    public ResponseEntity<?> editMyInfo(@RequestBody EditUserDto editUserDto, @RequestParam Long id ) {
        User user = userService.editMyInfo(editUserDto, id);
        return new ResponseEntity<>(user, HttpStatus.OK);
    }
}

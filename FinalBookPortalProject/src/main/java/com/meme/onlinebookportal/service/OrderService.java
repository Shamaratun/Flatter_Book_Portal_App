package com.meme.onlinebookportal.service;

import com.meme.onlinebookportal.constants.OrderStatus;
import com.meme.onlinebookportal.dto.OrderItemDto;
import com.meme.onlinebookportal.dto.OrderRequestDto;
import com.meme.onlinebookportal.dto.OrderResponseDto;
import com.meme.onlinebookportal.model.Book;
import com.meme.onlinebookportal.model.Order;
import com.meme.onlinebookportal.model.OrderItem;
import com.meme.onlinebookportal.model.User;
import com.meme.onlinebookportal.repository.BookRepository;
import com.meme.onlinebookportal.repository.OrderRepository;
import com.meme.onlinebookportal.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class OrderService {

    private final OrderRepository orderRepository;
    private final UserRepository userRepository;
    private final BookRepository bookRepository;

    public OrderService(OrderRepository orderRepository, UserRepository userRepository, BookRepository bookRepository) {
        this.orderRepository = orderRepository;
        this.userRepository = userRepository;
        this.bookRepository = bookRepository;
    }

    @Transactional
    public OrderResponseDto placeOrderRequest(OrderRequestDto orderRequestDto) {

        // Fetch and validate user
        User user = userRepository.findById(orderRequestDto.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found with ID: " + orderRequestDto.getUserId()));

        // Get requested book IDs and count duplicates
        List<Long> requestedIds = orderRequestDto.getBookIds();
        if (requestedIds == null || requestedIds.isEmpty()) {
            throw new RuntimeException("Book ID list cannot be null or empty.");
        }

        Map<Long, Long> bookIdCountMap = requestedIds.stream()
                .collect(Collectors.groupingBy(id -> id, Collectors.counting()));

        // Fetch books by unique IDs
        List<Book> foundBooks = bookRepository.findAllById(bookIdCountMap.keySet());
        if (foundBooks.size() != bookIdCountMap.size()) {
            Set<Long> foundIds = foundBooks.stream().map(Book::getId).collect(Collectors.toSet());
            List<Long> missingIds = bookIdCountMap.keySet().stream()
                    .filter(id -> !foundIds.contains(id))
                    .collect(Collectors.toList());
            throw new RuntimeException("Some books not found with IDs: " + missingIds);
        }

        // Create the order
        Order order = new Order();
        order.setUser(user);
        order.setAddress(orderRequestDto.getAddress());
        order.setContact(orderRequestDto.getContact());
        order.setOrderStatus(OrderStatus.INPROGRESS);

        // Prepare order items and calculate total price
        BigDecimal totalPrice = BigDecimal.ZERO;
        Set<OrderItem> orderItems = new HashSet<>();

        for (Book book : foundBooks) {
            Long quantity = bookIdCountMap.getOrDefault(book.getId(), 1L);
            BigDecimal bookPrice = book.getBookPrice() != null ? book.getBookPrice() : BigDecimal.ZERO;
            BigDecimal itemTotal = bookPrice.multiply(BigDecimal.valueOf(quantity));

            OrderItem orderItem = new OrderItem();
            orderItem.setOrder(order);
            orderItem.setBook(book);
            orderItem.setQuantity(quantity.intValue());
            orderItem.setItemPrice(itemTotal);

            orderItems.add(orderItem);
            totalPrice = totalPrice.add(itemTotal);
        }

        // Set total or override if provided
        BigDecimal finalPrice = orderRequestDto.getOrderPrice() != null
                ? orderRequestDto.getOrderPrice()
                : totalPrice;
        order.setOrderPrice(finalPrice);
        order.setOrderItems(orderItems);

        // Save order (cascades OrderItems)
        Order savedOrder = orderRepository.save(order);

        // Build response
        OrderResponseDto responseDto = new OrderResponseDto();
        responseDto.setOrderId(savedOrder.getId());
        responseDto.setUserId(savedOrder.getUser().getId());
        responseDto.setOrderPrice(savedOrder.getOrderPrice());

        // Optional: Add item list to DTO if needed

        return responseDto;
    }




    //Admin property
    @Transactional
    public List<OrderResponseDto> getAllOrders() {
        List<Order> orders = orderRepository.findAll();
        return orders.stream()
                .map(this::mapOrderResponseDto)
                .collect(Collectors.toList());
    }


    private OrderResponseDto mapOrderResponseDto(Order order) {
        OrderResponseDto dto = new OrderResponseDto();
        dto.setOrderId(order.getId());
        dto.setUserId(order.getUser().getId());
        dto.setUserName(order.getUser().getName());
        dto.setUserPhone(order.getContact());
        dto.setUserAddress(order.getAddress());
        dto.setOrderPrice(order.getOrderPrice());
        dto.setCreatedAt(order.getCreatedAt());
        dto.setOrderStatus(order.getOrderStatus());

        // Convert OrderItems to DTOs
        List<OrderItemDto> itemDtos = order.getOrderItems()
                .stream()
                .map(item -> new OrderItemDto(
                        item.getBook().getId(),
                        item.getBook().getBookName(),
                        item.getQuantity(),
                        item.getItemPrice()
                ))
                .collect(Collectors.toList());

        dto.setItems(itemDtos);

        return dto;
    }


    @Transactional
    public List<OrderResponseDto> getAllOrdersByMe(Long userId) {
        User user = userRepository.findById(userId).orElseThrow(
                () -> new RuntimeException("User not found with ID: " + userId));

        List<Order> orders = orderRepository.findAllByUser_Id(userId);

        return orders.stream().map(this::mapOrderResponseDto).collect(Collectors.toList());
    }

    @Transactional
    public void deleteOrderById(Long id) {

        orderRepository.deleteById(id);
    }

    @Transactional
    public Order orderDelivered(Long id) {
        Order order = orderRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Order not found with ID: " + id));
        order.setOrderStatus(OrderStatus.DELIVERED);
        return orderRepository.save(order);
    }

    @Transactional
    public Order orderCancelled(Long id) {
        Order order = orderRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Order not found with ID: " + id));
        order.setOrderStatus(OrderStatus.CANCELLED);
        return orderRepository.save(order);
    }


    @Transactional
    public Order orderCompleted(Long id) {
        Order order = orderRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Order not found with ID: " + id));
        order.setOrderStatus(OrderStatus.COMPLETED);
        return orderRepository.save(order);
    }
}



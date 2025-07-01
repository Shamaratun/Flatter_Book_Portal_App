package com.meme.onlinebookportal.dto;

import com.meme.onlinebookportal.constants.OrderStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderResponseDto {
    private Long orderId;
    private BigDecimal orderPrice;
    private String userName;
    private String userAddress;
    private String userPhone;
    private OrderStatus orderStatus;
    private Long userId;
    private List<OrderItemDto> items;
    private LocalDateTime createdAt;
}









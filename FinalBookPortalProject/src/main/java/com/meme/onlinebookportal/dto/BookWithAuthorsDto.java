package com.meme.onlinebookportal.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@AllArgsConstructor
public class BookWithAuthorsDto {
    private Long id;
    private String bookName;
    private int bookIsbnNumber;
    private BigDecimal bookPrice;
    private BigDecimal bookRating;
    private Integer bookQuantity;
    private String bookCategory;
    private String bookImageUrl;
    private String authorNames;
}

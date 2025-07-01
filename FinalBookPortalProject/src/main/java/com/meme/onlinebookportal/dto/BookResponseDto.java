package com.meme.onlinebookportal.dto;

import java.math.BigDecimal;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BookResponseDto {
	private Long id;
	private String bookName;
	private Long bookIsbnNumber;
	private BigDecimal bookPrice;
	private BigDecimal bookRating;
	private Long bookQuantity;
	private String bookDescription;
	private String bookCategory;
	private String bookImageUrl;
	private List<String> authorNames;
}
package com.meme.onlinebookportal.dto;

import java.math.BigDecimal;
import java.util.Set;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class AddBookDto {

	private String bookName;
	private Long bookIsbnNumber;
	private BigDecimal bookPrice;
	private String bookDescription;
	private BigDecimal bookRating;
	private String bookCategory;
	private Long bookQuantity;
	private String bookImageUrl;
	private Set<Long> bookAuthorIds;

}

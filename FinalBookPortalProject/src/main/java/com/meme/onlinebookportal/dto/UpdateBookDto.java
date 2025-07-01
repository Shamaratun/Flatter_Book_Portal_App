package com.meme.onlinebookportal.dto;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class UpdateBookDto {

	private String bookName;
	private Long bookIsbnNumber;
	private BigDecimal bookPrice;
	private BigDecimal bookRating;
	private String bookCategory;
	private Long bookQuantity;
	private String bookDescription;
	private String bookImageUrl;
	private List<Long> bookAuthorIds;

}
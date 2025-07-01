package com.meme.onlinebookportal.dto;

import lombok.*;

@Data
@RequiredArgsConstructor
public class AuthorResponseDto {
	private Long id;
	private String authorName;
	private Long authorNid;
	private String authorBio;
	private String address;
}

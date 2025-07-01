package com.meme.onlinebookportal.dto;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class LoginRequestDto {

    private String email;
    private String password;
}

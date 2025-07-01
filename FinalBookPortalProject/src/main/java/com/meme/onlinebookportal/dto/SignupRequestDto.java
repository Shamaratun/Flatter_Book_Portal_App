package com.meme.onlinebookportal.dto;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class SignupRequestDto {

    private String name;
    private String email;
    private String password;
    private String address;
    private String phoneNo;

}

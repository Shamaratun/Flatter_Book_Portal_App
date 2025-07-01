package com.meme.onlinebookportal.dto;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class EditUserDto {


    private String name;
    private String address;
    private String phoneNo;
}

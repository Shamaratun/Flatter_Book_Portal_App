package com.meme.onlinebookportal.controller;


import com.meme.onlinebookportal.config.JwtService;
import com.meme.onlinebookportal.config.UserInfoDetailsService;
import com.meme.onlinebookportal.config.userconfig.UserInfoDetails;
import com.meme.onlinebookportal.dto.LoginRequestDto;
import com.meme.onlinebookportal.dto.SignupRequestDto;
import com.meme.onlinebookportal.model.User;
import com.meme.onlinebookportal.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;

import java.net.MalformedURLException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping(value = "/api/auth")
public class AuthController {

    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;
    private final UserService userService;

    public AuthController(JwtService jwtService, AuthenticationManager authenticationManager, UserService userService) {
        this.jwtService = jwtService;
        this.authenticationManager = authenticationManager;
        this.userService = userService;
    }


    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody SignupRequestDto request) {
        User user = userService.registerNewUser(request);
        return new ResponseEntity<>(user, HttpStatus.CREATED);
    }



    @PostMapping("/login")
    public ResponseEntity<?> loginUser(
            HttpServletRequest httpServletRequest,
            HttpServletResponse httpServletResponse,
            @RequestBody LoginRequestDto loginRequest) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword()));

            if (authentication.isAuthenticated()) {
                final String jwtToken = jwtService.createToken(loginRequest.getEmail());
                UserInfoDetails userInfoDetails = (UserInfoDetails) authentication.getPrincipal();
                User user = userInfoDetails.user();

                Map<String, Object> responseData = new HashMap<>();
                responseData.put("token", jwtToken);
                responseData.put("id", user.getId());
                responseData.put("role", user.getRole());
                //responseData.put("token_type", "Bearer");


//                Map<String, Object> userData = new HashMap<>();
//                userData.put("Name", user.getName());
//                userData.put("Email", user.getEmail());
//                userData.put("Phone", user.getPhone());
//                userData.put("Role", user.getRole());
//
//                responseData.put("user", userData);

                return ResponseEntity.ok(responseData);
            }else {
                throw new UsernameNotFoundException("Invalid User or password");
            }
        } catch (AuthenticationException ex) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid username or password");
        }
    }

    @GetMapping("/image/{filename:.+}")
    public ResponseEntity<Resource> serveImage(@PathVariable String filename) {
        Path imagePath = Paths.get("uploads").resolve(filename).normalize();

        try {
            Resource resource = new UrlResource(imagePath.toUri());
            if (resource.exists()) {
                return ResponseEntity.ok()
                        .contentType(MediaType.IMAGE_JPEG) // or detect dynamically
                        .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (MalformedURLException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
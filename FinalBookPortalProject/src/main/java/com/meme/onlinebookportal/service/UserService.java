package com.meme.onlinebookportal.service;

import com.meme.onlinebookportal.dto.EditUserDto;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.meme.onlinebookportal.constants.Role;
import com.meme.onlinebookportal.dto.SignupRequestDto;
import com.meme.onlinebookportal.model.User;
import com.meme.onlinebookportal.repository.UserRepository;

import jakarta.transaction.Transactional;

import java.util.List;

@Service
public class UserService {

	private final UserRepository userRepository;
	private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }


    @Transactional
	public User registerNewUser(SignupRequestDto request) {

		User existUser = userRepository.findByEmail(request.getEmail()).orElse(null);

		if (existUser != null) {
			throw new RuntimeException("User already exist by the email: " + request.getEmail());
		}
		User user = new User();
		user.setName(request.getName());
		user.setEmail(request.getEmail());
		user.setPassword(passwordEncoder.encode(request.getPassword()));
		user.setRole(Role.USER);

		return userRepository.save(user);

	}

	public List<User> getAllUsers() {
		return userRepository.findAll();
	}

	@Transactional
	public User getMyProfile(Long id) {
		User user = userRepository.findById(id).orElseThrow(
				() -> new RuntimeException("User not found by the id: "+id)
		);

		return user;
	}

	@Transactional
	public User getMyInfo(Long id) {
	return	userRepository.findById(id).orElseThrow(
			() -> new RuntimeException("User not found by the id: "+id)
	);
	}

	@Transactional
	public User editMyInfo(EditUserDto editUserDto, Long id) {
		User user = userRepository.findById(id).orElseThrow(
				() -> new RuntimeException("User not found by the id: "+id)
		);

		user.setName(editUserDto.getName());
		user.setPhoneNumber(editUserDto.getPhoneNo());
		user.setAddress(editUserDto.getAddress());

		return userRepository.save(user);

	}
}
package com.meme.onlinebookportal.config;

import com.meme.onlinebookportal.config.userconfig.UserInfoDetails;
import com.meme.onlinebookportal.model.User;
import com.meme.onlinebookportal.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


@Service
public class UserInfoDetailsService implements UserDetailsService {


    private final UserRepository userRepository;

    public UserInfoDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    @Transactional
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User userDetails = userRepository.findByEmail(email).orElseThrow(()->
                new UsernameNotFoundException("User not found with the email: "+ email));

        return new UserInfoDetails(userDetails);
    }
}

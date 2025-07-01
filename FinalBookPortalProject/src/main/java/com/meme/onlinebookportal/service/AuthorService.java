package com.meme.onlinebookportal.service;

import com.meme.onlinebookportal.dto.AddAuthorDto;
import com.meme.onlinebookportal.dto.AuthorResponseDto;
import com.meme.onlinebookportal.dto.UpdateAuthorDto;
import com.meme.onlinebookportal.model.Author;
import com.meme.onlinebookportal.model.Book;
import com.meme.onlinebookportal.repository.AuthorRepository;
import com.meme.onlinebookportal.repository.BookRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class AuthorService {

    private final AuthorRepository authorRepository;

    public AuthorService(AuthorRepository authorRepository) {
        this.authorRepository = authorRepository;
    }

    @Transactional
    public Author addNewAuthor(AddAuthorDto addAuthorDto) {
        if (addAuthorDto == null) {
            throw new IllegalArgumentException("AddAuthorDto must not be null");
        }

        Author author = new Author();
        author.setAuthorName(addAuthorDto.getAuthorName());
        author.setAuthorBio(addAuthorDto.getAuthorBio());
        author.setAuthorNid(addAuthorDto.getAuthorNid());
        author.setAddress(addAuthorDto.getAddress());

        return authorRepository.save(author);
    }

    @Transactional
    public Author updateAuthor(UpdateAuthorDto updateAuthorDto) {

        Author existingAuthor = authorRepository.findById(updateAuthorDto.getId()).orElseThrow(
                () -> new RuntimeException("Author not found with ID: " + updateAuthorDto.getId())
        );

        existingAuthor.setAuthorName(updateAuthorDto.getAuthorName());
        existingAuthor.setAuthorBio(updateAuthorDto.getAuthorBio());
        existingAuthor.setAuthorNid(updateAuthorDto.getAuthorNid());
        existingAuthor.setAddress(updateAuthorDto.getAddress());

        return authorRepository.save(existingAuthor);

    }

    public void deleteAuthor(Long id) {
        authorRepository.deleteById(id);
    }

    @Transactional
    public List<AuthorResponseDto> getAllAuthors() {
        List<Author> authors = authorRepository.findAll();
        return authors.stream().map(this::mapAuthorResponseDto).collect(Collectors.toList());
    }

    private AuthorResponseDto mapAuthorResponseDto(Author author) {
        AuthorResponseDto authorResponseDto = new AuthorResponseDto();
        authorResponseDto.setId(author.getId());
        authorResponseDto.setAuthorName(author.getAuthorName());
        authorResponseDto.setAuthorNid(author.getAuthorNid());
        authorResponseDto.setAddress(author.getAddress());
        authorResponseDto.setAuthorBio(author.getAuthorBio());
        return authorResponseDto;
    }


    //Admin property
    @Transactional
    public List<AuthorResponseDto> getAllAuthorsByAdmin() {
        List<Author> authors = authorRepository.findAll();
        return authors.stream().map(this::mapAuthorResponseDto).collect(Collectors.toList());
    }
}

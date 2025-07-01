package com.meme.onlinebookportal.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import com.meme.onlinebookportal.dto.BookResponseDto;
import org.springframework.stereotype.Service;

import com.meme.onlinebookportal.dto.AddBookDto;
import com.meme.onlinebookportal.dto.UpdateBookDto;
import com.meme.onlinebookportal.model.Author;
import com.meme.onlinebookportal.model.Book;
import com.meme.onlinebookportal.repository.AuthorRepository;
import com.meme.onlinebookportal.repository.BookRepository;

import jakarta.transaction.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
public class BookService {

	private final BookRepository bookRepository;
	private final AuthorRepository authorRepository;

	public BookService(BookRepository bookRepository, AuthorRepository authorRepository) {
		this.bookRepository = bookRepository;
		this.authorRepository = authorRepository;
	}

	@Transactional
	public Book addNewBook(AddBookDto addBookDto, MultipartFile imageFile) {

		// Check for existing book by ISBN
		Book existBook = bookRepository.findByBookIsbnNumber(addBookDto.getBookIsbnNumber());
		if (existBook != null) {
			throw new RuntimeException("Book already exists with ISBN Number: " + addBookDto.getBookIsbnNumber());
		}

		Book book = new Book();
		book.setBookName(addBookDto.getBookName());
		book.setBookIsbnNumber(addBookDto.getBookIsbnNumber());
		book.setBookPrice(addBookDto.getBookPrice());
		book.setBookRating(addBookDto.getBookRating());
		book.setBookCategory(addBookDto.getBookCategory());
		book.setBookQuantity(addBookDto.getBookQuantity());
		book.setBookDescripton(addBookDto.getBookDescription());

		// Save image file to local folder and store the path
		if (imageFile != null && !imageFile.isEmpty()) {
			try {
				String uploadDir = "uploads/";
				String originalFilename = imageFile.getOriginalFilename();
				String uniqueFilename = UUID.randomUUID() + "_" + originalFilename;
				Path uploadPath = Paths.get(uploadDir);

				if (!Files.exists(uploadPath)) {
					Files.createDirectories(uploadPath);
				}

				Path filePath = uploadPath.resolve(uniqueFilename);
				Files.copy(imageFile.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

				// Save the relative or absolute file path
				book.setBookImageUrl(uniqueFilename); // or filePath.toString() for absolute path

			} catch (IOException e) {
				throw new RuntimeException("Failed to save book image", e);
			}
        }

		// Set authors
		if (addBookDto.getBookAuthorIds() != null && !addBookDto.getBookAuthorIds().isEmpty()) {
			Set<Author> authors = new HashSet<>(authorRepository.findAllById(addBookDto.getBookAuthorIds()));
			book.setBookAuthors(authors);
		}

		return bookRepository.save(book);
	}


	@Transactional
	public List<BookResponseDto> getAllBooks() {

		List<Book> books = bookRepository.findAllBooks();
        return books.stream().map(this::mapBookResponseDto).collect(Collectors.toList());
	}

	private BookResponseDto mapBookResponseDto(Book book) {
		BookResponseDto bookResponseDto = new BookResponseDto();
		bookResponseDto.setId(book.getId());
		bookResponseDto.setBookName(book.getBookName());
		bookResponseDto.setBookCategory(book.getBookCategory());
		bookResponseDto.setBookPrice(book.getBookPrice());
		bookResponseDto.setBookQuantity(book.getBookQuantity());
		bookResponseDto.setBookRating(book.getBookRating());
		bookResponseDto.setBookImageUrl(book.getBookImageUrl());
		bookResponseDto.setBookDescription(book.getBookDescripton());
		bookResponseDto.setBookIsbnNumber(book.getBookIsbnNumber());
		bookResponseDto.setAuthorNames(book.getBookAuthors().stream().map(Author::getAuthorName).collect(Collectors.toList()));

		return bookResponseDto;
	}


	@Transactional
	public Book updateBook(UpdateBookDto updateBookDto, MultipartFile imageFile) {

		// Fetch the existing book or throw an exception if not found
		Book existBook = bookRepository.findByBookIsbnNumber(updateBookDto.getBookIsbnNumber());
		if (existBook == null)
			throw new RuntimeException("Book not found with ID: " + updateBookDto.getBookIsbnNumber());

		// Update basic fields of the book
		existBook.setBookName(updateBookDto.getBookName());
		existBook.setBookIsbnNumber(updateBookDto.getBookIsbnNumber());
		existBook.setBookPrice(updateBookDto.getBookPrice());
		existBook.setBookRating(updateBookDto.getBookRating());
		existBook.setBookCategory(updateBookDto.getBookCategory());
		existBook.setBookQuantity(updateBookDto.getBookQuantity());
		existBook.setBookDescripton(updateBookDto.getBookDescription());

		// Update authors
		Set<Author> authors = new HashSet<>(authorRepository.findAllById(updateBookDto.getBookAuthorIds()));
		existBook.setBookAuthors(authors);

		// Handle image update
		if (imageFile != null && !imageFile.isEmpty()) {
			try {
				// Delete the old image if it exists
				if (existBook.getBookImageUrl() != null) {
					Path oldPath = Paths.get("uploads").resolve(existBook.getBookImageUrl());
					Files.deleteIfExists(oldPath);
				}

				// Create the uploads directory if it doesn't exist
				Path uploadDir = Paths.get("uploads");
				if (!Files.exists(uploadDir)) {
					Files.createDirectories(uploadDir);
				}

				// Save the new image
				String filename = UUID.randomUUID() + "_" + imageFile.getOriginalFilename();
				Path filePath = uploadDir.resolve(filename);
				Files.copy(imageFile.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

				// Update the book with the new image URL
				existBook.setBookImageUrl(filename);

			} catch (IOException e) {
				throw new RuntimeException("Error updating book image", e);
			}
		}

		// Save and return the updated book
		return bookRepository.save(existBook);
	}


	@Transactional
	public void deleteBookById(Long id) {
		bookRepository.deleteById(id);
	}

	@Transactional
	public Book getBookById(Long id) {
		Book book = bookRepository.findById(id).orElseThrow(
				() -> new RuntimeException("Book not found with ID: " + id));
		return book;
	}

	@Transactional
	public List<BookResponseDto> getAllBooksByAdmin() {
		List<Book> books= bookRepository.findAllBooks();
		return books.stream().map(this::mapBookResponseDto).collect(Collectors.toList());
	}
}

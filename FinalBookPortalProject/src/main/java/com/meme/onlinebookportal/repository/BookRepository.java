package com.meme.onlinebookportal.repository;

import com.meme.onlinebookportal.model.Book;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookRepository extends JpaRepository<Book, Long> {

    @Query("SELECT DISTINCT b FROM Book b LEFT JOIN FETCH b.bookAuthors")
    List<Book> findAllBooksWithAuthors();

//    @EntityGraph(attributePaths = "bookAuthors")
//    @Query("SELECT b FROM Book b")
//    List<Book> findAllWithAuthors();

    // Debug query - see if this works
    @Query("SELECT b FROM Book b")
    List<Book> findAllBooks();

    Book findByBookIsbnNumber(Long bookIsbnNumber);
}

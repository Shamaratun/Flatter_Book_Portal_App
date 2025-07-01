package com.meme.onlinebookportal.model;

import com.meme.onlinebookportal.dto.BookResponseDto;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
@Getter
@Setter
@Entity
@Table(name = "meme_book")
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "book_name")
    private String bookName;

    @Column(name = "isbn_number")
    private Long bookIsbnNumber; // Optional: use String

    @Column(name = "book_price")
    private BigDecimal bookPrice;

    @Column(name = "book_rating")
    private BigDecimal bookRating;

    @Column(name = "book_category")
    private String bookCategory;

    @Column(name = "book_imageUrl")
    private String bookImageUrl;

    @Column(name = "book_quantity")
    private Long bookQuantity;

    @Column(name = "book_description", length = 1000)
    private String bookDescripton;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "meme_book_author",
            joinColumns = @JoinColumn(name = "book_id"),
            inverseJoinColumns = @JoinColumn(name = "author_id")
    )
    private Set<Author> bookAuthors;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    public void prePersist() {
        if (createdAt == null) {
            createdAt = LocalDateTime.now();
        }
    }

    public BookResponseDto toBookResponseDto() {
        BookResponseDto dto = new BookResponseDto();
        dto.setId(this.id);
        dto.setBookName(this.bookName);
        dto.setBookIsbnNumber(this.bookIsbnNumber);
        dto.setBookPrice(this.bookPrice);
        dto.setBookRating(this.bookRating);
        dto.setBookCategory(this.bookCategory);
        dto.setBookImageUrl(this.bookImageUrl); // Fixed
        return dto;
    }
}
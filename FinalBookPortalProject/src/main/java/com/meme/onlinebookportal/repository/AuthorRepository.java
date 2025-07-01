package com.meme.onlinebookportal.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.meme.onlinebookportal.model.Author;

@Repository
public interface AuthorRepository extends JpaRepository<Author, Long> {
	Author findByAuthorNid(Integer authorNid);

}

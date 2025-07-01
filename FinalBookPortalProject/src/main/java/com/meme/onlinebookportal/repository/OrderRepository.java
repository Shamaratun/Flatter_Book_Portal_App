package com.meme.onlinebookportal.repository;

import com.meme.onlinebookportal.model.Order;
import com.meme.onlinebookportal.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {

    List<Order> findByUser(User user);

    List<Order> findAllByUser_Id(Long userId);
}

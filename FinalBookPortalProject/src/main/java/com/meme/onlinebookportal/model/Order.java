package com.meme.onlinebookportal.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

import com.meme.onlinebookportal.constants.OrderStatus;

import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "meme_order")
public class Order {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "order_price", nullable = false)
	private BigDecimal orderPrice;

	@Column(name = "order_address", nullable = false)
	private String address;

	@Column(name = "order_contact", nullable = false)
	private String contact;

	@Column(name = "order_status")
	@Enumerated(value = EnumType.STRING)
	private OrderStatus orderStatus;

	@ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;

	// Replaces ManyToMany
	@OneToMany(mappedBy = "order", cascade = CascadeType.ALL, orphanRemoval = true)
	private Set<OrderItem> orderItems = new HashSet<>();

	@Column(name = "created_at")
	private LocalDateTime createdAt;

	@PrePersist
	public void prePersist() {
		if (createdAt == null) {
			createdAt = LocalDateTime.now();
		}
	}
}


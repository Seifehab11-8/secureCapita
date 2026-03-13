package io.seif.securecapita.model;


import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "Users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {
    @Id
    @Column(name = "user_id")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer userId; /* Integer is an object and initially it = null which aligns with sql standard */

    @Column(name = "first_name", nullable = false)
    @NotEmpty(message = "Please Enter the First name")
    private String firstName;

    @Column(name = "last_name", nullable = false)
    @NotEmpty(message = "Please Enter the Last name")
    private String lastName;

    @Column(name = "email", nullable = false)
    @NotEmpty(message = "Please Enter the email")
    @Email(message = "Email is incorrect, Please Enter valid email")
    private String email;

    @Column(name = "password")
    private String password;

    @Column(name = "phone")
    private String phone;

    @Column(name = "address")
    private String address;

    @Column(name = "title")
    private String title;

    @Column(name = "bio")
    private String bio;

    @Column(name = "enabled")
    private Boolean enabled;

    @Column(name = "non_locked")
    private Boolean nonLocked;

    @Column(name = "using_mfa")
    private Boolean usingMfa;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "image_url")
    private String imageUrl;
}

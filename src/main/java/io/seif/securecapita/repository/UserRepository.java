package io.seif.securecapita.repository;

import io.seif.securecapita.model.User;
import org.springframework.data.jpa.repository.JpaRepository;


public interface UserRepository extends JpaRepository<User, Long> {

}

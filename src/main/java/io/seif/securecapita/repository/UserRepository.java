package io.seif.securecapita.repository;

import io.seif.securecapita.model.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;


public interface UserRepository extends JpaRepository<User, Long> {
    /* Simple Crud Operations */
    @Override
    Page<User> findAll(Pageable pageable);

    @Override
    <S extends User> S save(S entity);

    User getUserByUserId(Integer userId);

    boolean deleteUserByUserId(Integer userId);

}

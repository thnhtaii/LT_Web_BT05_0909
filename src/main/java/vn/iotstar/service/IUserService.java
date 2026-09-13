package vn.iotstar.service;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.iotstar.entity.User;

public interface IUserService {

    List<User> findAll();

    Page<User> findAll(Pageable pageable);

    Page<User> search(String keyword, Pageable pageable);

    Optional<User> findById(int id);

    Optional<User> findByUsername(String username);

    Optional<User> findByEmail(String email);

    User save(User user);

    void deleteById(int id);

    boolean existsById(int id);

    boolean existsByUsername(String username);

    boolean existsByEmail(String email);

    long count();

    long countByRoleId(int roleId);

    void toggleStatus(int id);
}

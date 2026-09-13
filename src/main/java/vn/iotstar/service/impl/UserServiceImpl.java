package vn.iotstar.service.impl;

import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import vn.iotstar.entity.User;
import vn.iotstar.repository.UserRepository;
import vn.iotstar.service.IUserService;

@Service
@Transactional
public class UserServiceImpl implements IUserService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public List<User> findAll() {
        return userRepository.findAll();
    }

    @Override
    public Page<User> findAll(Pageable pageable) {
        return userRepository.findAll(pageable);
    }

    @Override
    public Page<User> search(String keyword, Pageable pageable) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            return userRepository.searchUsers(keyword.trim(), pageable);
        }
        return userRepository.findAll(pageable);
    }

    @Override
    public Optional<User> findById(int id) {
        return userRepository.findById(id);
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public User save(User user) {
        return userRepository.save(user);
    }

    @Override
    public void deleteById(int id) {
        userRepository.deleteById(id);
    }

    @Override
    public boolean existsById(int id) {
        return userRepository.existsById(id);
    }

    @Override
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    public long count() {
        return userRepository.count();
    }

    @Override
    public long countByRoleId(int roleId) {
        return userRepository.countByRoleId(roleId);
    }

    @Override
    public void toggleStatus(int id) {
        Optional<User> opt = userRepository.findById(id);
        if (opt.isPresent()) {
            User user = opt.get();
            // Nếu 1 -> chuyển thành 2 (khóa), nếu 2 hoặc 0 -> chuyển thành 1 (hoạt động)
            if (user.getStatus() == 1) {
                user.setStatus(2);
            } else {
                user.setStatus(1);
            }
            userRepository.save(user);
        }
    }
}

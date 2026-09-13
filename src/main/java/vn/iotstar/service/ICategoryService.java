package vn.iotstar.service;

import java.util.List;
import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import vn.iotstar.entity.Category;

public interface ICategoryService {

    List<Category> findAll();

    Page<Category> findAll(Pageable pageable);

    Page<Category> search(String keyword, Pageable pageable);

    Optional<Category> findById(int id);

    Category save(Category category);

    void deleteById(int id);

    boolean existsById(int id);

    boolean existsByCategoryname(String categoryname);

    long count();
}

package vn.iotstar.repository;

import java.util.Optional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import vn.iotstar.entity.Category;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Integer> {

    // Tìm kiếm theo tên có phân trang
    Page<Category> findByCategorynameContainingIgnoreCase(String categoryname, Pageable pageable);

    // Kiểm tra tên danh mục đã tồn tại chưa
    Optional<Category> findByCategoryname(String categoryname);

    boolean existsByCategoryname(String categoryname);

    // Đếm số lượng danh mục theo từ khóa
    long countByCategorynameContainingIgnoreCase(String categoryname);
}

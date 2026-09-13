package vn.iotstar.controller.admin;

import java.io.IOException;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import jakarta.validation.Valid;
import vn.iotstar.entity.Category;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.utils.FileUploadUtil;

@Controller
@RequestMapping("/admin")
public class CategoryController {

    @Autowired
    private ICategoryService categoryService;

    // Danh sách Category có tìm kiếm & phân trang
    @GetMapping("/categories")
    public String listCategories(
            @RequestParam(name = "keyword", required = false, defaultValue = "") String keyword,
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "size", defaultValue = "5") int size,
            @RequestParam(name = "sort", defaultValue = "categoryId") String sortField,
            @RequestParam(name = "direction", defaultValue = "desc") String direction,
            Model model) {

        if (page < 1) page = 1;
        if (size < 1) size = 5;

        Sort sort = direction.equalsIgnoreCase("asc") ? Sort.by(sortField).ascending() : Sort.by(sortField).descending();
        Pageable pageable = PageRequest.of(page - 1, size, sort);

        Page<Category> categoryPage = categoryService.search(keyword, pageable);

        model.addAttribute("categoryPage", categoryPage);
        model.addAttribute("categories", categoryPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", categoryPage.getTotalPages());
        model.addAttribute("totalItems", categoryPage.getTotalElements());
        model.addAttribute("keyword", keyword);
        model.addAttribute("size", size);
        model.addAttribute("sortField", sortField);
        model.addAttribute("direction", direction);
        model.addAttribute("reverseDirection", direction.equalsIgnoreCase("asc") ? "desc" : "asc");
        model.addAttribute("activeMenu", "categories");

        return "admin/category-list";
    }

    // Hiển thị form thêm mới Category
    @GetMapping("/category/add")
    public String showAddForm(Model model) {
        model.addAttribute("category", new Category());
        model.addAttribute("activeMenu", "categories");
        return "admin/category-add";
    }

    // Xử lý lưu mới Category
    @PostMapping("/category/save")
    public String saveCategory(
            @Valid @ModelAttribute("category") Category category,
            BindingResult result,
            @RequestParam(name = "imageFile", required = false) MultipartFile imageFile,
            RedirectAttributes redirectAttributes,
            Model model) {

        if (result.hasErrors()) {
            model.addAttribute("activeMenu", "categories");
            return "admin/category-add";
        }

        // Kiểm tra trùng tên danh mục
        if (categoryService.existsByCategoryname(category.getCategoryname())) {
            model.addAttribute("errorMessage", "Tên danh mục đã tồn tại trong hệ thống!");
            model.addAttribute("activeMenu", "categories");
            return "admin/category-add";
        }

        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                String savedFile = FileUploadUtil.saveFile("categories", imageFile);
                category.setImages(savedFile);
            }
            categoryService.save(category);
            redirectAttributes.addFlashAttribute("message", "Thêm mới danh mục thành công!");
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi upload file: " + e.getMessage());
        }

        return "redirect:/admin/categories";
    }

    // Hiển thị form chỉnh sửa Category
    @GetMapping("/category/edit/{id}")
    public String showEditForm(@PathVariable("id") int id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Category> opt = categoryService.findById(id);
        if (!opt.isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy danh mục có mã: " + id);
            return "redirect:/admin/categories";
        }
        model.addAttribute("category", opt.get());
        model.addAttribute("activeMenu", "categories");
        return "admin/category-edit";
    }

    // Xử lý cập nhật Category
    @PostMapping("/category/update")
    public String updateCategory(
            @Valid @ModelAttribute("category") Category category,
            BindingResult result,
            @RequestParam(name = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(name = "currentImage", required = false) String currentImage,
            RedirectAttributes redirectAttributes,
            Model model) {

        if (result.hasErrors()) {
            model.addAttribute("activeMenu", "categories");
            return "admin/category-edit";
        }

        try {
            if (imageFile != null && !imageFile.isEmpty()) {
                // Upload file mới
                String savedFile = FileUploadUtil.saveFile("categories", imageFile);
                category.setImages(savedFile);
                // Xóa file cũ nếu có
                FileUploadUtil.deleteFile(currentImage);
            } else {
                // Giữ lại ảnh cũ
                category.setImages(currentImage);
            }

            categoryService.save(category);
            redirectAttributes.addFlashAttribute("message", "Cập nhật danh mục thành công!");
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi cập nhật hình ảnh: " + e.getMessage());
        }

        return "redirect:/admin/categories";
    }

    // Xóa Category
    @GetMapping("/category/delete/{id}")
    public String deleteCategory(@PathVariable("id") int id, RedirectAttributes redirectAttributes) {
        Optional<Category> opt = categoryService.findById(id);
        if (opt.isPresent()) {
            try {
                Category cat = opt.get();
                categoryService.deleteById(id);
                // Xóa ảnh vật lý liên kết
                FileUploadUtil.deleteFile(cat.getImages());
                redirectAttributes.addFlashAttribute("message", "Đã xóa danh mục thành công!");
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("error", "Không thể xóa danh mục vì có dữ liệu liên quan hoặc ràng buộc toàn vẹn!");
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "Danh mục không tồn tại!");
        }
        return "redirect:/admin/categories";
    }
}

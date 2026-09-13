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
import vn.iotstar.entity.User;
import vn.iotstar.service.IUserService;
import vn.iotstar.utils.FileUploadUtil;

@Controller
@RequestMapping("/admin")
public class UserController {

    @Autowired
    private IUserService userService;

    // Danh sách Người dùng có tìm kiếm & phân trang
    @GetMapping("/users")
    public String listUsers(
            @RequestParam(name = "keyword", required = false, defaultValue = "") String keyword,
            @RequestParam(name = "page", defaultValue = "1") int page,
            @RequestParam(name = "size", defaultValue = "5") int size,
            @RequestParam(name = "sort", defaultValue = "id") String sortField,
            @RequestParam(name = "direction", defaultValue = "desc") String direction,
            Model model) {

        if (page < 1) page = 1;
        if (size < 1) size = 5;

        Sort sort = direction.equalsIgnoreCase("asc") ? Sort.by(sortField).ascending() : Sort.by(sortField).descending();
        Pageable pageable = PageRequest.of(page - 1, size, sort);

        Page<User> userPage = userService.search(keyword, pageable);

        model.addAttribute("userPage", userPage);
        model.addAttribute("users", userPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", userPage.getTotalPages());
        model.addAttribute("totalItems", userPage.getTotalElements());
        model.addAttribute("keyword", keyword);
        model.addAttribute("size", size);
        model.addAttribute("sortField", sortField);
        model.addAttribute("direction", direction);
        model.addAttribute("reverseDirection", direction.equalsIgnoreCase("asc") ? "desc" : "asc");
        model.addAttribute("activeMenu", "users");

        return "admin/user-list";
    }

    // Hiển thị form thêm mới User
    @GetMapping("/user/add")
    public String showAddForm(Model model) {
        User user = new User();
        user.setRoleId(2); // Mặc định là User
        user.setStatus(1); // Mặc định là Hoạt động
        model.addAttribute("user", user);
        model.addAttribute("activeMenu", "users");
        return "admin/user-add";
    }

    // Xử lý lưu mới User
    @PostMapping("/user/save")
    public String saveUser(
            @Valid @ModelAttribute("user") User user,
            BindingResult result,
            @RequestParam(name = "avatarFile", required = false) MultipartFile avatarFile,
            RedirectAttributes redirectAttributes,
            Model model) {

        // Kiểm tra validation
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            result.rejectValue("password", "error.user", "Mật khẩu không được để trống");
        }

        if (result.hasErrors()) {
            model.addAttribute("activeMenu", "users");
            return "admin/user-add";
        }

        // Kiểm tra trùng username
        if (userService.existsByUsername(user.getUsername())) {
            model.addAttribute("errorMessage", "Tên đăng nhập '" + user.getUsername() + "' đã được sử dụng!");
            model.addAttribute("activeMenu", "users");
            return "admin/user-add";
        }

        // Kiểm tra trùng email
        if (userService.existsByEmail(user.getEmail())) {
            model.addAttribute("errorMessage", "Địa chỉ email '" + user.getEmail() + "' đã được sử dụng!");
            model.addAttribute("activeMenu", "users");
            return "admin/user-add";
        }

        try {
            if (avatarFile != null && !avatarFile.isEmpty()) {
                String savedFile = FileUploadUtil.saveFile("users", avatarFile);
                user.setImages(savedFile);
                user.setAvatar(savedFile);
            }
            userService.save(user);
            redirectAttributes.addFlashAttribute("message", "Thêm mới người dùng thành công!");
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi upload ảnh đại diện: " + e.getMessage());
        }

        return "redirect:/admin/users";
    }

    // Hiển thị form chỉnh sửa User
    @GetMapping("/user/edit/{id}")
    public String showEditForm(@PathVariable("id") int id, Model model, RedirectAttributes redirectAttributes) {
        Optional<User> opt = userService.findById(id);
        if (!opt.isPresent()) {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng có ID: " + id);
            return "redirect:/admin/users";
        }
        model.addAttribute("user", opt.get());
        model.addAttribute("activeMenu", "users");
        return "admin/user-edit";
    }

    // Xử lý cập nhật User
    @PostMapping("/user/update")
    public String updateUser(
            @Valid @ModelAttribute("user") User user,
            BindingResult result,
            @RequestParam(name = "avatarFile", required = false) MultipartFile avatarFile,
            @RequestParam(name = "currentAvatar", required = false) String currentAvatar,
            @RequestParam(name = "newPassword", required = false) String newPassword,
            RedirectAttributes redirectAttributes,
            Model model) {

        // Không validate password trống khi sửa vì có thể người dùng không đổi pass
        if (result.hasFieldErrors("username") || result.hasFieldErrors("email") || result.hasFieldErrors("fullname")) {
            model.addAttribute("activeMenu", "users");
            return "admin/user-edit";
        }

        // Kiểm tra nếu đổi email sang email của người khác
        Optional<User> existingEmailUser = userService.findByEmail(user.getEmail());
        if (existingEmailUser.isPresent() && existingEmailUser.get().getId() != user.getId()) {
            model.addAttribute("errorMessage", "Email này đã thuộc về tài khoản khác!");
            model.addAttribute("activeMenu", "users");
            return "admin/user-edit";
        }

        try {
            Optional<User> optDb = userService.findById(user.getId());
            if (!optDb.isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Người dùng không tồn tại!");
                return "redirect:/admin/users";
            }

            User dbUser = optDb.get();

            // Cập nhật mật khẩu nếu có nhập mới
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                dbUser.setPassword(newPassword.trim());
            }

            // Cập nhật thông tin cơ bản
            dbUser.setFullname(user.getFullname());
            dbUser.setEmail(user.getEmail());
            dbUser.setPhone(user.getPhone());
            dbUser.setRoleId(user.getRoleId());
            dbUser.setStatus(user.getStatus());

            // Xử lý avatar
            if (avatarFile != null && !avatarFile.isEmpty()) {
                String savedFile = FileUploadUtil.saveFile("users", avatarFile);
                dbUser.setImages(savedFile);
                dbUser.setAvatar(savedFile);
                FileUploadUtil.deleteFile(currentAvatar);
            } else {
                dbUser.setImages(currentAvatar);
                dbUser.setAvatar(currentAvatar);
            }

            userService.save(dbUser);
            redirectAttributes.addFlashAttribute("message", "Cập nhật người dùng thành công!");
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi cập nhật ảnh đại diện: " + e.getMessage());
        }

        return "redirect:/admin/users";
    }

    // Xóa User
    @GetMapping("/user/delete/{id}")
    public String deleteUser(@PathVariable("id") int id, RedirectAttributes redirectAttributes) {
        if (id == 1) {
            redirectAttributes.addFlashAttribute("error", "Không thể xóa tài khoản Quản trị viên mặc định (ID = 1)!");
            return "redirect:/admin/users";
        }

        Optional<User> opt = userService.findById(id);
        if (opt.isPresent()) {
            try {
                User user = opt.get();
                userService.deleteById(id);
                FileUploadUtil.deleteFile(user.getAvatar());
                redirectAttributes.addFlashAttribute("message", "Đã xóa người dùng thành công!");
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("error", "Không thể xóa người dùng do có dữ liệu liên quan!");
            }
        } else {
            redirectAttributes.addFlashAttribute("error", "Người dùng không tồn tại!");
        }
        return "redirect:/admin/users";
    }

    // Đổi trạng thái nhanh (Kích hoạt / Khóa)
    @GetMapping("/user/toggle-status/{id}")
    public String toggleUserStatus(@PathVariable("id") int id, RedirectAttributes redirectAttributes) {
        if (id == 1) {
            redirectAttributes.addFlashAttribute("error", "Không thể khóa tài khoản Quản trị viên mặc định!");
            return "redirect:/admin/users";
        }

        userService.toggleStatus(id);
        redirectAttributes.addFlashAttribute("message", "Đã thay đổi trạng thái người dùng thành công!");
        return "redirect:/admin/users";
    }
}

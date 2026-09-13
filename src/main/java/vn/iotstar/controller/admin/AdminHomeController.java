package vn.iotstar.controller.admin;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import vn.iotstar.repository.UserRepository;
import vn.iotstar.service.ICategoryService;
import vn.iotstar.service.IUserService;

@Controller
public class AdminHomeController {

    @Autowired
    private ICategoryService categoryService;

    @Autowired
    private IUserService userService;

    @Autowired
    private UserRepository userRepository;

    @GetMapping("/")
    public String root() {
        return "redirect:/admin";
    }

    @GetMapping({"/admin", "/admin/", "/admin/dashboard"})
    public String dashboard(Model model) {
        long totalCategories = categoryService.count();
        long totalUsers = userService.count();
        long totalAdmins = userRepository.countByRoleId(1);
        long activeUsers = userRepository.countByStatus(1);

        // Lấy 5 danh mục mới nhất
        model.addAttribute("recentCategories", categoryService.findAll(PageRequest.of(0, 5, Sort.by("categoryId").descending())).getContent());
        // Lấy 5 người dùng mới nhất
        model.addAttribute("recentUsers", userService.findAll(PageRequest.of(0, 5, Sort.by("id").descending())).getContent());

        model.addAttribute("totalCategories", totalCategories);
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalAdmins", totalAdmins);
        model.addAttribute("activeUsers", activeUsers);
        model.addAttribute("activeMenu", "dashboard");

        return "admin/dashboard";
    }
}

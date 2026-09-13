package vn.iotstar.entity;

import java.io.Serializable;
import java.sql.Timestamp;
import jakarta.persistence.*;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Entity
@Table(name = "users")
public class User implements Serializable {

    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private int id;

    @NotBlank(message = "Tên đăng nhập không được để trống")
    @Size(min = 3, max = 50, message = "Tên đăng nhập từ 3 đến 50 ký tự")
    @Column(name = "username", length = 50, unique = true, nullable = false)
    private String username;

    @NotBlank(message = "Email không được để trống")
    @Email(message = "Email không hợp lệ")
    @Column(name = "email", length = 100, unique = true, nullable = false)
    private String email;

    @Column(name = "password", length = 255, nullable = false)
    private String password;

    @Column(name = "fullname", columnDefinition = "NVARCHAR(100) NULL")
    private String fullname;

    @Column(name = "phone", length = 20, nullable = true)
    private String phone;

    @Column(name = "images", columnDefinition = "NVARCHAR(255) NULL")
    private String images;

    @Column(name = "avatar", columnDefinition = "NVARCHAR(255) NULL")
    private String avatar;

    @Column(name = "roleId")
    private int roleId = 2; // 1: Admin, 2: User

    @Column(name = "status")
    private int status = 1; // 1: Hoạt động, 0: Chờ kích hoạt, 2: Bị khóa

    @Column(name = "otpCode", length = 10, nullable = true)
    private String otpCode;

    @Column(name = "otpExpiry", nullable = true)
    private Timestamp otpExpiry;

    public User() {
    }

    public User(String username, String email, String password, String fullname) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullname = fullname;
        this.roleId = 2;
        this.status = 1;
    }

    public User(String username, String email, String password, String fullname, String phone, String images, int roleId, int status) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullname = fullname;
        this.phone = phone;
        this.images = images;
        this.avatar = images;
        this.roleId = roleId;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getImages() {
        if (images != null && !images.trim().isEmpty()) {
            return images;
        }
        return avatar;
    }

    public void setImages(String images) {
        this.images = images;
        this.avatar = images;
    }

    public String getAvatar() {
        if (avatar != null && !avatar.trim().isEmpty()) {
            return avatar;
        }
        return images;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
        this.images = avatar;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getOtpCode() {
        return otpCode;
    }

    public void setOtpCode(String otpCode) {
        this.otpCode = otpCode;
    }

    public Timestamp getOtpExpiry() {
        return otpExpiry;
    }

    public void setOtpExpiry(Timestamp otpExpiry) {
        this.otpExpiry = otpExpiry;
    }

    public boolean isAdmin() {
        return this.roleId == 1;
    }

    public String getRoleName() {
        return this.roleId == 1 ? "Quản trị viên (Admin)" : "Người dùng (User)";
    }

    public String getStatusName() {
        switch (this.status) {
            case 1:
                return "Đang hoạt động";
            case 0:
                return "Chưa kích hoạt";
            case 2:
                return "Đang bị khóa";
            default:
                return "Không xác định";
        }
    }
}

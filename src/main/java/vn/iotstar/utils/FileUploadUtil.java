package vn.iotstar.utils;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import org.apache.commons.io.FilenameUtils;
import org.springframework.web.multipart.MultipartFile;

public class FileUploadUtil {

    public static String saveFile(String uploadSubDir, MultipartFile multipartFile) throws IOException {
        if (multipartFile == null || multipartFile.isEmpty()) {
            return null;
        }

        String originalFilename = multipartFile.getOriginalFilename();
        String extension = FilenameUtils.getExtension(originalFilename);
        if (extension == null || extension.isEmpty()) {
            extension = "png";
        }

        // Tạo tên file duy nhất tránh trùng lặp
        String uniqueFileName = UUID.randomUUID().toString().substring(0, 8) + "_" + System.currentTimeMillis() + "." + extension;

        Path uploadPath = Paths.get("uploads", uploadSubDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(uniqueFileName);
        Files.copy(multipartFile.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return uploadSubDir + "/" + uniqueFileName;
    }

    public static void deleteFile(String relativeFilePath) {
        if (relativeFilePath != null && !relativeFilePath.trim().isEmpty()) {
            try {
                Path path = Paths.get("uploads", relativeFilePath);
                Files.deleteIfExists(path);
            } catch (IOException e) {
                // Ghi nhận lỗi nhưng không chặn chương trình
                System.err.println("Không thể xóa file: " + e.getMessage());
            }
        }
    }
}

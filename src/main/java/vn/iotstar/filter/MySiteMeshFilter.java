package vn.iotstar.filter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

public class MySiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // Cấu hình decorator cho các route /admin
        builder.addDecoratorPath("/admin/*", "/admin.jsp")
               .addDecoratorPath("/admin", "/admin.jsp")
               .addDecoratorPath("/*", "/admin.jsp")
               // Loại trừ tài nguyên tĩnh và uploads khỏi sitemesh
               .addExcludedPath("/assets/*")
               .addExcludedPath("/static/*")
               .addExcludedPath("/css/*")
               .addExcludedPath("/js/*")
               .addExcludedPath("/images/*")
               .addExcludedPath("/uploads/*");
    }
}

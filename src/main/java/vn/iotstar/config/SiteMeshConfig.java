package vn.iotstar.config;

import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import vn.iotstar.filter.MySiteMeshFilter;

@Configuration
public class SiteMeshConfig {

    @Bean
    public FilterRegistrationBean<MySiteMeshFilter> siteMeshFilter() {
        FilterRegistrationBean<MySiteMeshFilter> filterRegistrationBean = new FilterRegistrationBean<>();
        filterRegistrationBean.setFilter(new MySiteMeshFilter());
        filterRegistrationBean.addUrlPatterns("/*");
        filterRegistrationBean.setOrder(1);
        return filterRegistrationBean;
    }
}

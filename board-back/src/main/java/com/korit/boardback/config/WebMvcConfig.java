package com.korit.boardback.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.Resource;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.resource.PathResourceResolver;

import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@Configuration // 스프링 MVC 설정 클래스
public class WebMvcConfig implements WebMvcConfigurer {

    @Value("${user.dir}") // 현재 프로젝트 경로
    private String rootPath;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/image/**") // /image/** 요청 시
                .addResourceLocations("file:" + rootPath + "/upload") // 로컬 파일 시스템의 업로드 폴더에서 제공
                .resourceChain(true)
                .addResolver(new PathResourceResolver() { // 경로 변환 처리
                    @Override
                    protected Resource getResource(String resourcePath, Resource location) throws IOException {
                        resourcePath = URLDecoder.decode(resourcePath, StandardCharsets.UTF_8); // URL 디코딩
                        return super.getResource(resourcePath, location);
                    }
                });
    }
}

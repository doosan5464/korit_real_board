package com.korit.boardback.config;

import com.korit.boardback.security.filter.JwtAuthenticationFilter;
import com.korit.boardback.security.handler.CustomAuthenticationEntryPoint;
import com.korit.boardback.security.oAuth2.CustomOAuth2SuccessHandler;
import com.korit.boardback.security.oAuth2.CustomOAuth2UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration // Spring Security 설정 클래스
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationFilter jwtAuthenticationFilter; // JWT 인증 필터
    @Autowired
    private CustomOAuth2UserService customOAuth2UserService; // OAuth2 사용자 서비스
    @Autowired
    private CustomOAuth2SuccessHandler customOAuth2SuccessHandler; // OAuth2 로그인 성공 핸들러
    @Autowired
    private CustomAuthenticationEntryPoint customAuthenticationEntryPoint; // 인증 실패 핸들러

    @Bean
    public BCryptPasswordEncoder passwordEncoder() { // 비밀번호 암호화
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.cors(Customizer.withDefaults()); // CORS 설정
        http.csrf(csrf -> csrf.disable()); // CSRF 비활성화

        http.sessionManagement(sessionManagement -> {
            sessionManagement.sessionCreationPolicy(SessionCreationPolicy.STATELESS); // 세션 사용 안 함 (JWT 방식)
        });

        http.httpBasic(httpBasic -> httpBasic.disable()); // 기본 인증 비활성화
        http.formLogin(formLogin -> formLogin.disable()); // 폼 로그인 비활성화

        http.oauth2Login(oauth2 -> {
            oauth2.userInfoEndpoint(userInfoEndpoint -> {
                userInfoEndpoint.userService(customOAuth2UserService); // OAuth2 사용자 서비스 설정
            });
            oauth2.successHandler(customOAuth2SuccessHandler); // OAuth2 로그인 성공 핸들러 설정
        });

        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        // JWT 인증 필터 추가

        http.exceptionHandling(exception -> {
            exception.authenticationEntryPoint(customAuthenticationEntryPoint); // 인증 실패 핸들링
        });

        http.authorizeHttpRequests(authorizeRequests -> {
            authorizeRequests.requestMatchers("/api/auth/**", "/image/**").permitAll(); // 특정 경로 허용
            authorizeRequests.anyRequest().authenticated(); // 나머지는 인증 필요
        });

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() { // CORS 설정
        final UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        final CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);
        config.addAllowedOriginPattern("*");
        config.addAllowedHeader("*");
        config.addAllowedMethod("*");
        source.registerCorsConfiguration("/**", config);
        return source;
    }
}

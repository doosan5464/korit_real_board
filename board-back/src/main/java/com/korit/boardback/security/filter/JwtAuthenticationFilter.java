package com.korit.boardback.security.filter;

import com.korit.boardback.entity.User;
import com.korit.boardback.repository.UserRepository;
import com.korit.boardback.security.jwt.JwtUtil;
import com.korit.boardback.security.principal.PrincipalUser;
import io.jsonwebtoken.Claims;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component // 스프링 빈으로 등록
public class JwtAuthenticationFilter implements Filter {

    @Autowired
    private JwtUtil jwtUtil; // JWT 유틸리티 클래스
    @Autowired
    private UserRepository userRepository; // 사용자 정보 조회용 리포지토리

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;

        jwtAuthentication(getAccessToken(request)); // JWT 인증 수행

        filterChain.doFilter(servletRequest, servletResponse); // 다음 필터 실행
    }

    private void jwtAuthentication(String accessToken) {
        if(accessToken == null) {return;} // 토큰이 없으면 종료
        Claims claims = jwtUtil.parseToken(accessToken); // 토큰 검증 및 정보 추출

        int userId = Integer.parseInt(claims.getId());
        User user = userRepository.findById(userId).get(); // 사용자 조회

        PrincipalUser principalUser = PrincipalUser.builder().user(user).build();
        Authentication authentication =
                new UsernamePasswordAuthenticationToken(principalUser, null, principalUser.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authentication); // 인증 정보 설정
    }

    private String getAccessToken(HttpServletRequest request) {
        String accessToken = null;
        String authorization = request.getHeader("Authorization"); // 헤더에서 토큰 가져오기

        if (authorization != null && authorization.startsWith("Bearer ")) {
            accessToken = authorization.substring(7); // "Bearer " 부분 제거
        }

        return accessToken;
    }

}
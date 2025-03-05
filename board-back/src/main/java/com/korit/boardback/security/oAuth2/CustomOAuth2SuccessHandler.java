package com.korit.boardback.security.oAuth2;

import com.korit.boardback.entity.User;
import com.korit.boardback.security.jwt.JwtUtil;
import com.korit.boardback.security.principal.PrincipalUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Date;


@Component // OAuth2 로그인 성공 핸들러
public class CustomOAuth2SuccessHandler implements AuthenticationSuccessHandler {

    @Value(value = "${react.server.protocol}")
    private String protocol; // 리액트 서버 프로토콜
    @Value(value = "${react.server.host}")
    private String host; // 리액트 서버 호스트
    @Value(value = "${react.server.port}")
    private int port; // 리액트 서버 포트

    @Autowired
    private JwtUtil jwtUtil; // JWT 유틸리티 클래스

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        PrincipalUser principalUser = (PrincipalUser) authentication.getPrincipal();
        User user = principalUser.getUser();
        Date expires = new Date(new Date().getTime() + (1000L * 60 * 60 * 7)); // 7시간 후 만료
        String accessToken = jwtUtil
                .generateToken(user.getUsername(), Integer.toString(user.getUserId()), expires);

        // OAuth2 로그인 성공 후 리액트 서버로 리디렉트
        response.sendRedirect(String.format("%s://%s:%d/auth/login/oauth2?accessToken=%s", protocol, host, port, accessToken));
    }

}


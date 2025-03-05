package com.korit.boardback.security.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;

@Component
public class JwtUtil {
    private Key key;

    // 생성자에서 Base64로 인코딩된 시크릿 키를 디코딩 후, HMAC SHA256 키 생성
    public JwtUtil(@Value("${jwt.secret}") String secret) {
        key = Keys.hmacShaKeyFor(Decoders.BASE64.decode(secret));
    }

    // JWT 토큰 생성
    public String generateToken(String subject, String id, Date expires) {
        return Jwts.builder()
                .setSubject(subject)  // 사용자 정보 (주로 username)
                .setId(id)  // 유저 ID
                .setExpiration(expires)  // 만료 시간 설정
                .signWith(key, SignatureAlgorithm.HS256)  // HMAC SHA256 서명
                .compact();  // 최종적으로 JWT 문자열 반환
    }

    // JWT 토큰 검증 및 파싱
    public Claims parseToken(String token) {
        return Jwts.parser()
                .setSigningKey(key)  // 서명 키 설정
                .parseClaimsJws(token)  // 서명 검증 및 디코딩
                .getBody();  // Claims(토큰에 저장된 정보) 반환
    }
}
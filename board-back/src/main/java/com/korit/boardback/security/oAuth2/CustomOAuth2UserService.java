package com.korit.boardback.security.oAuth2;

import com.korit.boardback.entity.User;
import com.korit.boardback.entity.UserRole;
import com.korit.boardback.repository.UserRepository;
import com.korit.boardback.repository.UserRoleRepository;
import com.korit.boardback.security.principal.PrincipalUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Service // OAuth2 사용자 정보를 처리하는 서비스
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserRoleRepository userRoleRepository;
    @Autowired
    private DefaultOAuth2UserService defaultOAuth2UserService; // 기본 OAuth2 사용자 서비스

    @Override
    @Transactional(rollbackFor = Exception.class) // 예외 발생 시 롤백
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        String email = null;
        String oauth2Name = null;
        String oauth2Provider = userRequest.getClientRegistration().getRegistrationId(); // 제공자 정보
        Map<String, Object> attributes = getDefaultOAuth2User(userRequest).getAttributes();

        // OAuth2 제공자별 사용자 정보 매핑
        if(oauth2Provider.equalsIgnoreCase("naver")) {
            attributes = (Map<String, Object>) attributes.get("response");
            oauth2Name = (String) attributes.get("id");
            email = (String) attributes.get("email");
        }
        if(oauth2Provider.equalsIgnoreCase("google")) {
            oauth2Name = (String) attributes.get("sub");
            email = (String) attributes.get("email");
        }

        final String username = oauth2Provider + "_" + oauth2Name;
        final String finalEmail = email;
        final String finalOauth2Name = oauth2Name;

        // 사용자 정보 조회 또는 신규 사용자 등록
        User user = userRepository
                .findByUsername(username)
                .orElseGet(() -> {
                    User newUser = User.builder()
                            .username(username)
                            .nickname(username)
                            .email(finalEmail)
                            .oAuth2Name(finalOauth2Name)
                            .oAuth2Provider(oauth2Provider)
                            .accountExpired(1)
                            .accountLocked(1)
                            .credentialsExpired(1)
                            .accountEnabled(1)
                            .build();
                    User savedUser = userRepository.save(newUser);

                    // 기본 권한 부여
                    UserRole userRole = UserRole.builder()
                            .userId(savedUser.getUserId())
                            .roleId(1)
                            .build();
                    userRoleRepository.save(userRole);

                    return userRepository.findByUsername(username).get();
                });

        // PrincipalUser 객체 생성 및 반환
        return PrincipalUser.builder()
                .user(user)
                .name(oauth2Name)
                .attributes(attributes)
                .build();
    }

    private OAuth2User getDefaultOAuth2User(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        return defaultOAuth2UserService.loadUser(userRequest); // 기본 OAuth2 사용자 정보 가져오기
    }

}


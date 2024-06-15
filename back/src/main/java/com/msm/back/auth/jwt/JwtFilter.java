package com.msm.back.auth.jwt;

import com.msm.back.db.repository.BlacklistRepository;
import com.msm.back.exception.TokenValidationException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.LocalDateTime;

@Slf4j
@RequiredArgsConstructor
public class JwtFilter extends OncePerRequestFilter {

    public static final String AUTHORIZATION_HEADER = "Authorization";
    public static final String BEARER_PREFIX = "Bearer ";

    private final TokenProvider tokenProvider;
    private final BlacklistRepository blacklistRepository;

    // 실제 필터링 로직은 doFilterInternal 에 들어감
    // JWT 토큰의 인증 정보를 현재 쓰레드의 SecurityContext 에 저장하는 역할 수행
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        try {
            String jwt = resolveToken(request);
            if (StringUtils.hasText(jwt) && tokenProvider.validateToken(jwt)) {
                // 예외가 발생할 수 있는 부분
                boolean isBlacklisted = blacklistRepository.findByToken(jwt)
                        .map(blacklist -> blacklist.getExpiryDate().isAfter(LocalDateTime.now()))
                        .orElse(false);
                if (isBlacklisted) {
                    throw new TokenValidationException("This token is blacklisted.");
                }

                Authentication authentication = tokenProvider.getAuthentication(jwt);
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        } catch (Exception e) {
            log.error("Authentication exception in JWT filter: {}", e.getMessage());
            // 커스텀 에러 메시지를 포함하는 응답 생성
            setCustomErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED, e.getMessage());
            return; // 필터 체인을 계속 진행하지 않고 여기서 중단
        }

        filterChain.doFilter(request, response);
    }

    private void setCustomErrorResponse(HttpServletResponse response, int status, String errorMessage) throws IOException {
        response.setStatus(status);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 에러 메시지를 JSON 형태로 구성
        String errorJson = String.format("%s", errorMessage);

        response.getWriter().write(errorJson);
        response.getWriter().flush();
        response.getWriter().close();
    }

    // Request Header 에서 토큰 정보를 꺼내오기
    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader(AUTHORIZATION_HEADER);
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith(BEARER_PREFIX)) {
            return bearerToken.substring(7);
        }
        return null;
    }
}

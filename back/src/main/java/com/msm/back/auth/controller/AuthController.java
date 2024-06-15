package com.msm.back.auth.controller;

import com.msm.back.auth.dto.MemberRequestDto;
import com.msm.back.auth.dto.MemberResponseDto;
import com.msm.back.auth.dto.TokenResponseDto;
import com.msm.back.auth.dto.TokenRequestDto;
import com.msm.back.auth.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {
    private final AuthService authService;

    @PostMapping("/signup")
    @Operation(summary = "회원 가입")
    public ResponseEntity<MemberResponseDto> signup(@RequestBody @Valid MemberRequestDto memberRequestDto) {
        return ResponseEntity.ok(authService.signup(memberRequestDto));
    }

    @PostMapping("/login")
    @Operation(summary = "로그인")
    public ResponseEntity<MemberResponseDto> login(@RequestBody @Valid MemberRequestDto memberRequestDto) {
        return ResponseEntity.ok(authService.login(memberRequestDto));
    }

    @PostMapping("/logout")
    @Operation(summary = "로그아웃")
    public ResponseEntity<Void> logout(@RequestBody TokenRequestDto tokenRequestDto) {
        authService.logout(tokenRequestDto);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/reissue")
    @Operation(summary = "JWT 토큰 재발급")
    public ResponseEntity<TokenResponseDto> reissue(@RequestHeader("Refresh-Token") String refreshToken, @RequestBody TokenRequestDto tokenRequestDto) {
        return ResponseEntity.ok(authService.reissue(refreshToken, tokenRequestDto));
    }

}

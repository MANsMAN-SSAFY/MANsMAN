package com.msm.back.auth.service;

import com.msm.back.auth.dto.MemberRequestDto;
import com.msm.back.auth.dto.MemberResponseDto;
import com.msm.back.auth.dto.TokenRequestDto;
import com.msm.back.auth.dto.TokenResponseDto;
import com.msm.back.auth.jwt.TokenProvider;
import com.msm.back.db.entity.Member;
import com.msm.back.db.entity.RefreshToken;
import com.msm.back.db.entity.Report;
import com.msm.back.db.repository.BlacklistRepository;
import com.msm.back.db.repository.MemberRepository;
import com.msm.back.db.repository.RefreshTokenRepository;
import com.msm.back.db.repository.ReportRepository;
import com.msm.back.exception.CustomAuthenticationException;
import com.msm.back.exception.EmailAlreadyExistsException;
import com.msm.back.exception.InvalidTokenException;
import com.msm.back.exception.MemberNotFoundException;
import com.msm.back.member.dto.ProfileResponseDto;
import com.msm.back.member.dto.ReportDto;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final AuthenticationManagerBuilder authenticationManagerBuilder;
    private final MemberRepository memberRepository;
    private final PasswordEncoder passwordEncoder;
    private final TokenProvider tokenProvider;
    private final RefreshTokenRepository refreshTokenRepository;
    private final BlacklistRepository blacklistRepository;
    private final ReportRepository reportRepository;

    @Transactional
    public MemberResponseDto signup(MemberRequestDto memberRequestDto) {
        if (memberRepository.existsByEmail(memberRequestDto.getEmail())) {
            throw new EmailAlreadyExistsException("이미 가입되어 있는 유저입니다");
        }

        // 회원 정보 저장
        Member member = memberRequestDto.toMember(passwordEncoder);
        memberRepository.save(member);

        // 최종적으로 MemberResponseDto 반환
        return login(memberRequestDto);
    }

    @Transactional
    public MemberResponseDto login(MemberRequestDto memberRequestDto) {
        try {
            // 1. Login ID/PW 를 기반으로 AuthenticationToken 생성
            UsernamePasswordAuthenticationToken authenticationToken = memberRequestDto.toAuthentication();

            // 2. 실제로 검증 (사용자 비밀번호 체크) 이 이루어지는 부분
            Authentication authentication = authenticationManagerBuilder.getObject().authenticate(authenticationToken);

            // 3. 인증 정보를 기반으로 JWT 토큰 생성
            TokenResponseDto tokenResponseDto = tokenProvider.generateTokenResponseDto(authentication);

            // 4. RefreshToken 저장 및 업데이트
            RefreshToken refreshToken = refreshTokenRepository.findByKey(authentication.getName())
                    .map(existingToken -> existingToken.updateValue(tokenResponseDto.getRefreshToken()))
                    .orElseGet(() -> RefreshToken.builder()
                            .key(authentication.getName())
                            .value(tokenResponseDto.getRefreshToken())
                            .build());

            refreshTokenRepository.save(refreshToken);

            // 인증 성공 후 Member 엔티티를 조회
            Member member = memberRepository.findByEmail(memberRequestDto.getEmail())
                    .orElseThrow(MemberNotFoundException::new);

            // notificationToken이 제공된 경우 및 DB에 저장된 값과 다를 경우에만 업데이트
            if (memberRequestDto.getNotificationToken() != null
                    && !memberRequestDto.getNotificationToken().isEmpty()
                    && !memberRequestDto.getNotificationToken().equals(member.getNotificationToken())) {

                member.setNotificationToken(memberRequestDto.getNotificationToken());
                memberRepository.save(member);
            }

            // 사용자의 최신 Report 조회
            Optional<Report> latestReportOpt = reportRepository.findFirstByMemberOrderByCreatedAtDesc(member);

            ReportDto reportDto = null;
            if (latestReportOpt.isPresent()) {
                Report latestReport = latestReportOpt.get();
                reportDto = ReportDto.builder()
                        .acne(latestReport.getAcne())
                        .wrinkle(latestReport.getWrinkle())
//                        .blackhead(latestReport.getBlackhead())
                        .age(latestReport.getAge())
                        .skinType(latestReport.getSkinType())
                        .faceShape(latestReport.getFaceShapeCode().getCodeName())
                        .build();
            }

            // ProfileResponseDto 생성 시 ReportDto 포함
            ProfileResponseDto profileResponseDto = ProfileResponseDto.builder()
                    .member(member)
                    .build();
            profileResponseDto.setReport(reportDto);
            // MemberResponseDto 반환
            return MemberResponseDto.builder()
                    .tokenResponseDto(tokenResponseDto)
                    .ProfileResponseDto(profileResponseDto)
                    .build();

        } catch (BadCredentialsException e) {
            // 잘못된 인증 정보에 대한 처리
            throw new CustomAuthenticationException("로그인 정보가 올바르지 않습니다.");
        } catch (DisabledException e) {
            // 계정이 비활성화된 경우의 처리
            throw new CustomAuthenticationException("계정이 비활성화되었습니다.");
        } catch (AuthenticationException e) {
            // 그 외 인증 관련 예외 처리
            throw new CustomAuthenticationException("인증 과정에서 예외가 발생했습니다.");
        }

    }

    @Transactional
    public void logout(TokenRequestDto tokenRequestDto) {
        // 1. Refresh Token 검증
//        if (!tokenProvider.validateToken(tokenRequestDto.getRefreshToken())) {
//            throw new InvalidTokenException("Refresh Token 이 유효하지 않습니다.");
//        }

        // 2. Access Token 에서 사용자 이름(또는 사용자 ID) 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // 3. Refresh Token 정보 삭제
        refreshTokenRepository.deleteByKey(authentication.getName());

        // 4. 블랙리스트에 토큰 추가 (만료 시간 설정 포함)
//        Blacklist blacklist = new Blacklist();
//        blacklist.setToken(tokenRequestDto.getRefreshToken());
        // 예를 들어, 만료 시간을 설정하는 경우 (2주 후 만료로 설정)
//        blacklist.setExpiryDate(LocalDateTime.now().plusWeeks(2));
//        blacklistRepository.save(blacklist);

        // SecurityContext 초기화
        SecurityContextHolder.clearContext();
    }

    @Transactional
    public TokenResponseDto reissue(String refreshTokenValue, TokenRequestDto tokenRequestDto) {
        if (!tokenProvider.validateToken(refreshTokenValue)) {
            throw new InvalidTokenException("유효하지 않은 리프레시 토큰입니다.");
        }

        RefreshToken refreshToken = refreshTokenRepository.findByValue(refreshTokenValue)
                .orElseThrow(() -> new InvalidTokenException("리프레시 토큰이 존재하지 않습니다."));

        Long memberId = Long.parseLong(refreshToken.getKey());

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new MemberNotFoundException());

        if (tokenRequestDto.getNotificationToken() != null
                && !tokenRequestDto.getNotificationToken().isEmpty()
                && !tokenRequestDto.getNotificationToken().equals(member.getNotificationToken())) {

            member.setNotificationToken(tokenRequestDto.getNotificationToken());
            memberRepository.save(member);
        }

        TokenResponseDto newTokenResponse = tokenProvider.generateTokenResponseDtoForReissue(memberId);

        return newTokenResponse;
    }

}

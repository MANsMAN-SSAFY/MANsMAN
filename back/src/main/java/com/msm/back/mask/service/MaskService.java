package com.msm.back.mask.service;

import com.msm.back.db.entity.Mask;
import com.msm.back.db.entity.Member;
import com.msm.back.db.repository.MaskRepository;
import com.msm.back.db.repository.MemberRepository;
import com.msm.back.mask.dto.MaskRequestDto;
import com.msm.back.mask.dto.MaskResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class MaskService {

    private final MaskRepository maskRepository;
    private final MemberRepository memberRepository;

    @Transactional
    public MaskResponseDto recordMask(MaskRequestDto maskRequestDto) {
        // 로그인된 나의 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long myMemberId = Long.parseLong(authentication.getName());
        Member me = memberRepository.findById(myMemberId).orElseThrow(() -> new IllegalArgumentException(myMemberId + " " + "를 id로 지닌 멤버가 존재하지 않습니다"));

        // 이미 날짜에 마스크 사용 여부가 기록되어 있는 경우
        LocalDate date = LocalDate.parse(maskRequestDto.getUsedAt());
        List<Mask> masks = maskRepository.findAllByCreatedAtDate(date);
        if (!masks.isEmpty()) {
            return null;
        }

        // 날짜에 마스크 사용 여부 기록
        Mask savedMask = maskRepository.save(Mask.builder()
                .member(me)
                .usedAt(date)
                .build());

        return MaskResponseDto.builder().id(savedMask.getId()).usedAt(date).build();
    }

    public List<MaskResponseDto> getRecordsInMonth(int month, int year) {
        // 로그인된 나의 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long myMemberId = Long.parseLong(authentication.getName());

        // 주어진 연도와 달에 로그인된 유저에 의해 생성된 기록들을 모두 가져온다
        List<Mask> masks = maskRepository.findAllByCreatedAtMonthAndYearAndMember(month, year, myMemberId);

        List<MaskResponseDto> maskResponseDtoList = new ArrayList<>();

        for (Mask mask: masks) {
            maskResponseDtoList.add(mask.toMaskResponseDto());
        }

        //log.info(maskResponseDtoList.toString());

        return maskResponseDtoList;

    }
}

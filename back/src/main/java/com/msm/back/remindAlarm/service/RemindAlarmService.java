package com.msm.back.remindAlarm.service;

import com.msm.back.db.entity.Member;
import com.msm.back.db.entity.Report;
import com.msm.back.db.repository.MemberRepository;
import com.msm.back.db.repository.ReportRepository;
import com.msm.back.exception.UserLogoutException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class RemindAlarmService {
    private final ReportRepository reportRepository;
    private final MemberRepository memberRepository;

    //  오늘 피부 분석 리포트가 없는 모든 유저들의 notification token들의 리스트를 가져온다.
    public List<String> getNotificationTokens() {
        List<String> notificationTokensList = new ArrayList<>();
        List<Member> members = memberRepository.findMembersWithoutReportsToday();

        for (Member member: members) {
            notificationTokensList.add(member.getNotificationToken());
        }

        return notificationTokensList;

    }
}

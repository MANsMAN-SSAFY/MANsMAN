package com.msm.back.report.service;

import com.msm.back.common.SecurityUtil;
import com.msm.back.db.entity.*;
import com.msm.back.db.repository.CommonCodeRepository;
import com.msm.back.db.repository.MemberRepository;
import com.msm.back.db.repository.ReportRepository;
import com.msm.back.exception.ReportNotFoundException;
import com.msm.back.member.service.FileService;
import com.msm.back.report.dto.ReportResponseDto;
import com.msm.back.report.dto.ReportScrollReponseDto;
import com.msm.back.report.dto.ReportSaveReqDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Slice;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.client.WebClient;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Transactional
@Slf4j
public class ReportService {
    private final ReportRepository reportRepository;
    private final MemberRepository memberRepository;
    private final CommonCodeRepository commonCodeRepository;
    private final FileService fileService;

    @Value("${fastapi.url}")
    private String fastApiUrl;
    public ReportResponseDto getReportByDate(LocalDate date) { // 특정한 날짜에 만들어진 '나'의 피부 리포트를 가져온다.
        // 로그인된 나의 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long myMemberId = Long.parseLong(authentication.getName());

        // 특정한 날짜에 만들어진 나의 피부 리포트 가져오기:
        List<Report> myReport = reportRepository.findByCreatedAtAndCreatedBy(date, myMemberId);

        // 나의 오늘 피부 리포트가 없다면
        if (myReport.isEmpty()) {
            return ReportResponseDto.builder().exists(false).build();
        }


       return myReport.get(0).toReportResponseDto();

    }

    // 오늘 분석한 '나'의 피부 리포트를 가져온다
    public ReportResponseDto getDailyReport() {
        LocalDate today = LocalDate.now();
        return getReportByDate(today);
    }

    // 지난 일주일간의 피부 분석 리포트들 보내준다
    public ReportResponseDto[] getWeeklyReport() {
        // 로그인된 나의 정보 가져오기
//        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//        Long myMemberId = Long.parseLong(authentication.getName());

        ReportResponseDto[] weeklyReport = new ReportResponseDto[7];
        LocalDate today = LocalDate.now();
        for (int i = 6; i > -1; i--) {
            LocalDate localDate = today.minusDays(i);
            weeklyReport[6 - i] = getReportByDate(localDate);
        }

        return weeklyReport;

    }

    // 사진을 받고, 그것을 기반으로 피부 분석 리포트를 생성한다

    public ReportResponseDto saveReport(MultipartFile multipartFile) {
        // 로그인된 나의 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long myMemberId = Long.parseLong(authentication.getName());
        Member me = memberRepository.findById(myMemberId).orElseThrow(() -> new IllegalArgumentException(myMemberId + " " + "를 id로 지닌 멤버가 존재하지 않습니다"));

        // 사진을 S3로 upload한다
        String imgUrl = fileService.uploadFile(multipartFile);
        log.info(imgUrl);
        // 아래의 사진을 imgUrl로 변경
        ReportSaveReqDto reportSaveReqDto = ReportSaveReqDto.builder().imgUrl(imgUrl).build();

        WebClient webClient =
                WebClient
                        .builder()
                        .baseUrl(fastApiUrl)
                        .build();

        // skin-diary api 요청 후 분석된 결과를 받는다
        Map<String, Object> skinDiaryMap =
                    webClient
                            .post()
                            .uri("/skin-diary")
                            .bodyValue(reportSaveReqDto)
                            .retrieve()
                            .bodyToMono(Map.class)
                            .block();

        // log.info(skinDiaryMap.toString());

        // 오늘 저장된 report가 있다면, 그것을 update한다. 오늘 저장된 report가 없다면, 새로 생성한다.
        List<Report> todayReport = reportRepository.findByCreatedAtAndCreatedBy(LocalDate.now(), myMemberId);

        //  분석된 결과를 DB에 저장 또는 업데이트 한다.
        int acne = (int) skinDiaryMap.get("acne");
        int wrinkle = (int) skinDiaryMap.get("wrinkle");
//        int blackhead = (int) skinDiaryMap.get("blackhead");
        SkinTypeEnum skinTypeEnum = SkinTypeEnum.valueOf(skinDiaryMap.get("skinType").toString());
        CommonCode faceShapeCode = commonCodeRepository.findByCode((int) skinDiaryMap.get("faceShape"));
        int age = (int) skinDiaryMap.get("age");

        Report toSaveReport = Report.builder()
                .member(me)
                .acne(acne)
                .wrinkle(wrinkle)
//                .blackhead(blackhead)
                .skinType(skinTypeEnum)
                .faceShapeCode(faceShapeCode)
                .imgUrl(imgUrl)
                .age(age)
                .memo("메모를 작성해주세요")
                .water(0.0)
                .sleep(0.0)
                .build();

        Report savedReport;

        if (todayReport.isEmpty()) {
            savedReport = reportRepository.save(toSaveReport);

        } else {
            savedReport = todayReport.get(0);

            savedReport.updateAcne(acne);
            savedReport.updateWrinkle(wrinkle);
//            savedReport.updateBlackhead(blackhead);
            savedReport.updateSkinType(skinTypeEnum);
            savedReport.updateFaceShapeCode(faceShapeCode);
            savedReport.updateAge(age);
            savedReport.updateImgUrl(imgUrl);
        }

        // log.info(_savedReport.toString());
        String skinType = "";
        if (skinTypeEnum.name().equals("DRY")) {
            skinType = "건성";
        } else if(skinTypeEnum.name().equals("OILY")) {
            skinType = "지성";
        } else if (skinTypeEnum.name().equals("NORMAL")) {
            skinType = "복합성";
        }

        // savedReport에서 DailyReportResponseDto 생성해서 return

        ReportResponseDto dailyReportResponseDto = ReportResponseDto.builder()
                .reportId(savedReport.getId())
                .memberId(myMemberId)
                .acne(acne)
                .wrinkle(wrinkle)
//                .blackhead(blackhead)
                .skinType(skinType)
                .faceShape(faceShapeCode.getCodeName())
                .imgUrl(imgUrl)
                .age(age)
                .date(savedReport.getCreatedAt().toLocalDate())
                .exists(true)
                .sleep(savedReport.getSleep())
                .water(savedReport.getWater())
                .memo(savedReport.getMemo())
                .build();

//        log.info(diaryResponseDto.toString());
//        log.info(dailyReportResponseDto.toString());

        return dailyReportResponseDto;

    }

    @Transactional(readOnly = true)
    public List<ReportResponseDto> getRecentReports(int n) {
        // 로그인 된 나의 정보를 가져온다
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long myMemberId = Long.parseLong(authentication.getName());

        List<Report> reportList = reportRepository.getRecentReportsByMemberIdLimit(myMemberId, n);

        List<ReportResponseDto> reportResponseDtoList = new ArrayList<>();

        for (Report report: reportList) {
            reportResponseDtoList.add(report.toReportResponseDto());
        }

        return reportResponseDtoList;

    }

    @Transactional(readOnly = true)
    public ReportScrollReponseDto getDailyReportsScroll(Long lastId, int pageSize) {
        // 로그인 된 나의 정보를 가져온다
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Long myMemberId = Long.parseLong(authentication.getName());

        Slice<ReportResponseDto> dailyReportResponseDtoSlice = reportRepository.findAll(lastId, pageSize, myMemberId);

        return new ReportScrollReponseDto(dailyReportResponseDtoSlice.getContent(), dailyReportResponseDtoSlice.hasNext());
    }

    @Transactional
    public void updateMemo(Long reportId, String memo) {
        Report report = reportRepository.findById(reportId).orElseThrow(ReportNotFoundException::new);
        report.updateMemo(memo);
    }

    @Transactional
    public void updateWater(Long reportId, int water) {
        Report report = reportRepository.findById(reportId).orElseThrow(ReportNotFoundException::new);
        report.updateWater(water);
    }

    @Transactional
    public void updateSleep(Long reportId, double sleep) {
        Report report = reportRepository.findById(reportId).orElseThrow(ReportNotFoundException::new);
        report.updateSleep(sleep);
    }

	public ReportResponseDto getReportById(Long reportId) {
        Report report = reportRepository.findById(reportId).orElseThrow(ReportNotFoundException::new);
        Long memberId = SecurityUtil.getCurrentMemberId();
        if(report.getMember().getId()!=memberId){

        }
        SkinTypeEnum skinTypeEnum = SkinTypeEnum.valueOf(report.getSkinType().toString());

        ReportResponseDto responseDto = report.toReportResponseDto();
        return responseDto;
	}
}

package com.msm.back.report.controller;

import com.msm.back.report.dto.*;
import com.msm.back.report.service.ReportService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.TimeZone;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/reports")
@Slf4j
public class ReportController {

    private final ReportService reportService;

    // 오늘의 피부 분석 리포트 가져오기
    @GetMapping("/daily")
    public ResponseEntity<ReportResponseDto> getDailyReport() {
        ReportResponseDto dailyReportResponseDto = reportService.getDailyReport();
        log.info(dailyReportResponseDto.toString());
        return ResponseEntity.ok(dailyReportResponseDto);
    }

    // 이번 주의 피부 분석 리포트 가져오기
    @GetMapping("/weekly")
    public ResponseEntity<ReportResponseDto[]> getWeeklyReport() {
        ReportResponseDto[] weeklyReport = reportService.getWeeklyReport();
        return ResponseEntity.ok(weeklyReport);
    }

    // 특정 날짜의 피부 분석 리포트 가져오기
    @GetMapping("")
    public ResponseEntity<ReportResponseDto> getReportByDate(@RequestParam("date") String date) {
        ReportResponseDto dailyReportResponseDto = reportService.getReportByDate(LocalDate.parse(date));
        return ResponseEntity.ok(dailyReportResponseDto);
    }

    // 사진 촬영 후 피부 분석 리포트 저장하기
    @PostMapping("")
    public ResponseEntity<ReportResponseDto> saveDailyReport(@RequestPart("file") MultipartFile multipartFile) {
        ReportResponseDto dailyReportResponseDto = reportService.saveReport(multipartFile);
        log.info("saveDailyReport testing");
        return ResponseEntity.status(HttpStatus.CREATED).body(dailyReportResponseDto);
    }

    // 최근 n개의 피부 분석 리포트 가져오기
    @GetMapping("/recent")
    public ResponseEntity<List<ReportResponseDto>> getRecentDailyReports(@RequestParam("number") int n) {
        List<ReportResponseDto> dailyReportResponseDtoList = reportService.getRecentReports(n);

        return ResponseEntity.ok(dailyReportResponseDtoList);
    }

    // 무한 스크롤로 가져오기
    @GetMapping("scroll")
    public ResponseEntity<ReportScrollReponseDto> getDailyReportsScroll(
        @RequestParam(value = "lastId", required = false) Long lastId, @RequestParam("pageSize") int pageSize) {
        ReportScrollReponseDto dailyReportScrollResponseDto = reportService.getDailyReportsScroll(lastId, pageSize);

        return ResponseEntity.ok(dailyReportScrollResponseDto);
    }

    // 물 업데이트
    @PutMapping("/water/{memberId}")
    public ResponseEntity<Void> updateWater(@PathVariable Long memberId,
        @RequestBody ReportUpdateWaterRequestDto reportUpdateWaterRequestDto) {
        Long reportId = reportUpdateWaterRequestDto.getReportId();
        int water = reportUpdateWaterRequestDto.getWater();
        reportService.updateWater(reportId, water);

        return ResponseEntity.ok().build();
    }

    // 수면 시간 업데이트
    @PutMapping("/sleep/{memberId}")
    public ResponseEntity<Void> updateSleep(@PathVariable Long memberId,
        @RequestBody ReportUpdateSleepRequestDto reportUpdateSleepRequestDto) {
        Long reportId = reportUpdateSleepRequestDto.getReportId();
        double sleep = reportUpdateSleepRequestDto.getSleep();
        reportService.updateSleep(reportId, sleep);

        return ResponseEntity.ok().build();
    }

    // 메모 업데이트
    @PutMapping("/memo/{memberId}")
    public ResponseEntity<Void> updateMemo(@PathVariable Long memberId,
        @RequestBody ReportUpdateMemoRequestDto reportUpdateMemoRequestDto) {
        Long reportId = reportUpdateMemoRequestDto.getReportId();
        String memo = reportUpdateMemoRequestDto.getMemo();
        reportService.updateMemo(reportId, memo);

        return ResponseEntity.ok().build();
    }

    @GetMapping("/{reportId}")
    public ResponseEntity<ReportResponseDto> getReport(@PathVariable Long reportId) {
        ReportResponseDto report = reportService.getReportById(reportId);
        System.out.println(report.getDate());
        System.out.println("================================================================");
        LocalDate localDate = LocalDate.now();
        System.out.println("localDate = " + localDate);
        System.out.println("TimeZone: "+TimeZone.getDefault().getID());

        System.out.println("================================================================");
        return ResponseEntity.ok(report);
    }
}

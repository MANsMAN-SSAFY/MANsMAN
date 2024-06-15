package com.msm.back.mask.controller;

import com.msm.back.exception.MaskRecordAlreadyExistsException;
import com.msm.back.mask.dto.MaskRequestDto;
import com.msm.back.mask.dto.MaskResponseDto;
import com.msm.back.mask.service.MaskService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/masks")
@Slf4j
public class MaskController {

    private final MaskService maskService;
    @PostMapping("")
    public ResponseEntity<MaskResponseDto> recordMask(@RequestBody MaskRequestDto maskRequestDto) {
        MaskResponseDto maskResponseDto = maskService.recordMask(maskRequestDto);
        System.out.println("maskResponseDto = " + maskResponseDto);
        if (maskResponseDto == null) {
            throw new MaskRecordAlreadyExistsException("이미 해당 날짜에 마스크 사용 기록이 있습니다");
        }

        return ResponseEntity.status(HttpStatus.CREATED).body(maskResponseDto);
    }

    @GetMapping("")
    public ResponseEntity<List<MaskResponseDto>> getRecordsInMonth(@RequestParam("date") String date) {
     String[] parts = date.split("-");
     int year = Integer.parseInt(parts[0]);
     int month = Integer.parseInt(parts[1]);

     List<MaskResponseDto> maskResponseDtoList = maskService.getRecordsInMonth(month, year);
     log.info(maskResponseDtoList.toString());
     return ResponseEntity.ok(maskResponseDtoList);
    }
}

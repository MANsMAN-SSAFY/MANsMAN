package com.msm.back.exception;

public class ReportNotFoundException extends RuntimeException {
    public ReportNotFoundException() {
        super("해당 id를 지닌 피부 분석 리포트는 존재하지 않습니다");
    }
}

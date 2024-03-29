package com.msm.back.exception;

public class DiaryNotFoundException extends RuntimeException{
    public DiaryNotFoundException() {
        super("해당 날짜의 피부 일기 또는 해당 id를 지닌 피부일기가 존재하지 않습니다");
    }
}

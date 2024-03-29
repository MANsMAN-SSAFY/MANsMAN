package com.msm.back.exception;

public class DiaryAlreadyExistsException extends RuntimeException{
    public DiaryAlreadyExistsException() {
        super("이미 오늘 피부 일기를 작성하셨습니다.");
    }
}

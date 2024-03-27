package com.msm.back.exception;

public class MemberNotFoundException extends RuntimeException {
    public MemberNotFoundException() {
        super("회원 정보를 찾을 수 없습니다.");
        System.out.println("33333333333333333333333333333");
    }
}

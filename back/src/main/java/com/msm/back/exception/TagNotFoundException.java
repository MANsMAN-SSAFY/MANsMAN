package com.msm.back.exception;

public class TagNotFoundException extends RuntimeException{
    public TagNotFoundException() {
        super("해당 id를 지닌 태그가 존재하지 않습니다");
    }
}

package com.msm.back.exception;

public class UserLogoutException extends RuntimeException {
    public UserLogoutException(String message) {
        super(message);
    }
}
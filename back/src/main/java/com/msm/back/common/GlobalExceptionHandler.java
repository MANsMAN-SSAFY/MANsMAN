package com.msm.back.common;

import com.msm.back.db.entity.Comment;
import com.msm.back.exception.*;
import lombok.Getter;
import org.apache.http.protocol.HTTP;
import org.hibernate.Internal;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@Getter
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(EmailAlreadyExistsException.class)
    public ResponseEntity<String> handleEmailAlreadyExists(EmailAlreadyExistsException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.CONFLICT);
    }

    @ExceptionHandler(MemberNotFoundException.class)
    public ResponseEntity<String> handleMemberNotFound(MemberNotFoundException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(FileUploadException.class)
    public ResponseEntity<String> handleFileUploadError(FileUploadException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(ProductNotFoundException.class)
    public ResponseEntity<String> handleProductNotFound(ProductNotFoundException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(InvalidTokenException.class)
    public ResponseEntity<String> handleInvalidTokenException(InvalidTokenException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.UNAUTHORIZED);
    }

    @ExceptionHandler(UserLogoutException.class)
    public ResponseEntity<String> handleUserLogoutException(UserLogoutException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.FORBIDDEN);
    }

    @ExceptionHandler(CustomAuthenticationException.class)
    public ResponseEntity<String> handleCustomAuthenticationException(CustomAuthenticationException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.UNAUTHORIZED);
    }


    @ExceptionHandler(MaskRecordAlreadyExistsException.class)
    public ResponseEntity<String> handleMaskRecordAlreadyExistsException(MaskRecordAlreadyExistsException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
    }
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<String> handleMethodArgumentNotValid(MethodArgumentNotValidException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(CustomException.class)
    public ResponseEntity<String> handleCustomException(CustomException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR); // 500 Internal Server Error
    }
    @ExceptionHandler(BoardNotFoundException.class)
    public ResponseEntity<String> handleBoardNotFoundException(BoardNotFoundException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
    }
    @ExceptionHandler(CommentNotFoundException.class)
    public ResponseEntity<String> handleCommentNotFoundException(CommentNotFoundException e) {
        return new ResponseEntity<>(e.getMessage(), HttpStatus.NOT_FOUND);
    }
}



//    200	OK	                            성공
//    201	Created	                        생성됨
//    202	Accepted	                    허용됨
//    203	Non-Authoritative Information	신뢰할 수 없는 정보
//    204	No Content	                    콘텐츠 없음
//    205	Reset Content	                콘텐츠 재설정
//    206	Partial Content	                일부 콘텐츠
//    207	Multi-Status	                다중 상태

//    400	Bad Request	                    잘못된 요청
//    401	Unauthorized	                권한 없음
//    402	Payment Required	            결제 필요
//    403	Forbidden	                    금지됨
//    404	Not Found	                    찾을 수 없음
//    405	Method Not Allowed	            허용되지 않은 메소드
//    406	Not Acceptable	                수용할 수 없음
//    407	Proxy Authentication Required	프록시 인증 필요
//    408	Request Timeout	                요청 시간초과
//    409	Conflict	                    충돌

//    500	Internal Server Error	        내부 서버 오류
//    501	Not Implemented	                구현되지 않음
//    502	Bad Gateway	                    불량 게이트웨이
//    503	Service Unavailable	            서비스 제공불가
//    504	Gateway Timeout	                게이트웨이 시간초과
//    505	HTTP Version Not Supported	    HTTP 버전 미지원

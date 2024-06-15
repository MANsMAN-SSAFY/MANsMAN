// 이메일 유효성 검사
String? validateEmail(String value){
  if (value.isEmpty) {
    // 이메일을 입력하지 않음
    return '이메일을 입력하세요';
  } else {
    // 이메일을 입력함
    // 이메일 형식이 정규 표현식인지 검사
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // regExp 정규 표현식 객체 : 문자열이 특정 패턴과 일치하는 지 검사
    RegExp regExp = RegExp(pattern);
    // 정규식과 일치하는 지 검사
    if (!regExp.hasMatch(value)) {
      return '잘못된 이메일 형식입니다.';
    } else {
      // null을 반환하면 정상
      return null;
    }
  }
}

// 비밀번호 유효성 검사
String? validatePassword(String value) {
  String pattern =
      r'^(?=.*[a-zA-z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{8,20}$';
  RegExp regExp = RegExp(pattern);

  if (value.isEmpty) {
    return '비밀번호를 입력하세요';
  } else if (value.length < 8) {
    return '비밀번호는 8자리 이상이어야 합니다';
  } else if (!regExp.hasMatch(value)) {
    return '특수문자, 문자, 숫자 포함 8자 이상 20자 이내로 입력하세요.';
  } else {
    return null; //null을 반환하면 정상
  }
}
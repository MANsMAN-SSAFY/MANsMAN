
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

class User extends ChangeNotifier {
  // 사용자 정보와 토큰 정보를 별도의 변수로 선언
  DateTime? _accessTokenExpiresIn;
  Map<String, dynamic>? _profile;

  // 외부에서 접근 가능한 getter 메서드
  DateTime? get accessTokenExpiresIn => _accessTokenExpiresIn;
  Map<String, dynamic>? get profile => _profile;

  // 사용자 정보와 토큰 정보를 업데이트하는 메서드
  void updateUser(Map<String, dynamic> tokenResponseDto, Map<String, dynamic> profileResponseDto) {
    if (tokenResponseDto.containsKey('accessTokenExpiresIn')) {
      // Unix timestamp를 DateTime 객체로 변환
      _accessTokenExpiresIn = DateTime.fromMillisecondsSinceEpoch(tokenResponseDto['accessTokenExpiresIn']);
    }
    _profile = profileResponseDto;

    // 변경사항을 리스너에게 알림
    notifyListeners();
  }

  void updatePrivacy(bool newValue) {
    if (_profile != null) {
      _profile!['privacy'] = newValue;
      notifyListeners();
    }
  }

  void updateNickname(String newValue) {
    if (_profile != null) {
      _profile!['nickname'] = newValue;
      notifyListeners();
    }
  }

  void updateimgUrl(String newValue) {
    if (_profile != null) {
      _profile!['imgUrl'] = newValue;
      notifyListeners();
    }
  }

  String getNickname() {
    // _profile이 null이 아니고, nickname 키가 존재한다면 그 값을 반환하고, 아니라면 빈 문자열을 반환합니다.
    return _profile?['nickname'] ?? '';
  }
}
class UserModel {
  final String grantType;
  final String accessToken;
  final String refreshToken;
  final int accessTokenExpiresIn;
  final int id;
  final String email;
  final String nickname;
  final String? birthday;
  final String? imgUrl;
  final bool privacy;
  final String? report;

  UserModel({
    required this.grantType,
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpiresIn,
    required this.id,
    required this.email,
    required this.nickname,
    this.birthday,
    this.imgUrl,
    required this.privacy,
    this.report,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final tokenResponse = json['tokenResponseDto'];
    final profileResponse = json['profileResponseDto'];
    return UserModel(
      grantType: tokenResponse['grantType'],
      accessToken: tokenResponse['accessToken'],
      refreshToken: tokenResponse['refreshToken'],
      accessTokenExpiresIn: tokenResponse['accessTokenExpiresIn'],
      id: profileResponse['id'],
      email: profileResponse['email'],
      nickname: profileResponse['nickname'],
      birthday: profileResponse['birthday'],
      imgUrl: profileResponse['imgUrl'],
      privacy: profileResponse['privacy'],
      report: profileResponse['report'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tokenResponseDto': {
        'grantType': grantType,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'accessTokenExpiresIn': accessTokenExpiresIn,
      },
      'profileResponseDto': {
        'id': id,
        'email': email,
        'nickname': nickname,
        'birthday': birthday,
        'imgUrl': imgUrl,
        'privacy': privacy,
        'report': report,
      },
    };
  }
}

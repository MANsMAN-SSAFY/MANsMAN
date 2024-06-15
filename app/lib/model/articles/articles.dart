class Articles {
  int id;
  String title;
  String content;
  int viewCnt;
  int commentCnt;
  int likeCnt;
  Writer writer;
  List<BoardImageList> boaredImageList;
  DateTime createdAt;
  DateTime updatedAt;

  Articles({
    required this.id,
    required this.title,
    required this.content,
    required this.viewCnt,
    required this.commentCnt,
    required this.likeCnt,
    required this.writer,
    required this.boaredImageList,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Articles.fromJson(Map<String, dynamic> json) {
    return Articles(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      viewCnt: json['viewCnt'],
      commentCnt: json['commentCnt'],
      likeCnt: json['likeCnt'],
      writer: Writer.fromJson(json['writer']),
      boaredImageList: (json['boaredImageList'] as List<dynamic>?)
              ?.map(
                (e) => BoardImageList.fromJson(e),
              )
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class BoardImageList {
  String boardImgUrl;
  int displayOrder;

  BoardImageList({
    required this.boardImgUrl,
    required this.displayOrder,
  });

  factory BoardImageList.fromJson(Map<String, dynamic> json) {
    return BoardImageList(
      boardImgUrl: json['boardImgUrl'],
      displayOrder: json['displayOrder'],
    );
  }
}

class Writer {
  String email;
  String nickname;
  DateTime birthday;
  String? imgUrl;
  bool privacy;
  Report? report;

  Writer({
    required this.email,
    required this.nickname,
    required this.birthday,
    required this.imgUrl,
    required this.privacy,
    required this.report,
  });

  factory Writer.fromJson(Map<String, dynamic> json) {
    return Writer(
      email: json['email'],
      nickname: json['nickname'],
      birthday: DateTime.parse(json['birthday']),
      imgUrl: json['imgUrl'],
      privacy: json['privacy'],
      report: json['report'] != null ? Report.fromJson(json['report']) : null,
    );
  }
}

class Report {
  int acne;
  int wrinkle;
  // int blackhead;
  int age;
  String skinType;
  String faceShape;

  Report({
    required this.acne,
    required this.wrinkle,
    // required this.blackhead,
    required this.age,
    required this.skinType,
    required this.faceShape,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      acne: json['acne'],
      wrinkle: json['wrinkle'],
      // blackhead: json['blackhead'],
      age: json['age'],
      skinType: json['skinType'],
      faceShape: json['faceShape'],
    );
  }
}

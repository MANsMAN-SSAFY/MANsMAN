import 'package:app/common/dio/dio.dart';

import '../../store/user.dart';

class SimilarModel {
  final int id;
  final String name;
  final String img_url;
  final String linkUrl;
  final String brand;
  final double avg_rating;
  final bool favorite;
  final String price;
  final String capacity;
  final int cnt_rating;

  SimilarModel({
    required this.id,
    required this.name,
    required this.img_url,
    required this.brand,
    required this.avg_rating,
    required this.favorite,
    required this.price,
    required this.capacity,
    required this.cnt_rating,
    required this.linkUrl,
  });

  factory SimilarModel.fromJson({
    required Map<String, dynamic> json,
  }){
    return SimilarModel(
      id: json['id'],
      name: json['name'],
      img_url: json['img_url'],
      brand: json['brand'],
      avg_rating: json['avg_rating'].toDouble(), // 명시적으로 double로 변환
      favorite: json['favorite'],
      price: json['price'].toString(), // JSON에서 정수나 실수 형태로 오더라도 문자열로 변환
      capacity: json['capacity'],
      cnt_rating: json['cnt_rating'],
      linkUrl: json['linkUrl'] ?? '', // 널일 경우 빈 문자열로 대체
    );
  }
}

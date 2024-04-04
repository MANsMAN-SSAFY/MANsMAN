import 'package:app/common/dio/dio.dart';
import 'package:app/model/cosmetics/cosmetics_model.dart';

class CosmeticsDetailModel {
  final int id;
  final String name;
  final String imgUrl;
  final int price;
  final double avgRating;
  final int cntRating;
  final String capacity;
  final String mainPoint; // 피부 타입
  final String useDate; // 사용기한
  final String material;
  final String linkUrl;
  final bool favorite; // 사용 방법
  final List<String> imgList; // 이미지 상세설명
  CosmeticsDetailModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.avgRating,
    required this.cntRating,
    required this.capacity,
    required this.favorite,
    required this.mainPoint,
    required this.useDate,
    required this.material,
    required this.imgList,
    required this.price,
    required this.linkUrl,
  });
  factory CosmeticsDetailModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return CosmeticsDetailModel(
      id: json['id'],
      name: json['name'],
      imgUrl: '${json['imgUrl']}',
      avgRating: json['avgRating'],
      favorite: json['favorite'],
      capacity: json['capacity'],
      cntRating: json['cntRating'],
      mainPoint: json['mainPoint'],
      useDate: json['useDate'],
      material: json['material'],
      imgList: List<String>.from(json['imgList']),
      price: json['price'],
      linkUrl: json['linkUrl'],
    );
  }
}

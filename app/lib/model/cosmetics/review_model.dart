import 'package:app/common/dio/dio.dart';

import '../../store/user.dart';

class ReviewModel {
  final int id;
  final String name;
  final String imgUrl;
  final String brand;
  final String category;
  final int price;
  final int cnt;
  final double rating;
  final String review;
  final bool privacy;
  final bool active;

  ReviewModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.brand,
    required this.category,
    required this.cnt,
    required this.price,
    required this.rating,
    required this.review,
    required this.privacy,
    required this.active,
  });

  factory ReviewModel.fromJson({
    required Map<String, dynamic> json,
  }) {
    return ReviewModel(
        id: json['id'],
        name: json['name'],
        imgUrl: json['imgUrl'],
        brand: json['brand'],
        price: json['price'],
        category: json['category'],
        rating: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
        cnt: json['cnt'],
        review: json['review'] ?? '',
        privacy: json['privacy'],
        active: json['active']);
  }
}

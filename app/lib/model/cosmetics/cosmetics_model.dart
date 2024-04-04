import 'package:app/common/dio/dio.dart';

import '../../store/user.dart';

class CosmeticsModel {
  final int id;
  final String name;
  final String img_url;
  final String brand;
  final double avg_rating;
  final bool favorite;
  final int price;
  final String capacity;
  final int cnt_rating;

  CosmeticsModel({
    required this.id,
    required this.name,
    required this.img_url,
    required this.brand,
    required this.avg_rating,
    required this.favorite,
    required this.price,
    required this.capacity,
    required this.cnt_rating,
  });

  factory CosmeticsModel.fromJson({
    required Map<String, dynamic> json,
}){
    return CosmeticsModel(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? 'default-name',
        img_url: '${json['img_url']}' as String? ?? 'default-img-url',
        brand: json['brand'] as String? ?? 'default-brand',
        avg_rating: json['avg_rating'] as double? ?? 0,
        favorite: json['favorite'] as bool? ?? false,
        price: json['price'] as int? ?? 0,
        capacity: json['capacity'] as String? ?? 'default-capacity',
        cnt_rating: json['cnt_rating'] as int? ?? 0,
    );
  }
}

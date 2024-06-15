import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:app/model/cosmetics/cosmetics_model.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:intl/intl.dart';

class CosmeticsCard extends StatefulWidget {
  final int id;
  final Widget image;
  final String name;
  final String brand;
  final double avgRating;
  final int cntRating;
  final bool favorite;
  final int price;
  final String capacity;
  final Function(int, bool)? onFavoriteToggle;

  const CosmeticsCard({
    super.key,
    required this.image,
    required this.name,
    required this.brand,
    required this.avgRating,
    required this.favorite,
    required this.price,
    required this.capacity,
    required this.id,
    required this.cntRating,
    this.onFavoriteToggle,
  });

  factory CosmeticsCard.fromModel({
    required CosmeticsModel model,
    Function(int, bool)? onFavoriteToggle,
    ValueKey? key,
    bool? favorite,
  }) {
    return CosmeticsCard(
      image: Image.network(model.img_url, height: 120, width: 120),
      name: model.name,
      brand: model.brand,
      avgRating: model.avg_rating,
      favorite: model.favorite,
      price: model.price,
      capacity: model.capacity,
      cntRating: model.cnt_rating,
      id: model.id,
      onFavoriteToggle: onFavoriteToggle,
    );
  }

  @override
  State<CosmeticsCard> createState() => _CosmeticsCardState();
}

class _CosmeticsCardState extends State<CosmeticsCard> {
  late bool favorite;

  @override
  void initState() {
    super.initState();
    favorite = widget.favorite; // 초기 즐겨찾기 상태 설정
  }

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat('#,###', 'en_US').format(widget.price);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(children: [
        SizedBox(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14.0),
            child: widget.image,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.brand,
                  style: AppTexts.body5
                      .copyWith(color: AppColors.iconBlack.withOpacity(0.8))),
              const SizedBox(height: 2),
              Text(widget.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTexts.body4.copyWith(color: AppColors.black)),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text(widget.avgRating.toStringAsFixed(2),
                      style: AppTexts.body4),
                  Text(' (${widget.cntRating})',
                      style: AppTexts.body4.copyWith(
                          color: AppColors.iconBlack.withOpacity(0.8))),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Text('${formattedPrice} 원', style: AppTexts.body4),
                  const SizedBox(width: 1),
                  Text(widget.capacity.length > 5 ? ' / ${widget.capacity.substring(0, 5)}...' :'/ ${widget.capacity}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTexts.body4.copyWith(
                          color: AppColors.iconBlack.withOpacity(0.8))),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: widget.favorite ? AppIcons.full_favorites : AppIcons.favorites,
          onPressed: () async {
            final dio = Dio();
            final storage = FlutterSecureStorage();
            final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
            final productId = widget.id;
            bool newFavoriteStatus = !widget.favorite;

            try {
              if (widget.favorite) {
                await dio.delete(
                  'https://j10e106.p.ssafy.io/api/products/$productId/favorites',
                  options: Options(
                      headers: {'Authorization': 'Bearer $accessToken'}),
                );
              } else {
                await dio.post(
                  'https://j10e106.p.ssafy.io/api/products/$productId/favorites',
                  options: Options(
                      headers: {'Authorization': 'Bearer $accessToken'}),
                );
              }
              if (widget.onFavoriteToggle != null) {
                widget.onFavoriteToggle!(productId, newFavoriteStatus);
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text(newFavoriteStatus ? '즐겨찾기 등록 성공' : '즐겨찾기 취소 성공')));
            } on DioException catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content:
                      Text('즐겨찾기 변경 실패: ${e.response?.data ?? e.message}')));
            }
          },
        ),
      ]),
    );
  }
}

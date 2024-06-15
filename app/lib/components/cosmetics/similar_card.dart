import 'package:app/common/style/app_texts.dart';
import 'package:app/model/cosmetics/similar_model.dart';
import 'package:flutter/material.dart';

class SimilarCard extends StatelessWidget {
  final Widget image;
  final String name;
  final String price;
  final double avg_rating;
  const SimilarCard(
      {super.key,
      required this.image,
      required this.name,
      required this.price,
      required this.avg_rating});

  factory SimilarCard.fromModel({
    required SimilarModel model,
  }) {
    return SimilarCard(
      image: Image.network(
        height: 100,
        width: 100,
        model.img_url,
      ),
      name: model.name,
      price: model.price,
      avg_rating: model.avg_rating,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.0),
              child: image,
            ),
          ),
          SizedBox(height: 8.0,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.length > 10 ? '${name.substring(0, 10)}...' : name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTexts.body6,),
              Text('$price 원', style: AppTexts.body4,),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber,),
                  Text(avg_rating.toString(), style: AppTexts.body5,),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }
}

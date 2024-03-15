import 'package:flutter/material.dart';

class CosmeticItem extends StatelessWidget {
  const CosmeticItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          '',
          width:100,
          height:100,),
        SizedBox(
          child: Text('화장품이름'),
        )
      ],
    );
  }
}

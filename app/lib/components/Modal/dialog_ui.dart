import 'package:app/store/diary/hash_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

class DialogUI extends StatefulWidget {
  const DialogUI({super.key});

  @override
  State<DialogUI> createState() => _DialogUIState();
}

class _DialogUIState extends State<DialogUI>
    with AutomaticKeepAliveClientMixin<DialogUI> {
  Color _color = Colors.blue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin의 build 메서드를 호출

    return Dialog(
      child: Container(
        width: double.infinity,
        height: 420,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Text(
              "해시태그 추가하기",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                labelText: "내용",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ColorPicker(
              pickerAreaHeightPercent: 0.4,
              pickerColor: _color,
              labelTypes: const [],
              onColorChanged: (Color color) {
                setState(
                  () {
                    _color = color;
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text('완료'),
                  onPressed: () {
                    String newTag = textEditingController.text.trim();
                    context.read<HashTag>().addTag(
                      {'tag': newTag, 'color': _color},
                    );
                    Navigator.pop(context);
                    // print(_color);
                  },
                ),
                TextButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            )
          ],
        ),
      ),
    );
  }
}

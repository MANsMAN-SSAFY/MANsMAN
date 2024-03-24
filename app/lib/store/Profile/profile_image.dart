import 'package:app/utils/imagePicking.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends ChangeNotifier{
  String? imagePath;
  pickImage(ImageSource source) async {
    try{
      final path = ImagePicking.pickImage(source);
      final croppedImage =  await ImagePicking.cropImage(path as String);

      imagePath = croppedImage?.path ?? '';
      notifyListeners();
    }catch(e){print(e);}
  }
}
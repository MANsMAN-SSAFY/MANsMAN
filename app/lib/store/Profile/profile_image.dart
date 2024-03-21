import 'package:app/utils/imagePicking.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends ChangeNotifier{
  pickImage(ImageSource source) {
    try{
      final path = ImagePicking.pickImage(source);
      print(path);

    }catch(e){print(e);}
  }
}
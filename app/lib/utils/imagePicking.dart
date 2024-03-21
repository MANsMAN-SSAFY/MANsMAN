import 'package:image_picker/image_picker.dart';

class ImagePicking {

  static Future<String> pickImage(ImageSource source) async {
    try{
      final picker = ImagePicker();
      final image = await picker.pickImage(source: source);
      return image?.path ?? '';
    } catch(e){
      return '';
    }
  }
}
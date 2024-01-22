import 'package:image_picker/image_picker.dart';

// Imagepicker käyttö, palautetaan Uint8List file kuvasta

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(
    source: source,
    maxWidth: 500,
    maxHeight: 500,
  );
  if (file != null) {
    return await file.readAsBytes();
  }
}

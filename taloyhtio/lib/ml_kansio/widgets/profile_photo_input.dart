import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

//Firebasesta nykyisen käyttäjän tiedot. Haku initStatessa, jotta ei näy vahingossa
//edeltävän käyttäjän kuva.
User? user;
String? uId;

class ProfilePhotoInput extends StatefulWidget {
  const ProfilePhotoInput({
    super.key,
  });

  @override
  State<ProfilePhotoInput> createState() => _ProfilePhotoInputState();
}

class _ProfilePhotoInputState extends State<ProfilePhotoInput> {
  //File? _selectedImage;
  late String imageUrl;
  final storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    uId = user!.uid;
    imageUrl = '';
    getImageUrl();
  }

  Future<void> getImageUrl() async {
    final ref = storage.ref().child('user_images/$uId.jpg');

    final url = await ref.getDownloadURL();

    setState(() {
      imageUrl = url;
    });
  }

  //KUVA KAMERALLA
  void _takeAPhoto() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 100,
      maxWidth: 100,
    );

    //jos käyttäjältä ei saada kuvaa
    if (pickedImage == null) {
      return;
    }

/*     setState(() {
      _selectedImage = File(pickedImage.path);
    }); */

    //KUVAN TALLENNUS
    final storageRef =
        FirebaseStorage.instance //viittaus, tuleva tallennussijainti
            .ref()
            .child('user_images')
            .child('$uId.jpg');
    //kuvatiedoston varsinainen tallennus
    await storageRef.putFile(File(pickedImage.path));
    final url =
        await storageRef.getDownloadURL(); //url, josta kuva voidaan ladata

    setState(() {
      imageUrl = url;
    });
  }

//KUVA GALLERIASTA
  void _uploadAPhoto() async {
    final uploadPic = ImagePicker();
    final uploadedPic = await uploadPic.pickImage(
      source: ImageSource.gallery,
    );

    if (uploadedPic == null) {
      return;
    }

/*     setState(() {
      _selectedImage = File(uploadedPic.path);
    }); */

    //KUVAN TALLENNUS
    final storageRef =
        FirebaseStorage.instance //viittaus, tuleva tallennussijainti
            .ref()
            .child('user_images')
            .child('$uId.jpg');
    //kuvatiedoston varsinainen tallennus
    await storageRef.putFile(File(uploadedPic.path));
    final url =
        await storageRef.getDownloadURL(); //url, josta kuva voidaan ladata

    setState(() {
      imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const CircularProgressIndicator();

//homma näkyy, kun kuva on valittu
    if (imageUrl.isNotEmpty) {
      content = GestureDetector(
        onTap: _takeAPhoto,
        child: ClipOval(
          clipBehavior: Clip.hardEdge,
          child: Image.network(
            alignment: Alignment.center,
            imageUrl,
            fit: BoxFit.fill,
            height: 100,
            width: 100,
          ),
        ),
      );
    }
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ),
          height: 100,
          width: 100,
          child: content,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              onPressed: _takeAPhoto,
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Ota uusi kuva'),
            ),
            TextButton.icon(
              onPressed: _uploadAPhoto,
              icon: const Icon(Icons.upload_outlined),
              label: const Text('Lataa kuva laitteeltasi'),
            ),
          ],
        ),
      ],
    );
  }
}

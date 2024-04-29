//widgetti, joka hakee ja lisää heippalappujen postittajien profiilikuvan heippalapun yhteyteen
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PhotoDelivery extends StatefulWidget {
  const PhotoDelivery({super.key, required this.uId});

  final String uId;

  @override
  State<PhotoDelivery> createState() => _PhotoDeliveryState();
}

class _PhotoDeliveryState extends State<PhotoDelivery> {
  bool isLoading = false;
  late String imageUrl;
  @override
  void initState() {
    super.initState();

    var pUid = widget.uId;
    //kuvan lisäys heippalappuun
    imageUrl = '';
    getImageUrl(pUid);
  }

//kuvan lisäys heippalappuun
  Future<void> getImageUrl(pUid) async {
    //KUVAN haku
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final storageRef =
        FirebaseStorage.instance //viittaus, tuleva tallennussijainti
            .ref()
            .child('user_images')
            .child('$pUid.jpg');
    final url = await storageRef.getDownloadURL();

    if (mounted) {
      imageUrl = url;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget photoContent = const CircularProgressIndicator();
    if (imageUrl.isNotEmpty) {
      photoContent = ClipOval(
        clipBehavior: Clip.hardEdge,
        child: Image.network(
          //errorbuilder lisätty, jotta vältetään error, joka ilmeni
          //kuvan vaihtamisen jälkeen (omat tiedot) siirryttäessä heippalappuihin
          errorBuilder: (context, error, stackTrace) {
            return const CircularProgressIndicator();
          },
          alignment: Alignment.center,
          imageUrl,
          fit: BoxFit.fitWidth,
          height: 35,
          width: 35,
        ),
      );
    }

    return photoContent;
  }
}

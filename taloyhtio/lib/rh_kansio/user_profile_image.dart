import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfileImage extends StatefulWidget {
  const UserProfileImage({super.key});

  @override
  UserProfileImageState createState() => UserProfileImageState();
}

class UserProfileImageState extends State<UserProfileImage> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchImageUrl();
  }

  void _fetchImageUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseStorage.instance.ref('user_images/${user.uid}.jpg');

      final url = await ref.getDownloadURL();
      if (mounted) {
        setState(() {
          imageUrl = url;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Näytä latausindikaattori, jos imageUrl on null
    if (imageUrl == null) {
      return const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        child: CircularProgressIndicator(
          color: Colors.black,
          backgroundColor: Colors.white,
          strokeWidth: 5,
        ),
      );
    }

    // Näytä kuva, jos imageUrl ei ole null
    return Container(
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(20),
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: Colors.blueGrey[600]!,
        ),
      ),
      height: 100,
      width: 100,
      child: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl!),
        radius: 50,
        backgroundColor: Colors.white,
      ),
    );
  }
}

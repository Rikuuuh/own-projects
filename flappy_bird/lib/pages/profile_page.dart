import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flappy_bird_game/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_game/auth.dart';

import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.camera);
    setState(() {
      _image = img;
    });
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign out'),
    );
  }

  Widget _addImage() {
    return Stack(
      children: [
        _image != null
            ? CircleAvatar(
                radius: 64,
                backgroundImage: MemoryImage(_image!),
              )
            : const CircleAvatar(
                radius: 65,
                backgroundImage: AssetImage('assets/images/user.png'),
              ),
        Positioned(
          top: -14,
          left: 95,
          child: IconButton(
            color: Colors.white,
            onPressed: selectImage,
            icon: const Icon(Icons.add_a_photo),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _addImage(),
          _userUid(),
          _signOutButton(),
        ],
      ),
    );
  }
}

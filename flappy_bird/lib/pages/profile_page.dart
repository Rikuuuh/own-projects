import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flappy_bird_game/auth/get_user_name.dart';
import 'package:flappy_bird_game/main_drawer.dart';

import 'package:flutter/material.dart';
import 'package:flappy_bird_game/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  // Document ID's
  List<String> docIDs = [];

  // get docID's
  Future getDocId() async {
    await FirebaseFirestore.instance.collection('users').get().then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              docIDs.add(document.reference.id);
            },
          ),
        );
  }

  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.camera);
    setState(() {
      _image = img;
    });
  }

  Future<void> saveProfile() async {
    if (_image != null && user != null) {
      String filePath = 'user_profiles/${user?.uid}/profile.jpg';
      var storageRef = FirebaseStorage.instance.ref().child(filePath);
      await storageRef.putData(_image!);

      String downloadURL = await storageRef.getDownloadURL();

      await user?.updatePhotoURL(downloadURL);
    }
  }

  Widget _addImage() {
    return Stack(
      children: [
        if (user?.photoURL != null)
          CircleAvatar(
            backgroundImage: NetworkImage(user!.photoURL!),
            radius: 64,
          )
        else
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/user.png'),
            radius: 64,
          ),
        Positioned(
          top: -14,
          left: 95,
          child: IconButton(
            color: Colors.deepPurple,
            onPressed: selectImage,
            icon: const Icon(Icons.add_a_photo),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(user!.email!),
          actions: [
            GestureDetector(
              onTap: () => FirebaseAuth.instance.signOut(),
              child: const Icon(Icons.logout, color: Colors.deepPurple),
            ),
          ],
        ),
        drawer: const MainDrawer(),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _addImage(),
              ElevatedButton(
                onPressed: saveProfile,
                child: const Text('Save profile'),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getDocId(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: GetUserName(documentId: docIDs[index]),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

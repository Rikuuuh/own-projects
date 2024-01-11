import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flappy_bird_game/auth/pick_image.dart';
import 'package:flappy_bird_game/components/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  Uint8List? _image;

  Future<Uint8List?> selectImage() async {
    Uint8List? img = await pickImage(ImageSource.camera);
    return img;
  }

  Future<String> saveProfileImage(User user) async {
    String downloadURL = '';
    if (_image != null) {
      String filePath = 'user_profiles/${user.uid}/profile.jpg';
      var storageRef = FirebaseStorage.instance.ref().child(filePath);
      await storageRef.putData(_image!);
      downloadURL = await storageRef.getDownloadURL();
      await user.updatePhotoURL(downloadURL);
    }
    return downloadURL;
  }

  Future<void> updateProfileImage() async {
    Uint8List? img = await selectImage();
    if (img != null) {
      setState(() {
        _image = img;
      });

      // Tallenna kuva Firebase Storageen
      String downloadURL =
          await saveProfileImage(FirebaseAuth.instance.currentUser!);
      // Päivitä imageUrl Firebase Firestoren users-taulussa
      await usersCollection.doc(userId).update({'imageUrl': downloadURL});
      await FirebaseAuth.instance.currentUser!.reload();
      setState(() {
        currentUser = FirebaseAuth.instance.currentUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        foregroundColor: Colors.orange,
        centerTitle: true,
        title: const Text(
          'Oma Profiili',
          style: TextStyle(fontSize: 22, color: Colors.orange),
        ),
      ),
      drawer: const MainDrawer(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          if (snapshot.hasData && snapshot.data!.data() != null) {
            return ListView(
              children: [
                const SizedBox(height: 20),
                ClipOval(
                  child: Image.network(
                    currentUser!.photoURL!,
                    fit: BoxFit.contain,
                    height: 270,
                    width: 270,
                  ),
                ),
                TextButton.icon(
                  onPressed: updateProfileImage,
                  icon: const Icon(
                    Icons.add_a_photo,
                    color: Colors.orange,
                  ),
                  label: const Text(
                    'Vaihda kuvasi',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  currentUser!.email!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Omat tietoni',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Etunimi',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        userData!['first name'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Sukunimi',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(userData['last name'],
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 20),
                      Text(
                        'Sähköposti',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        userData['email'],
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Olympic Bird - Yrityksiä jäljellä',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(userData['attempts left'].toString(),
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error${snapshot.error}'),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flappy_bird_game/auth/pick_image.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.showLoginPage});
  final void Function() showLoginPage;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text  controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _isImageAdded = false;
  String _errorMessage = '';

  User? user = FirebaseAuth.instance.currentUser;

  Uint8List? _image;

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.camera);
    if (img != null) {
      setState(() {
        _image = img;
        _isImageAdded = true;
      });
    }
  }

  Future<void> saveProfileImage(User user) async {
    if (_image != null) {
      String filePath = 'user_profiles/${user.uid}/profile.jpg';
      var storageRef = FirebaseStorage.instance.ref().child(filePath);
      await storageRef.putData(_image!);
      String downloadURL = await storageRef.getDownloadURL();
      await user.updatePhotoURL(downloadURL);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  Future adduserDetails(
      String userId, String firstName, String lastName) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'first name': firstName,
      'last name': lastName,
      'attempts left': 50,
    });
  }

  Future<void> signUp() async {
    if (!passwordConfirmed()) {
      setState(() {
        _errorMessage = 'Salasanat eivät täsmää';
      });
      return;
    }

    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty) {
      setState(() {
        _errorMessage =
            'Tarkista, että olet täyttänyt kaikki tarvittavat tiedot';
      });
      return;
    }

    if (!_isImageAdded) {
      setState(() {
        _errorMessage = 'Lisää vielä kuvasi';
      });
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());

      await adduserDetails(userCredential.user!.uid,
          _firstNameController.text.trim(), _lastNameController.text.trim());

      if (_image != null) {
        await saveProfileImage(userCredential.user!);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'Rekisteröityminen epäonnistui';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.emoji_events,
                  color: Colors.yellow,
                  size: 100,
                ),
                Text(
                  'Rekisteröidy Olympialaisiin',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.bebasNeue(fontSize: 40),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Etunimi',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Sukunimi',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Sähköposti',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Salasana',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Salasana uudestaan',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _isImageAdded
                      ? 'Kuva lisätty!'
                      : 'Lisää vielä kuva omasta naamastasi',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  color: Colors.deepPurple[300],
                  iconSize: 50,
                  onPressed: selectImage,
                  icon: Icon(
                    _isImageAdded ? Icons.check_circle : Icons.add_a_photo,
                  ),
                ),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Text(
                          'Rekisteröidy',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Onko sinulla jo tili?',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: const Text(
                        ' Kirjaudu sisään!',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

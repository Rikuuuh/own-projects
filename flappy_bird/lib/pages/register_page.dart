import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flappy_bird_game/auth/auth.dart';
import 'package:flappy_bird_game/auth/pick_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Register widget, käyttäjä pääsee rekisteröitymään sovellukseen
// täyttämällä vaaditut tiedot
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.showLoginPage});
  final void Function() showLoginPage;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  bool _isImageAdded = false;
  String _errorMessage = '';

  final User? user = Auth().currentUser;
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

  Future adduserDetails(String userId, String firstName, String lastName,
      String email, String imageUrl) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'first name': firstName,
      'last name': lastName,
      'email': email,
      'attempts left': 50,
      'imageUrl': imageUrl,
      'visa attempt': 1,
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

      String imageUrl = '';
      if (_image != null) {
        imageUrl = await saveProfileImage(userCredential.user!);
      }

      await adduserDetails(
          userCredential.user!.uid,
          _firstNameController.text.trim(),
          _lastNameController.text.trim(),
          _emailController.text.trim(),
          imageUrl);
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
                  size: 80,
                ),
                Text(
                  'Rekisteröidy Olympialaisiin',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 40),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        textCapitalization: TextCapitalization.sentences,
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
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        textCapitalization: TextCapitalization.sentences,
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
                      border: Border.all(color: Colors.black),
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
                      border: Border.all(color: Colors.black),
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
                      border: Border.all(color: Colors.black),
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
                  _isImageAdded ? 'Kuva lisätty!' : 'Lisää vielä naamakuvasi',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  color: Colors.yellowAccent,
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
                ElevatedButton(
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.only(left: 50, right: 50, top: 15, bottom: 15),
                    ),
                  ),
                  onPressed: signUp,
                  child: Text(
                    'Rekisteröidy',
                    style: Theme.of(context).textTheme.titleLarge,
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

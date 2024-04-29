// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart' show rootBundle, ByteData;
import 'package:naytto/front_page.dart';
import 'package:naytto/rh_kansio/forgot_pw.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _firebase = FirebaseAuth.instance;
  // Onko kirjautuminen vai rekisteröinti
  var _isLogin = true;

  final _formKey = GlobalKey<FormState>();

  var _enteredFirstName = '';
  var _enteredLastName = '';
  var _enteredEmail = '';
  var _enteredPhoneNumber = '';
  var _enteredAddress = '';
  var _enteredCity = '';
  var _enteredPassword = '';

  User? user = FirebaseAuth.instance.currentUser;

  final databaseReference = FirebaseDatabase.instance.ref();

  //kuvahommelit
  Future<ByteData?> loadAsset(String path) async {
    return await rootBundle.load(path);
  }
  //

  void _handleGoogleSignIn() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      UserCredential userCredential =
          await _firebase.signInWithProvider(googleAuthProvider);

      if (userCredential.additionalUserInfo!.isNewUser) {
        // Otetaan eka koko nimi muuttujaan
        String? fullName = userCredential.user!.displayName;
        String? email = userCredential.user!.email;
        String? phoneNumber = userCredential.user!.phoneNumber;
        // Jaetaan koko nimi kahteen osaan (firstname & lastname)
        List<String> names = fullName?.split(' ') ?? [];
        String firstName = names.isNotEmpty ? names.first : '';
        String lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

        final userData = {
          "firstname": firstName,
          "lastname": lastName,
          "email": email ?? '',
          "phone": phoneNumber ?? '',
          "address": '',
          "city": '',
        };

        await databaseReference
            .child('users/${userCredential.user!.uid}')
            .set(userData);

        //kuvahommelit
        final user = FirebaseAuth.instance.currentUser;
        final uid = user!.uid;
        ByteData? imageData = await loadAsset('assets/images/user.png');

        firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('$uid.jpg');

        await storageReference.putData(imageData!.buffer.asUint8List());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FrontPage(),
          ),
        );
      }
    } catch (e) {
      // Näytetään virheviesti
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kirjautuminen epäonnistui: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _googleSignInButton() {
    return ElevatedButton.icon(
      icon: Image.asset('assets/images/google.png', width: 25, height: 25),
      label: const Text(
        "Tai rekisteröidy Googlella",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: _handleGoogleSignIn,
      style: const ButtonStyle(
        shape: MaterialStatePropertyAll(LinearBorder()),
      ),
    );
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    try {
      if (!_isLogin) {
        // Rekisteröinti
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        final users = {
          "firstname": _enteredFirstName,
          "lastname": _enteredLastName,
          "email": _enteredEmail,
          "phone": _enteredPhoneNumber,
          "address": _enteredAddress,
          "city": _enteredCity,
        };
        databaseReference
            .child('users/${userCredentials.user!.uid}')
            .set(users);

        //kuvahommat

        final user = FirebaseAuth.instance.currentUser;
        final uid = user!.uid;
        ByteData? imageData = await loadAsset('assets/images/user.png');

        firebase_storage.Reference storageReference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('$uid.jpg');

        await storageReference.putData(imageData!.buffer.asUint8List());

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FrontPage(),
          ),
        );
      } else {
        // Kirjautuminen
        // ignore: unused_local_variable
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FrontPage(),
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      String errorMessage;
      switch (error.code) {
        case 'invalid-credential':
          errorMessage = 'Sähköpostiosoite tai salasanasi on väärin.';
          break;
        case 'wrong-password':
          errorMessage = 'Väärä salasana.';
          break;
        case 'user-disabled':
          errorMessage = 'Käyttäjätili on poistettu käytöstä.';
          break;
        case 'too-many-requests':
          errorMessage = 'Liikaa yrityksiä. Yritä myöhemmin uudelleen.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Kirjautuminen ei ole sallittua.';
          break;
        case 'email-already-in-use':
          errorMessage = 'Sähköposti on jo käytössä.';
          break;
        default:
          errorMessage = 'Tuntematon virhe: ${error.message}';
          break;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isLogin)
                SizedBox(
                  width: MediaQuery.of(context).size.width - 10,
                  child: Image.asset(
                    'assets/images/kerrostalo.png',
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fill,
                  ),
                ),
              const SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!_isLogin)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Tarkista etunimesi';
                                }
                                return null;
                              },
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Etunimi',
                              ),
                              keyboardType: TextInputType.name,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.words,
                              onSaved: (newValue) {
                                _enteredFirstName = newValue!;
                              },
                            ),
                          ),
                        ),
                      if (!_isLogin) const SizedBox(height: 10),
                      if (!_isLogin)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Tarkista sukunimesi';
                                }
                                return null;
                              },
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Sukunimi',
                              ),
                              keyboardType: TextInputType.name,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.words,
                              onSaved: (newValue) {
                                _enteredLastName = newValue!;
                              },
                            ),
                          ),
                        ),
                      if (!_isLogin) const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Tarkista sähköpostisi!';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Sähköposti',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            onSaved: (newValue) {
                              _enteredEmail = newValue!;
                            },
                          ),
                        ),
                      ),
                      if (!_isLogin) const SizedBox(height: 10),
                      if (!_isLogin)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Tarkista puhelinnumerosi';
                                }
                                return null;
                              },
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Puhelinnumero',
                              ),
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              onSaved: (newValue) {
                                _enteredPhoneNumber = newValue!;
                              },
                            ),
                          ),
                        ),
                      if (!_isLogin) const SizedBox(height: 10),
                      if (!_isLogin)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Tarkista osoitteesi!';
                                }
                                return null;
                              },
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Katuosoite',
                              ),
                              keyboardType: TextInputType.streetAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.words,
                              onSaved: (newValue) {
                                _enteredAddress = newValue!;
                              },
                            ),
                          ),
                        ),
                      if (!_isLogin) const SizedBox(height: 10),
                      if (!_isLogin)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Tarkista kaupunkisi!';
                                }
                                return null;
                              },
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Kaupunki',
                              ),
                              keyboardType: TextInputType.streetAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.words,
                              onSaved: (newValue) {
                                _enteredCity = newValue!;
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Salasanassa täytyy olla vähintään 6 merkkiä!';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Salasana',
                            ),
                            obscureText: true,
                            onSaved: (newValue) {
                              _enteredPassword = newValue!;
                            },
                          ),
                        ),
                      ),
                      if (_isLogin)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const ForgotPassword();
                                    },
                                  ),
                                );
                              },
                              child: const Text(
                                'Unohtuiko salasana?',
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      if (_isLogin) const SizedBox(height: 10),
                      if (!_isLogin) const SizedBox(height: 30),
                      ElevatedButton(
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(LinearBorder()),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.only(
                                left: 80, right: 80, top: 12, bottom: 12),
                          ),
                        ),
                        onPressed: _submit,
                        child: Text(
                          _isLogin ? 'Kirjaudu sisään' : 'Rekisteröidy',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      if (_isLogin) const SizedBox(height: 20),
                      if (!_isLogin) const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              _isLogin
                                  ? 'Eikö sinulla ole tiliä?'
                                  : 'Onko sinulla jo tili?',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14.5)),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isLogin = !_isLogin;
                              });
                            },
                            child: Text(
                              _isLogin ? ' Luo uusi tili' : ' Kirjaudu sisään',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.5),
                            ),
                          )
                        ],
                      ),
                      if (_isLogin) const SizedBox(height: 20),
                      if (_isLogin) _googleSignInButton(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

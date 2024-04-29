import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naytto/ml_kansio/components/custom_input_deco.dart';
import 'package:naytto/rh_kansio/auth_screen.dart';

User? user;
String? uId;

final databaseReference = FirebaseDatabase.instance.ref();

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({super.key});

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    uId = user!.uid;
  }

  void _updateUserInfo() {
    final userData = {
      "firstname": _firstnameController.text,
      "lastname": _lastnameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "address": _streetAddressController.text,
      "city": _cityController.text,
    };
    databaseReference.child('users/$uId').set(userData);
  }

  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Omien tietojen muokkaus'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: StreamBuilder(
            stream: databaseReference.child('users/$uId').onValue,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data?.snapshot.value != null) {
                final userData =
                    snap.data?.snapshot.value as Map<Object?, Object?>;
                _firstnameController.text = userData['firstname'].toString();
                _lastnameController.text = userData['lastname'].toString();
                _emailController.text = userData['email'].toString();
                _phoneController.text = userData['phone'].toString();
                _streetAddressController.text = userData['address'].toString();
                _cityController.text = userData['city'].toString();

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _firstnameController,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        decoration: inputDecoration(
                            prefixIcon: const Icon(Icons.account_box_outlined),
                            hintText: 'Millä nimellä sinua kutsutaan',
                            labelText: 'Etunimi'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Etunimi on pakollinen tieto';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _lastnameController,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        decoration: inputDecoration(
                            prefixIcon: const Icon(Icons.account_box_outlined),
                            hintText: 'Sukusi nimi',
                            labelText: 'Sukunimi'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Sukunimi on pakollinen tieto';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        decoration: inputDecoration(
                            prefixIcon: const Icon(Icons.email_outlined),
                            hintText:
                                'Kaikki kirjaimet pienellä, muista @-merkki',
                            labelText: 'E-mail'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Täytäthän tämän kentän.';
                          }
                          if (!value.contains('@')) {
                            return 'Sähköpostiosoitteessa täytyy olla @-merkki.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _phoneController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        decoration: inputDecoration(
                            prefixIcon:
                                const Icon(Icons.phone_android_outlined),
                            hintText: 'Mistä numerosta sinut tavoittaa',
                            labelText: 'Puhelinnumero'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Kenttä ei voi olla tyhjä. Anna puhelinnumerosi!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _streetAddressController,
                        keyboardType: TextInputType.streetAddress,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        decoration: inputDecoration(
                            prefixIcon: const Icon(Icons.streetview_outlined),
                            hintText: 'Osoite, johon postisi lähetetään',
                            labelText: 'Katuosoite'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Annathan osoitteesi.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _cityController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        decoration: inputDecoration(
                            prefixIcon:
                                const Icon(Icons.location_city_outlined),
                            hintText: 'Missä kaupungissa asut?',
                            labelText: 'Kaupunki'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Kaupunki on pakollinen tieto';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _updateUserInfo();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Moikka ${_firstnameController.text}!\nTietosi on onnistuneesti päivitetty.',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              //error
                            }
                          },
                          child: Text(
                            'Tallenna',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ))
                    ],
                  ),
                );
              } else {
                //tämä osio ei käytännössä näy käyttäjälle koskaan. Tilalla voisi olla vaikkapa
                //Navigator.push, joka vie kirjautumissivulle.
                return Column(children: [
                  Text(
                    'Virhe!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthScreen(),
                          ));
                    },
                    child: Text(
                      'Tästä sisäänkirjautumissivulle',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ]);
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetAddressController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}

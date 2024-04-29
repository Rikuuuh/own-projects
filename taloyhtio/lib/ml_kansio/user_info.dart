import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:naytto/ml_kansio/widgets/profile_photo_input.dart';
import 'package:naytto/ml_kansio/changepw.dart';
import 'package:naytto/ml_kansio/usereditscreen.dart';
import 'package:naytto/rh_kansio/auth_screen.dart';
import 'package:naytto/rh_kansio/main_drawer.dart';

//Firebase
User? user;
String? uId;
final databaseReference = FirebaseDatabase.instance.ref();

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
//FIREBASE-SÄÄDÖT

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    uId = user!.uid;
  }

  //BOOLIT
  bool fnIsEditable = false;
  bool lnIsEditable = false;
  bool emIsEditable = false;
  bool phIsEditable = false;
  bool adIsEditable = false;
  bool ciIsEditable = false;

  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();

  void saveSingleDataItem(itemController) {
    Map<String, Object?> userData = {};
    if (itemController == _firstnameController) {
      userData = {"firstname": _firstnameController.text};
    }

    if (itemController == _lastnameController) {
      userData = {"lastname": _lastnameController.text};
    }

    if (itemController == _emailController) {
      userData = {"email": _emailController.text};
    }

    if (itemController == _phoneController) {
      userData = {"phone": _phoneController.text};
    }

    if (itemController == _streetAddressController) {
      userData = {"address": _streetAddressController.text};
    }

    if (itemController == _cityController) {
      userData = {"city": _cityController.text};
    }

    databaseReference.child('users/$uId').update(userData);

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Tietojen muokkaus suoritettu"),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Omat tiedot'),
        ),
        drawer: MainDrawer(
          activePage: 'Omat tiedot',
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: //Column(
                //children: [
                StreamBuilder(
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
                  _streetAddressController.text =
                      userData['address'].toString();
                  _cityController.text = userData['city'].toString();

                  return Column(
                    children: [
                      const ProfilePhotoInput(
                          /*onPickImage: (imageFile) {
                            _selectedImage = imageFile;
                          }*/
                          ),
                      const SizedBox(height: 25),
                      Text(
                        'Etunimi',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      fnIsEditable == false
                          ? ListTile(
                              leading: const Icon(Icons.person_pin),
                              title: Text(
                                textAlign: TextAlign.center,
                                userData['firstname'].toString(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 18,
                                ),
                              ),
                              trailing:

                                  // ),
                                  IconButton(
                                alignment: Alignment.center,
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    fnIsEditable = true;
                                  });
                                },
                              ))
                          /* Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        userData['firstname'].toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),

                                    // ),
                                    IconButton(
                                      alignment: Alignment.center,
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          fnIsEditable = true;
                                        });
                                      },
                                    )
                                  ],
                                ) */
                          : Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    enabled: true,
                                    textAlign: TextAlign.center,
                                    controller: _firstnameController,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                IconButton(
                                  icon: const Icon(Icons.save_alt_outlined),
                                  onPressed: () {
                                    if (_firstnameController.text
                                        .trim()
                                        .isNotEmpty) {
                                      saveSingleDataItem(_firstnameController);
                                      setState(() {
                                        fnIsEditable = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Etunimi on pakollinen tieto!'),
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                      /* Text(
                            userData['firstname'].toString(),
                            style: const TextStyle(fontSize: 18),
                          ), */
                      const SizedBox(height: 10),
                      Text(
                        'Sukunimi',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      lnIsEditable == false
                          ? ListTile(
                              leading: const Icon(Icons.family_restroom),
                              title: Text(
                                textAlign: TextAlign.center,
                                userData['lastname'].toString(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 18,
                                ),
                              ),
                              trailing:

                                  /*Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        userData['lastname'].toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),*/

                                  // ),
                                  IconButton(
                                alignment: Alignment.topRight,
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    lnIsEditable = true;
                                  });
                                },
                              )
                              //],
                              )
                          : Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    enabled: true,
                                    textAlign: TextAlign.center,
                                    controller: _lastnameController,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                IconButton(
                                  icon: const Icon(Icons.save_alt_outlined),
                                  onPressed: () {
                                    if (_lastnameController.text
                                        .trim()
                                        .isNotEmpty) {
                                      saveSingleDataItem(_lastnameController);
                                      setState(() {
                                        lnIsEditable = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Sukunimi on pakollinen tieto!'),
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                      /* Text(
                            userData['lastname'].toString(),
                            style: const TextStyle(fontSize: 18),
                          ), */
                      const SizedBox(height: 10),
                      Text(
                        'Sähköposti',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      emIsEditable == false
                          ? ListTile(
                              leading: const Icon(Icons.email),
                              title: Text(
                                textAlign: TextAlign.center,
                                userData['email'].toString(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 18,
                                ),
                              ),
                              trailing:

                                  /* Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    userData['email'].toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ), */

                                  // ),
                                  IconButton(
                                alignment: Alignment.topRight,
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    emIsEditable = true;
                                  });
                                },
                              ),
//                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    enabled: true,
                                    textAlign: TextAlign.center,
                                    controller: _emailController,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                IconButton(
                                  icon: const Icon(Icons.save_alt_outlined),
                                  onPressed: () {
                                    if (_emailController.text
                                            .trim()
                                            .isNotEmpty ||
                                        !_emailController.text.contains('@')) {
                                      saveSingleDataItem(_emailController);
                                      setState(() {
                                        emIsEditable = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Sähköposti on pakollinen tieto! Muista myös @-merkki!'),
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
/*                           Text(userData['email'].toString(),
                              style: const TextStyle(fontSize: 18)), */
                      const SizedBox(height: 10),
                      Text(
                        'Puhelin',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      phIsEditable == false
                          ? ListTile(
                              leading: const Icon(Icons.phone_android),
                              title: Text(
                                textAlign: TextAlign.center,
                                userData['phone'].toString(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 18,
                                ),
                              ),
                              trailing:

                                  /* Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    userData['phone'].toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ), */

                                  // ),
                                  IconButton(
                                alignment: Alignment.topRight,
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    phIsEditable = true;
                                  });
                                },
                              ),
                              //],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.phone,
                                    //tämä tässä ettei iPhonellakaan pysty
                                    //laittamaan tähän kirjaimia
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    enabled: true,
                                    textAlign: TextAlign.center,
                                    controller: _phoneController,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                IconButton(
                                  icon: const Icon(Icons.save_alt_outlined),
                                  onPressed: () {
                                    if (_phoneController.text
                                        .trim()
                                        .isNotEmpty) {
                                      saveSingleDataItem(_phoneController);
                                      setState(() {
                                        phIsEditable = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Puhelinnumero on pakollinen tieto!'),
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),
                      /*  Text(
                            userData['phone'].toString(),
                            style: const TextStyle(fontSize: 18),
                          ), */
                      const SizedBox(height: 10),
                      Text(
                        'Katuosoite',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      adIsEditable == false
                          ? ListTile(
                              leading: const Icon(Icons.streetview),
                              title: Text(
                                textAlign: TextAlign.center,
                                userData['address'].toString(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 18,
                                ),
                              ),
                              trailing:

                                  /*  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    userData['address'].toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ), */

                                  // ),
                                  IconButton(
                                alignment: Alignment.topRight,
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    adIsEditable = true;
                                  });
                                },
                              ),
                              //   ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    enabled: true,
                                    textAlign: TextAlign.center,
                                    controller: _streetAddressController,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                IconButton(
                                  icon: const Icon(Icons.save_alt_outlined),
                                  onPressed: () {
                                    if (_streetAddressController.text
                                        .trim()
                                        .isNotEmpty) {
                                      saveSingleDataItem(
                                          _streetAddressController);
                                      setState(() {
                                        adIsEditable = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Osoite on pakollinen tieto!'),
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),

                      /* Text(
                            userData['address'].toString(),
                            style: const TextStyle(fontSize: 18),
                          ), */
                      const SizedBox(height: 10),
                      Text(
                        'Postinumero ja -toimipaikka',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      ciIsEditable == false
                          ? ListTile(
                              leading: const Icon(Icons.location_city),
                              title: Text(
                                textAlign: TextAlign.center,
                                userData['city'].toString(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 18,
                                ),
                              ),
                              trailing:
                                  /* Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    userData['city'].toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ), */

                                  // ),
                                  IconButton(
                                alignment: Alignment.topRight,
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    ciIsEditable = true;
                                  });
                                },
                              ),
                              //  ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    enabled: true,
                                    textAlign: TextAlign.center,
                                    controller: _cityController,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                IconButton(
                                  icon: const Icon(Icons.save_alt_outlined),
                                  onPressed: () {
                                    if (_cityController.text
                                        .trim()
                                        .isNotEmpty) {
                                      saveSingleDataItem(_cityController);
                                      setState(() {
                                        ciIsEditable = false;
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Kaupunki on pakollinen tieto!'),
                                        ),
                                      );
                                    }
                                  },
                                )
                              ],
                            ),

                      /*  Text(
                            userData['city'].toString(),
                            style: const TextStyle(fontSize: 18),
                          ), */
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UserEditScreen()));
                        },
                        child: const Text('Muokkaa tietoja'),
                      ),
                      if (!user!.providerData.any(
                          (provider) => provider.providerId == 'google.com'))
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChangePw()));
                          },
                          child: const Text('Vaihda salasana'),
                        ),
                    ],
                  );
                } else {
                  //Tämä osio näkyy vain projektin alkuvaiheen testikäyttäjille,
                  //joiden tunnuksien alle ei ole tallennettu user-tietoja lainkaan.
                  //näkymä lienee edessä myös, mikäli Firebasen puolella on jotain häikkää.
                  return Column(children: [
                    Text(
                      'Virhe!',
                      style: TextStyle(color: Colors.grey[600]),
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
                            ),
                          );
                        },
                        child: const Text(
                          'Tunnuksissasi on jotain vikaa. Otathan yhteyttä ylläpitoon: taloyhtio123@email.com. Tästä pääset takaisin sisäänkirjautumissivulle.',
                          maxLines: 3,
                        ))
                  ]);
                }
              },
            ),
            //  ],
            //),
          ),
        ));
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

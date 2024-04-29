import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePw extends StatefulWidget {
  const ChangePw({super.key});

  @override
  State<ChangePw> createState() => _ChangePwState();
}

class _ChangePwState extends State<ChangePw> {
  var currentUser = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var newPasswordController2 = TextEditingController();

  Future<void> changePassword({email, oldPassword, newPassword}) async {
    var cred =
        EmailAuthProvider.credential(email: email, password: oldPassword);

    if (currentUser != null) {
      await currentUser!.reauthenticateWithCredential(cred).then((value) {
        currentUser!.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salasanan vaihto onnistui!')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Salasanan vaihto epäonnistui. Vanha salasana ei täsmää.')),
        );
      });
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salasanan vaihto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: oldPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Nykyinen salasana'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Anna nykyinen salasanasi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: newPasswordController,
                decoration: const InputDecoration(labelText: 'Uusi salasana'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Syötä uusi salasana';
                  }
                  if (value.length < 7) {
                    return 'Salasanan vähimmäispituus on 7 merkkiä';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: newPasswordController2,
                decoration: const InputDecoration(
                    labelText: 'Uuden salasanan varmistus'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Syötä uusi salasana uudelleen';
                  }
                  if (value.length < 7) {
                    return 'Salasanan vähimmäispituus on 7 merkkiä';
                  }
                  if (value != newPasswordController.text) {
                    return 'Uudet salasanat eivät täsmää. Yritä uudelleen.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await changePassword(
                        email: currentUser!.email.toString(),
                        oldPassword: oldPasswordController.text,
                        newPassword: newPasswordController.text);
                    /* try {
                      await _auth.currentUser!.updatePassword(_newPassword);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Password changed successfully')),
                      );
                      Navigator.pop(context);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to change password: $error')),
                      );
                    } */
                  }
                },
                child: const Text('Vaihda salasana'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_game/components/main_drawer.dart';
import 'package:flappy_bird_game/components/text_box.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> editField(String field) async {
    String newValue = "";

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Muokkaa $field',
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: 'Lisää uusi $field',
              hintStyle: const TextStyle(color: Colors.white)),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Peruuta'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: const Text('Tallenna'),
          )
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(userId).update({field: newValue});
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
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    currentUser!.photoURL!,
                  ),
                  radius: 100,
                ),
                TextButton.icon(
                  onPressed: () {},
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
                const Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Text(
                    'Omat tietoni',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                MyTextBox(
                  text: userData!['email'],
                  sectionName: 'Sähköposti',
                  onPressed: () => editField('email'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.only(left: 15, bottom: 15, top: 15),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Etunimi',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        userData['first name'],
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

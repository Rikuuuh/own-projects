import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_bird_game/auth/auth.dart';

import 'package:flappy_bird_game/auth/get_user_data.dart';
import 'package:flappy_bird_game/main_drawer.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  final User? user = Auth().currentUser;

  // Document ID's
  final List<String> docIDs = [];

  // get docID's
  Future<List<DocumentSnapshot>> getDocs() async {
    var snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text(
          'Kunniajoukko',
          style: TextStyle(fontSize: 24, color: Colors.yellow),
        ),
      ),
      drawer: const MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: getDocs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  const CircularProgressIndicator();
                }
                if (!snapshot.hasData) {
                  return const Text("Ei käyttäjiä.");
                }
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var userData =
                          snapshot.data![index].data() as Map<String, dynamic>;
                      var userImageUrl =
                          userData['imageUrl'] ?? 'assets/images/user.png';
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: userImageUrl.startsWith('http')
                                ? NetworkImage(userImageUrl) as ImageProvider
                                : AssetImage(userImageUrl) as ImageProvider,
                            radius: 30,
                          ),
                          title: GetUserData(
                            documentId: snapshot.data![index].id,
                            userId: snapshot.data![index].id,
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flappy_bird_game/auth/get_user_data.dart';
import 'package:flappy_bird_game/main_drawer.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  // Document ID's
  final List<String> docIDs = [];

  // get docID's
  Future getDocId() async {
    var snapshot = await FirebaseFirestore.instance.collection('users').get();
    for (var document in snapshot.docs) {
      docIDs.add(document.reference.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            child: FutureBuilder(
              future: getDocId(),
              builder: (context, snapshot) {
                return ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user?.photoURL != null
                                ? NetworkImage(user!.photoURL!) as ImageProvider
                                : const AssetImage('assets/images/user.png')
                                    as ImageProvider,
                            radius: 24,
                          ),
                          title: GetUserData(
                              documentId: docIDs[index], userId: docIDs[index]),
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

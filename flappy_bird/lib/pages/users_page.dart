import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_bird_game/auth/auth.dart';
import 'package:flappy_bird_game/auth/get_user_data.dart';
import 'package:flappy_bird_game/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  final User? user = Auth().currentUser;

  final List<String> docIDs = [];

  Future<List<DocumentSnapshot>> getDocs() async {
    var snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        foregroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text(
          'Kunniajoukko',
          style: TextStyle(fontSize: 24, color: Colors.yellow),
        ),
      ),
      drawer: const MainDrawer(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 50.0,
                  color: Colors.yellow,
                ),
                Text(
                  'Kisaajien Kunniajoukko',
                  style: GoogleFonts.bebasNeue(
                    color: Colors.yellow,
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(
                        color: Colors.black,
                        blurRadius: 2.0,
                        offset: Offset(1.5, 1.5),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Tutustu muihin kisaajiin ja vertaile tuloksianne. Kuka on mökkiolympialaisten monitaituri?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DocumentSnapshot>>(
              future: getDocs(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                }
                if (!snapshot.hasData) {
                  return const Text("Ei käyttäjiä.");
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 10.0),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var userData =
                        snapshot.data![index].data() as Map<String, dynamic>;
                    var userImageUrl =
                        userData['imageUrl'] ?? 'assets/images/user.png';
                    return Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: userImageUrl.startsWith('http')
                              ? NetworkImage(userImageUrl) as ImageProvider
                              : AssetImage(userImageUrl) as ImageProvider,
                          radius: 25,
                        ),
                        title: GetUserData(
                          documentId: snapshot.data![index].id,
                          userId: snapshot.data![index].id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

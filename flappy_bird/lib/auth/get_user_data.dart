import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// users_page:n child, haetaan Firestore databasen usersista tiedot
// firestore databasen highscores collectionista tiedot
//
class GetUserData extends StatelessWidget {
  final String documentId;
  final String userId;

  const GetUserData({
    super.key,
    required this.documentId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference scores =
        FirebaseFirestore.instance.collection('highscores');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.done &&
            userSnapshot.data != null) {
          Map<String, dynamic> userData =
              userSnapshot.data!.data() as Map<String, dynamic>;

          String name = '${userData['first name']}';

          return FutureBuilder<QuerySnapshot>(
            future: scores
                .where('name', isEqualTo: name)
                .orderBy('score', descending: true)
                .limit(1)
                .get(),
            builder: (context, scoreSnapshot) {
              int highScore = 0; // Oletusarvo, jos tuloksia ei ole

              if (scoreSnapshot.connectionState == ConnectionState.done &&
                  scoreSnapshot.data != null &&
                  scoreSnapshot.data!.docs.isNotEmpty) {
                highScore = scoreSnapshot.data!.docs.first['score'];
              }

              return Column(children: [
                Text('$name ${userData['last name']}'),
                Text('Olympic Bird paras tulos : $highScore')
              ]);
            },
          );
        }
        return const Text('lataa..');
      },
    );
  }
}

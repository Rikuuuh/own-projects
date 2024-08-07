import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Käytössä view_users_page.dart:issa (Hall of Fame)
// Haetaan käyttäjien tiedot users-, highscores- ja visascores tauluista
// Näytetään ne view_users_page:n Listview builderissa.

class GetUserData extends StatelessWidget {
  final String documentId;
  final String userId;

  const GetUserData({
    super.key,
    required this.documentId,
    required this.userId,
  });

  Future<Map<String, dynamic>> getUserData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    CollectionReference scores =
        FirebaseFirestore.instance.collection('highscores');
    CollectionReference visascores =
        FirebaseFirestore.instance.collection('visascores');

    var userSnapshot = await users.doc(documentId).get();
    Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
    String name = userData['first name'];

    var scoreFuture = scores
        .where('name', isEqualTo: name)
        .orderBy('score', descending: true)
        .limit(1)
        .get();
    var visaScoreFuture = visascores
        .where('name', isEqualTo: name)
        .orderBy('score', descending: true)
        .limit(1)
        .get();

    var results = await Future.wait([scoreFuture, visaScoreFuture]);

    int highScore = 0;
    if (results[0].docs.isNotEmpty) {
      highScore = results[0].docs.first['score'];
    }

    int visaScore = 0;
    if (results[1].docs.isNotEmpty) {
      visaScore = results[1].docs.first['score'];
    }

    return {
      'name': name,
      'lastName': userData['last name'],
      'highScore': highScore,
      'visaScore': visaScore,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          var data = snapshot.data!;
          return Column(children: [
            Text(
              'Kisaaja : ${data['name']} ${data['lastName']}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontSize: 18),
            ),
            Text('Bird-pelin paras tulos : ${data['highScore']}',
                style: Theme.of(context).textTheme.titleMedium),
            Text('Tietovisan tulos : ${data['visaScore']}',
                style: Theme.of(context).textTheme.titleMedium),
          ]);
        } else if (snapshot.hasError) {
          return Text('Virhe: ${snapshot.error}');
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.blueGrey[800],
            color: Colors.black,
          ),
        );
      },
    );
  }
}

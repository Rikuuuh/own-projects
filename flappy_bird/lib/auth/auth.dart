import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Käytössä flappy_bird_gamen main_menu_screenin highscoreja varten

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}

class UserService {
  static Future<UserData> getUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return UserData(
        firstName: userDoc['first name'],
        lastName: userDoc['last name'],
      );
    } else {
      throw Exception('Käyttäjä ei ole kirjautunut sisään');
    }
  }
}

class UserData {
  final String firstName;
  final String lastName;

  UserData({required this.firstName, required this.lastName});
}

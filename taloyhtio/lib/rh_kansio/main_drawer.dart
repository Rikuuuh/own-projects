import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:naytto/ab_kansio/varauskalenteri.dart';
import 'package:naytto/ml_kansio/heippalaput_stream.dart';
import 'package:naytto/front_page.dart';
import 'package:naytto/ml_kansio/user_info.dart';
import 'package:naytto/rh_kansio/auth_screen.dart';
import 'package:naytto/rh_kansio/main_drawer_item.dart';
import 'package:naytto/rh_kansio/user_profile_image.dart';
import 'package:naytto/vv_kansio/yhteystiedot_screen.dart';

class MainDrawer extends StatelessWidget {
  MainDrawer({super.key, this.activePage});

  final User? currentUser = FirebaseAuth.instance.currentUser;
  final String? activePage;

  Future<String> getUserFullName(String uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('users/$uid');
    DatabaseEvent event = await ref.once();
    if (event.snapshot.value != null) {
      Map<String, dynamic> userData =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      String firstName = userData['firstname'] ?? 'Nimetön';
      String lastName = userData['lastname'] ?? 'Käyttäjä';
      return "$firstName $lastName";
    } else {
      return "Nimetön Käyttäjä";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      width: 270,
      child: Column(
        children: [
          FutureBuilder<String>(
            future: getUserFullName(currentUser?.uid ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).appBarTheme.backgroundColor!,
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.only(top: 52, bottom: 30),
                child: Column(
                  children: [
                    const UserProfileImage(),
                    const SizedBox(height: 22),
                    Text(
                      snapshot.data ?? 'Nimetön käyttäjä',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(currentUser!.email!,
                        style: Theme.of(context).textTheme.titleSmall)
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ListView(
              children: [
                MainDrawerItem(
                    icon: Icons.home_outlined,
                    text: 'Etusivu',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FrontPage(),
                        ),
                      );
                    },
                    isActive: activePage == 'Etusivu'),
                MainDrawerItem(
                    icon: Icons.calendar_month_outlined,
                    text: 'Varauskalenteri',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VarausKalenteri(),
                        ),
                      );
                    },
                    isActive: activePage == 'Varauskalenteri'),
                MainDrawerItem(
                    icon: Icons.topic_outlined,
                    text: 'Heippalaput',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HeippaLaput(),
                        ),
                      );
                    },
                    isActive: activePage == 'Heippalaput'),
                const SizedBox(height: 20),
                Divider(color: Colors.blueGrey[600]),
                MainDrawerItem(
                    icon: Icons.email_outlined,
                    text: 'Ota yhteyttä',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const YhteystiedotScreen(),
                        ),
                      );
                    },
                    isActive: activePage == 'Ota yhteyttä'),
                MainDrawerItem(
                    icon: Icons.settings_outlined,
                    text: 'Omat tiedot',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserInfoScreen(),
                        ),
                      );
                    },
                    isActive: activePage == 'Omat tiedot'),
                const SizedBox(height: 20),
                Divider(color: Colors.blueGrey[600]),
              ],
            ),
          ),
          MainDrawerItem(
            icon: Icons.logout_outlined,
            text: 'Kirjaudu ulos',
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const AuthScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

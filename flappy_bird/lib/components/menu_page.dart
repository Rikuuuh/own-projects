import 'package:firebase_auth/firebase_auth.dart';
import 'package:flappy_bird_game/auth/auth.dart';
import 'package:flappy_bird_game/auth/main_page.dart';
import 'package:flappy_bird_game/model/menu_item.dart';
import 'package:flutter/material.dart';

// Drawer:iin kuuluva widget, menu_state.dart:in child
// MenuItemsiin laitettu kaikki sivut joissa käyttäjä voi käydä drawerin kautta

class MenuItems {
  static const etusivu = MenuItem('Etusivu', Icons.home_outlined);
  static const tietovisa =
      MenuItem('Tietovisa - Tietäjien Taisto', Icons.lightbulb_outlined);
  static const birdpeli =
      MenuItem('Pelihetki - Olympic Bird', Icons.sports_esports_outlined);
  static const userspage =
      MenuItem('Hall of Fame', Icons.emoji_events_outlined);
  static const profilepage = MenuItem('Oma Profiili', Icons.settings_outlined);

  static const all = <MenuItem>[
    etusivu,
    tietovisa,
    birdpeli,
    userspage,
    profilepage,
  ];
}

class MenuPage extends StatelessWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;

  const MenuPage(
      {super.key, required this.currentItem, required this.onSelectedItem});
  Widget buildMenuItem(BuildContext context, MenuItem item) => ListTileTheme(
        selectedColor: Colors.white,
        child: ListTile(
          selectedTileColor: Colors.black26,
          selected: currentItem == item,
          minLeadingWidth: 20,
          leading: Icon(item.icon,
              color: Theme.of(context).colorScheme.onSecondaryContainer),
          title:
              Text(item.title, style: Theme.of(context).textTheme.titleMedium),
          onTap: () => onSelectedItem(item),
        ),
      );
  @override
  Widget build(BuildContext context) {
    final User? user = Auth().currentUser;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 40),
              child: CircleAvatar(
                radius: 90,
                backgroundColor:
                    Color.fromARGB(255, 0, 41, 53), // Reunuksen väri
                child: CircleAvatar(
                  radius: 85, // Avatarin säde
                  backgroundImage: AssetImage("assets/icons/iconBird.png"),
                ),
              ),
            ),
            const Spacer(),
            ...MenuItems.all.map((item) => buildMenuItem(context, item)),
            const Spacer(flex: 2),
            ListTile(
              leading: Icon(Icons.exit_to_app_outlined,
                  color: Theme.of(context).colorScheme.onSecondaryContainer),
              title: Text(
                'Kirjaudu ulos',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, bottom: 22),
              child: Text(
                user?.email ?? 'Ei sähköpostia',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

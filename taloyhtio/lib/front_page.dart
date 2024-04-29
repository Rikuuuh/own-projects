import 'package:flutter/material.dart';
import 'package:naytto/rh_kansio/main_drawer.dart';
import 'package:naytto/ml_kansio/user_info.dart';
import 'package:naytto/vv_kansio/screens/autopaikkavaraukset_screen.dart';
import 'package:naytto/vv_kansio/screens/ilmoitustaulu_screen.dart';
import 'package:naytto/vv_kansio/screens/pyykkitupavaraukset_screen.dart';
import 'package:naytto/vv_kansio/screens/saunavaraukset_screen.dart';
import 'package:naytto/vv_kansio/screens/huoltoilmoitukset_screen.dart';
import 'package:naytto/vv_kansio/widgets/omatvaraukset_button.dart';

class FrontPage extends StatelessWidget {
  const FrontPage({super.key});

  static const appBarTitle = 'Etusivu';

  @override
  Widget build(BuildContext context) {
    //vaakatasoon liittyvä
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(appBarTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            tooltip:
                'Linkki omiin tietoihin tai suoraan kuvan vaihtoon, tai uloskirjautumisvalikkoon yms.',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserInfoScreen(),
                ),
              );
            },
          ),
        ],
      ),
      //vaakatasoon liittyvä
      body: width < 600
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //mainAxisSize: MainAxisSize.min,

              //LISÄSIN ALLA OLEVIIN CONTAINEREIHIN EXPANDEDIT, KOSKA ANDROID-VERSIO VALITTELI TILAN YLITTYVÄN NÄYTÖN ALAOSASTA (ML 23.2.2024)

              children: [
                // Väliaikaisena tässä etusivun tyylittelyä esittelyä varten
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const HuoltoilmoituksetScreen(),
                          ),
                        );
                      },
                      child: ListView(
                        children: const [
                          Text(
                            'Huoltoilmoitukset',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Text('Saunan huolto'),
                                  Spacer(),
                                  Text('16/03 klo. 10-16'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: ListView(
                      children: const [
                        Text(
                          'Omat varaukset',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        OmatVarauksetButton(
                          title: 'Saunan varaukset',
                          target: SaunaVarauksetScreen(),
                        ),
                        OmatVarauksetButton(
                          title: 'Pyykkituvan varaukset',
                          target: PyykkitupaVarauksetScreen(),
                        ),
                        OmatVarauksetButton(
                          title: 'Auto / Vieraspaikan varaukset',
                          target: AutopaikkaVarauksetScreen(),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const IlmoitustauluScreen(),
                          ),
                        );
                      },
                      child: ListView(
                        children: const [
                          Text(
                            'Ilmoitustaulu',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Text('Taloyhtiön talkoot'),
                                  Spacer(),
                                  Text('16/03 klo. 10-16'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )

          //vaakataso
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //mainAxisSize: MainAxisSize.min,

              //LISÄSIN ALLA OLEVIIN CONTAINEREIHIN EXPANDEDIT, KOSKA ANDROID-VERSIO VALITTELI TILAN YLITTYVÄN NÄYTÖN ALAOSASTA (ML 23.2.2024)

              children: [
                // Väliaikaisena tässä etusivun tyylittelyä esittelyä varten
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const HuoltoilmoituksetScreen(),
                          ),
                        );
                      },
                      child: ListView(
                        children: const [
                          Text(
                            'Huoltoilmoitukset',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Column(
                                children: [
                                  Text('Saunan huolto',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  //Spacer(),
                                  Text('16/03 klo. 10-16'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: ListView(
                      children: const [
                        Text(
                          'Omat varaukset',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        OmatVarauksetButton(
                          title: 'Saunan varaukset',
                          target: SaunaVarauksetScreen(),
                        ),
                        OmatVarauksetButton(
                          title: 'Pyykkituvan varaukset',
                          target: PyykkitupaVarauksetScreen(),
                        ),
                        OmatVarauksetButton(
                          title: 'Vieraspaikkavaraukset',
                          target: AutopaikkaVarauksetScreen(),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const IlmoitustauluScreen(),
                          ),
                        );
                      },
                      child: ListView(
                        children: const [
                          Text(
                            'Ilmoitustaulu',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Card(
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Column(
                                children: [
                                  Text('Taloyhtiön talkoot',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  //Spacer(),
                                  Text('16/03 klo. 10-16'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      drawer: MainDrawer(activePage: 'Etusivu'),
    );
  }
}

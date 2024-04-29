import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AutopaikkaVarauksetScreen extends StatelessWidget {
  const AutopaikkaVarauksetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Firebase setit
    final databaseReference = FirebaseDatabase.instance.ref();
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

    // Streambuilderia varten streami, jolla haetaan käyttäjäkohtaiset varaukset
    Stream<Map<String, dynamic>> getReservationData() {
      return databaseReference
          // Tän pitää olla sit eri tavalla kun ja jos haetaan
          // esim. pyykkituvan tai saunan varauksia
          // Voi vaikka .orderBy(uusin).limit(NiinMontaKuinHaluatNäyttää);
          .child('reservations/vieraspaikka/$uid')
          .limitToFirst(5)
          .onValue
          // Muunnetaan saatu data Map<String, dynamic> muotoon.
          .map((event) {
        final value = event.snapshot.value;
        // Tarkistetaan, onko arvo Map-tyyppiä.
        if (value is Map<dynamic, dynamic>) {
          return value.map<String, dynamic>((key, value) {
            // Muunnetaan avaimet ja arvot String-muotoihihn
            final String keyStr = key.toString();
            final dynamic val =
                value is Map ? value.cast<String, dynamic>() : value;
            return MapEntry(keyStr, val);
          });
        } else {
          // Jos ei tuu mappia, palautetaan tyhjälista
          return <String, dynamic>{};
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Auto / Vieraspaikan varaukset'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          // StreamBuilder kuuntelemaan datan muutoksia
          child: StreamBuilder<Map<String, dynamic>>(
            stream: getReservationData(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              // Jos on error
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.hasData) {
                final data = snapshot.data!;
                // Tehään lista, jossa näkyy jokainen tieto erikseen
                return Column(
                  children: data.entries.map<Widget>((entry) {
                    final reservationData = entry.value is Map
                        ? entry.value.cast<String, dynamic>()
                        : <String, dynamic>{};

                    return Card(
                      margin: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Päivämäärä: ${reservationData['Päivämäärä']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Text(
                              'Paikan numero: ${reservationData['Vieraspaikka']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                Column(
                                  children: [
                                    Text(
                                      'Aloitusaika: ${reservationData['Aloitusaika']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Lopetusaika: ${reservationData['Lopetusaika']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                // Jos ei ole varauksia tai ei dataa saada
                return const Center(
                  child: Text(
                    'Ei varauksia',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

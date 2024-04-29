// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:naytto/ab_kansio/autoVaraukset.dart';
import 'package:naytto/ab_kansio/autopaikka.dart';
import 'package:naytto/ab_kansio/pyykkiVaraukset.dart';
import 'package:naytto/ab_kansio/pyykkitupa.dart';
import 'package:naytto/ab_kansio/saunaVaraukset.dart';
import 'package:naytto/ab_kansio/saunavuoro.dart';
import 'package:naytto/ml_kansio/user_info.dart';
import 'package:naytto/rh_kansio/main_drawer.dart';
import 'package:backdrop/backdrop.dart';

var houseColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 14, 195, 227),
);

class VarausKalenteri extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const VarausKalenteri({Key? key});

  static const appBarTitle = 'Varauskalenteri';

  @override
  State<VarausKalenteri> createState() => _VarausKalenteriState();
}

class _VarausKalenteriState extends State<VarausKalenteri> {
  final databaseReference = FirebaseDatabase.instance.ref();
  User? user = FirebaseAuth.instance.currentUser;
  late String? uid = user?.uid;
  DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('reservations');

  DateTime parseCustomDate(String dateString) {
    final parts = dateString.split('-');
    if (parts.length != 3) {
      throw FormatException('Invalid date format: $dateString');
    }
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) {
      throw FormatException('Invalid date format: $dateString');
    }
    return DateTime(year, month, day);
  }

  Stream<Map<String, dynamic>> getPyykkiReservationData() {
    return databaseReference
        .child('reservations/pyykkitupa/$uid')
        .orderByChild('Päivämäärä')
        .limitToFirst(1)
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value is Map<dynamic, dynamic>) {
        return value.map<String, dynamic>((key, value) {
          final String keyStr = key.toString();
          final dynamic val =
              value is Map ? value.cast<String, dynamic>() : value;
          return MapEntry(keyStr, val);
        });
      } else {
        return <String, dynamic>{};
      }
    });
  }

  Stream<Map<String, dynamic>> getAutoReservationData() {
    return databaseReference
        .child('reservations/vieraspaikka/$uid')
        .orderByChild('Päivämäärä')
        .limitToFirst(1)
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value is Map<dynamic, dynamic>) {
        return value.map<String, dynamic>((key, value) {
          final String keyStr = key.toString();
          final dynamic val =
              value is Map ? value.cast<String, dynamic>() : value;
          return MapEntry(keyStr, val);
        });
      } else {
        return <String, dynamic>{};
      }
    });
  }

  Stream<Map<String, dynamic>> getSaunaReservationData() {
    return databaseReference
        .child('reservations/sauna/$uid')
        .orderByChild('Päivämäärä')
        .limitToFirst(1)
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value is Map<dynamic, dynamic>) {
        return value.map<String, dynamic>((key, value) {
          final String keyStr = key.toString();
          final dynamic val =
              value is Map ? value.cast<String, dynamic>() : value;
          return MapEntry(keyStr, val);
        });
      } else {
        return <String, dynamic>{};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      appBar: AppBar(
        title: const Text(VarausKalenteri.appBarTitle),
        actions: <Widget>[
          const BackdropToggleButton(icon: AnimatedIcons.event_add),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip:
                'Linkki omiin tietoihin tai suoraan kuvan vaihtoon, tai uloskirjautumisvalikkoon yms.',
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserInfoScreen(),
                ),
              );
            },
          ),
        ],
      ),
      backLayerBackgroundColor: Colors.white,
      backLayer: ListView(
        children: <Widget>[
          ListTile(
            leading: const Text(
              'Saunavuoro',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle_sharp),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SaunaVuoro(),
                  ),
                );
              },
            ),
          ),
          const Divider(
            color: Colors.black54,
            thickness: 1,
          ),
          ListTile(
            leading: const Text(
              'Pyykkitupa',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle_sharp),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PyykkiTupa(),
                  ),
                );
              },
            ),
          ),
          const Divider(
            color: Colors.black54,
            thickness: 1,
          ),
          ListTile(
            leading: const Text(
              'Autopaikka',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add_circle_sharp),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AutoPaikka(),
                  ),
                );
              },
            ),
          ),
          const Divider(
            color: Colors.black54,
            thickness: 1,
          ),
        ],
      ),
      frontLayer: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            StreamBuilder<Map<String, dynamic>>(
              stream: getAutoReservationData(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> autoSnapshot) {
                final autoData = autoSnapshot.data ?? {};
                final hasAutoData = autoData.isNotEmpty;

                return !hasAutoData
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          const Text(
                            'Vieraspaikan varaukset',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: const EdgeInsets.all(10.0),
                            child: Column(
                              children: autoData.entries.map<Widget>((entry) {
                                final reservationData = entry.value is Map
                                    ? entry.value.cast<String, dynamic>()
                                    : <String, dynamic>{};

                                return Column(
                                  children: [
                                    ListTile(
                                      shape: const Border(bottom: BorderSide()),
                                      leading: const Icon(Icons.car_crash),
                                      title: Text(
                                          'Päivämäärä: ${reservationData['Päivämäärä']}'),
                                      subtitle: Text(
                                          'Aloitusaika: ${reservationData['Aloitusaika']}, Lopetusaika: ${reservationData['Lopetusaika']}'),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          String reservationKey = entry.key;
                                          databaseReference
                                              .child(
                                                  'reservations/vieraspaikka/$uid/$reservationKey')
                                              .remove()
                                              .then((_) {})
                                              .catchError((error) {
                                            print('$error');
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 35,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const AutoVaraukset(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Näytä kaikki vieraspaikan varaukset',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
              },
            ),
            StreamBuilder<Map<String, dynamic>>(
              stream: getPyykkiReservationData(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> pyykkiSnapshot) {
                final pyykkiData = pyykkiSnapshot.data ?? {};
                final hasPyykkiData = pyykkiData.isNotEmpty;

                return !hasPyykkiData
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          const Text(
                            'Pyykkituvan varaukset',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: const EdgeInsets.all(10.0),
                            child: Column(
                              children: pyykkiData.entries.map<Widget>((entry) {
                                final reservationData = entry.value is Map
                                    ? entry.value.cast<String, dynamic>()
                                    : <String, dynamic>{};

                                return Column(
                                  children: [
                                    ListTile(
                                      shape: const Border(bottom: BorderSide()),
                                      leading: const Icon(Icons.water_drop),
                                      title: Text(
                                          'Päivämäärä: ${reservationData['Päivämäärä']}'),
                                      subtitle: Text(
                                          'Aloitusaika: ${reservationData['Aloitusaika']}, Lopetusaika: ${reservationData['Lopetusaika']} Laitenumero: ${reservationData['laite']}'),
                                      isThreeLine: true,
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          String reservationKey = entry.key;
                                          databaseReference
                                              .child(
                                                  'reservations/pyykkitupa/$uid/$reservationKey')
                                              .remove()
                                              .then((_) {})
                                              .catchError((error) {
                                            print('$error');
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 35,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const PyykkiVaraukset(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Näytä kaikki pyykkituvan varaukset',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
              },
            ),
            StreamBuilder<Map<String, dynamic>>(
              stream: getSaunaReservationData(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> saunaSnapshot) {
                final saunaData = saunaSnapshot.data ?? {};
                final hasSaunaData = saunaData.isNotEmpty;

                return !hasSaunaData
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          const Text(
                            'Saunan varaukset',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            margin: const EdgeInsets.all(10.0),
                            child: Column(
                              children: saunaData.entries.map<Widget>((entry) {
                                final reservationData = entry.value is Map
                                    ? entry.value.cast<String, dynamic>()
                                    : <String, dynamic>{};

                                return Column(
                                  children: [
                                    ListTile(
                                      shape: const Border(bottom: BorderSide()),
                                      leading: const Icon(Icons.hot_tub),
                                      title: Text(
                                          'Päivämäärä: ${reservationData['Päivämäärä']}'),
                                      subtitle: Text(
                                          'Aloitusaika: ${reservationData['Aloitusaika']}, Lopetusaika: ${reservationData['Lopetusaika']}'),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          String reservationKey = entry.key;
                                          databaseReference
                                              .child(
                                                  'reservations/sauna/$uid/$reservationKey')
                                              .remove()
                                              .then((_) {})
                                              .catchError((error) {
                                            print('$error');
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 35,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SaunaVaraukset(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Näytä kaikki saunavaraukset',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
              },
            ),
            // Show "No reservations" text only if all three streams are empty
            StreamBuilder<Map<String, dynamic>>(
              stream: getAutoReservationData(),
              builder: (context, autoSnapshot) {
                final hasAutoData = autoSnapshot.hasData &&
                    (autoSnapshot.data ?? {}).isNotEmpty;
                return StreamBuilder<Map<String, dynamic>>(
                  stream: getPyykkiReservationData(),
                  builder: (context, pyykkiSnapshot) {
                    final hasPyykkiData = pyykkiSnapshot.hasData &&
                        (pyykkiSnapshot.data ?? {}).isNotEmpty;
                    return StreamBuilder<Map<String, dynamic>>(
                      stream: getSaunaReservationData(),
                      builder: (context, saunaSnapshot) {
                        final hasSaunaData = saunaSnapshot.hasData &&
                            (saunaSnapshot.data ?? {}).isNotEmpty;
                        if (!hasAutoData && !hasPyykkiData && !hasSaunaData) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Ei varauksia',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                          ));
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      drawer: MainDrawer(activePage: 'Varauskalenteri'),
    );
  }
}

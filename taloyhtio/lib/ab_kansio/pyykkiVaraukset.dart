import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:naytto/ab_kansio/varauskalenteri.dart';

class PyykkiVaraukset extends StatelessWidget {
  const PyykkiVaraukset({super.key});

  @override
  Widget build(BuildContext context) {
    // Firebase setit
    final databaseReference = FirebaseDatabase.instance.ref();
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;

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

    Stream<List<Map<String, dynamic>>> getPyykkiReservationData() {
      return databaseReference
          .child('reservations/pyykkitupa/$uid')
          .orderByChild('Päivämäärä')
          .onValue
          .map((event) {
        final value = event.snapshot.value;
        if (value is Map<dynamic, dynamic>) {
          final List<Map<String, dynamic>> dataList = [];
          value.forEach((key, value) {
            final Map<String, dynamic> dataMap = {
              'key': key,
              ...value.cast<String, dynamic>()
            };
            dataList.add(dataMap);
          });
          try {
            dataList.sort((a, b) {
              final aDate = parseCustomDate(a['Päivämäärä']);
              final bDate = parseCustomDate(b['Päivämäärä']);
              return aDate.compareTo(bDate);
            });
          } catch (e) {
            print('Error parsing date: $e');
            print('Problematic date: ${value['Päivämäärä']}');
          }
          return dataList;
        } else {
          return <Map<String, dynamic>>[];
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Pyykkituvan varaukset',
            style: Theme.of(context).textTheme.titleLarge!),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VarausKalenteri(),
              ),
            );
          },
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.all(10.0),
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: getPyykkiReservationData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Column(
                          children: data.map<Widget>((reservationData) {
                            return ListTile(
                              shape: const Border(bottom: BorderSide()),
                              leading: const Icon(Icons.water_drop),
                              title: Text(
                                'Päivämäärä: ${reservationData['Päivämäärä']}',
                              ),
                              subtitle: Text(
                                  'Aloitusaika: ${reservationData['Aloitusaika']}, Lopetusaika: ${reservationData['Lopetusaika']} Laitenumero: ${reservationData['laite']}'),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  String reservationKey =
                                      reservationData['key'];
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
                            );
                          }).toList(),
                        );
                      } else {
                        return const Text('Ei varauksia');
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

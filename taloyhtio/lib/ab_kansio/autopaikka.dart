// Rikun tekemä
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naytto/ab_kansio/varauskalenteri.dart';
import 'package:table_calendar/table_calendar.dart';

class AutoPaikka extends StatefulWidget {
  const AutoPaikka({super.key});
  @override
  State<AutoPaikka> createState() => _AutoPaikkaState();
}

class _AutoPaikkaState extends State<AutoPaikka> {
  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

  // Firebase setit
  User? user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.ref();

  DateTime today = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = const TimeOfDay(hour: 20, minute: 0);
  bool isAllDay = false;
  // SelectedHours käytössä "tuntivarauksissa"
  List<int> selectedHours = [];

  Map<DateTime, List<dynamic>> _events = {};
  // Parsetetaan oikeaan muotoon, ylimääräinen homma jotta firebasesta on helpompi
  // nähdä mikä päivä on varattu etc. "Päivämäärän mukaan"
  DateTime parseDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length == 3) {
        return DateTime.utc(
            int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
      }
    } catch (e) {
      print("Error parsing date: $e");
    }
    return DateTime.now().toUtc();
  }

  // Haetaan kaikki vieraspaikka varaukset// Käytössä tablecalendar
  void _fetchReservations() {
    databaseReference
        .child('reservations/vieraspaikka')
        .onValue
        .listen((event) {
      // mounted return lisätty, jotta ei tule muistiongelmia initstate //
      if (!mounted) return;
      // Tehdään muuttuja johon tulee Mapissa {} tiedot firebasesta
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      Map<DateTime, List<dynamic>> newEvents = {};
      data.forEach((key, value) {
        if (value is! Map) return;
        value;
        value.forEach((id, details) {
          if (details is! Map) return;
          final detailsMap = details;
          if (!detailsMap.containsKey('Päivämäärä')) return;
          final date = parseDate(detailsMap['Päivämäärä']);
          if (!newEvents.containsKey(date)) {
            newEvents[date] = [detailsMap];
          } else {
            newEvents[date]!.add(detailsMap);
          }
        });
      });
      setState(() {
        _events = newEvents;
      });
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final events = _events[day] ?? [];
    return events;
  }

  List<int> _getReservedHoursForSpot(DateTime day, int spotNumber) {
    final eventsForDay = _getEventsForDay(day);
    final reservedHours = <int>[];

    for (final event in eventsForDay) {
      final startTime = TimeOfDay(
          hour: int.parse(event['Aloitusaika'].split('.')[0]),
          minute: int.parse(event['Aloitusaika'].split('.')[1]));
      final endTime = TimeOfDay(
          hour: int.parse(event['Lopetusaika'].split('.')[0]),
          minute: int.parse(event['Lopetusaika'].split('.')[1]));

      for (int hour = startTime.hour; hour < endTime.hour; hour++) {
        reservedHours.add(hour);
      }
    }

    return reservedHours;
  }

  void _showReservationSuccessBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Text(
            'Varaus onnistui',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
      },
    );
  }

  void _reserveParkingSlot() async {
    // startTime on päivän ensimmäinen valittu tunti ja endTime viimeinen
    final startTime = TimeOfDay(hour: selectedHours.first, minute: 0);
    final endTime = TimeOfDay(
        hour: selectedHours.last + 1,
        minute: 0); // !!+1, koska varaus loppuu seuraavan tunnin alussa!!

    // Leivotaan Json muotoon joka lähetetään Firebaseen
    // Userid, autopaikka&numero, PVM, Aloitusaika & lopetusaika
    final parkingData = {
      "user_id": user!.uid,
      "Vieraspaikka": 1,
      "Päivämäärä":
          "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}",
      "Aloitusaika": formatTimeOfDay(startTime),
      "Lopetusaika": formatTimeOfDay(endTime),
    };
    // Helpottaa firebasessa lukemista eli näkyy päivä,kk,vuosi,aloitusaika&lopetusaika
    String reservationId =
        '${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}_${startTime.hour.toString().padLeft(2, '0')}${startTime.minute.toString().padLeft(2, '0')}-${endTime.hour.toString().padLeft(2, '0')}${endTime.minute.toString().padLeft(2, '0')}';

    await databaseReference
        .child('reservations/vieraspaikka/${user!.uid}/$reservationId')
        .set(parkingData);

    setState(() {
      selectedHours.clear();
      isAllDay = false;
    });
  }

  // Valitaan päivä, käytössä TableCalendarissa
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  // Formatoidaan tunti ja minuutti "Suomalaiseksi", eli ei PM & AM US-muotoja
  String formatTimeOfDay(TimeOfDay tod) {
    final String hour = tod.hour.toString().padLeft(2, '0');
    final String minute = tod.minute.toString().padLeft(2, '0');
    return '$hour.$minute';
  }

  void _toggleAllDaySelection(bool value) {
    setState(() {
      isAllDay = value;
      selectedHours.clear();
      if (isAllDay) {
        // Lisää kaikki tunnit valittuihin tunteihin
        for (int i = 0; i < 24; i++) {
          selectedHours.add(i);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Vieraspaikan varaus',
            style: Theme.of(context).textTheme.titleLarge!),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Column(
            children: [
              Text(
                "Valittu päivä: ${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 14),
              ),
              TableCalendar(
                locale: 'fi_FI',
                rowHeight: 43,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 17),
                  titleTextFormatter: (date, locale) {
                    return '${DateFormat.MMMM(locale).format(date)[0].toUpperCase()}${DateFormat.MMMM(locale).format(date).substring(1)} ${DateFormat.y(locale).format(date)}';
                  },
                ),
                calendarFormat: width >= 600
                    ? CalendarFormat.twoWeeks
                    : CalendarFormat.month,
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, today),
                focusedDay: today,
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2030, 3, 14),
                onDaySelected: _onDaySelected,
                startingDayOfWeek: StartingDayOfWeek.monday,
                eventLoader: _getEventsForDay,
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    return Positioned(
                      right: 1,
                      bottom: 1,
                      child: _buildEventsMarker(date, events),
                    );
                  },
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                  weekendStyle: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                  dowTextFormatter: (date, locale) =>
                      DateFormat.EEEE(locale).format(date)[0].toUpperCase() +
                      DateFormat.EEEE(locale).format(date).substring(1, 2),
                ),
                calendarStyle: const CalendarStyle(
                  defaultTextStyle: TextStyle(color: Colors.black),
                  weekendTextStyle: TextStyle(color: Colors.black),
                  todayTextStyle: TextStyle(color: Colors.black),
                  outsideTextStyle: TextStyle(color: Colors.grey),
                  todayDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 14, 195, 227),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 0, 73, 133),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        "Ei vapaita aikoja",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        "Vähän vapaita aikoja",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        "Paljon vapaita aikoja",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Valitse kellonajat",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 4,
                children: List.generate(24, (index) {
                  final isReserved =
                      _getReservedHoursForSpot(today, 1).contains(index);
                  final isSelected = selectedHours.contains(index);
                  return ChoiceChip(
                    padding: const EdgeInsets.all(0),
                    label: Text(
                      '${index.toString().padLeft(2, '0')}-${(index + 1).toString().padLeft(2, '0')}',
                      style: const TextStyle(color: Colors.black),
                    ),
                    selected: isSelected && !isReserved,
                    selectedColor: Colors.green,
                    showCheckmark: false,
                    disabledColor: Colors.blueGrey[400],
                    backgroundColor: isReserved ? Colors.red : null,
                    onSelected: isReserved
                        ? null
                        : (bool selected) {
                            setState(() {
                              if (selected) {
                                // Lisätään aika listaan vain, jos  sitä ei ole siellä jo!
                                if (!selectedHours.contains(index)) {
                                  selectedHours.add(index);
                                }
                              } else {
                                // Poistetaan tunti listasta
                                selectedHours.remove(index);
                              }
                              // Sortilla tunnit järjestykseen!
                              selectedHours.sort();
                              print(selectedHours);
                            });
                          },
                  );
                }),
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                title: Text(
                  "Varaa koko päiväksi",
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
                value: isAllDay,
                activeTrackColor: Colors.green[400],
                inactiveTrackColor: const Color.fromARGB(255, 14, 195, 227),
                thumbColor: const MaterialStatePropertyAll(Colors.black),
                onChanged: _toggleAllDaySelection,
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    selectedHours.isEmpty ? Colors.blueGrey : Colors.green[400],
                  ),
                  padding: const MaterialStatePropertyAll(
                    EdgeInsets.only(left: 80, right: 80, top: 12, bottom: 12),
                  ),
                ),
                onPressed: selectedHours.isNotEmpty
                    ? () {
                        _reserveParkingSlot(); // Send data
                        Navigator.of(context)
                            .pop(); // Navigate to previous page
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => VarausKalenteri()));
                        _showReservationSuccessBottomSheet(context);
                      }
                    : null,
                child: Text(
                  'Tee vieraspaikkavaraus',
                  style: Theme.of(context).textTheme.titleMedium!,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    int reservedHoursCount = 0;

    for (var event in events) {
      if (event.containsKey('Vieraspaikka') && event['Vieraspaikka'] == 1) {
        final startTime = TimeOfDay(
            hour: int.parse(event['Aloitusaika'].split('.')[0]),
            minute: int.parse(event['Aloitusaika'].split('.')[1]));
        final endTime = TimeOfDay(
            hour: int.parse(event['Lopetusaika'].split('.')[0]),
            minute: int.parse(event['Lopetusaika'].split('.')[1]));

        for (int hour = startTime.hour; hour < endTime.hour; hour++) {
          reservedHoursCount++;
        }
      }
    }
    // Näytetään käyttäjälle vapaat tunnit
    int freeHoursCount = 24 - reservedHoursCount;
    Color color = Colors.green;

    if (freeHoursCount == 0) {
      color = Colors.red; // Ei vapaata aikaa
    } else if (freeHoursCount <= 12) {
      color = Colors.orange; // Alle tai puolet päivästä on vapaana
    } else {
      color = Colors.green; // Enemmän kuin puolet päivästä on vapaana
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 11.0,
      height: 11.0,
    );
  }
}

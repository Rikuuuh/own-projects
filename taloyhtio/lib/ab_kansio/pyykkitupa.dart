import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:naytto/ab_kansio/varauskalenteri.dart';
import 'package:table_calendar/table_calendar.dart';

class PyykkiTupa extends StatefulWidget {
  const PyykkiTupa({Key? key}) : super(key: key);

  @override
  State<PyykkiTupa> createState() => _PyykkiTupaState();
}

class _PyykkiTupaState extends State<PyykkiTupa> {
  int? selectedHour;
  User? user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.ref();
  DateTime today = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = const TimeOfDay(hour: 20, minute: 0);
  bool isAllDay = false;
  Set<int> selectedHours = {};
  String? laite;

  Map<DateTime, List<dynamic>> _events = {};

  @override
  void initState() {
    super.initState();
    _fetchReservations();
  }

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

  void _fetchReservations() {
    databaseReference.child('reservations/pyykkitupa').onValue.listen((event) {
      if (!mounted) return;
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

  Set<int> _getReservedHoursForSpot(DateTime day, int spotNumber) {
    final eventsForDay = _getEventsForDay(day);
    final reservedHours = <int>{};

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
      isDismissible: true, // Allow dismissing by tapping outside
      enableDrag: true, // Allow dragging to dismiss
      builder: (BuildContext context) {
        // Wrap with Builder to access context

        return Container(
          padding: EdgeInsets.all(20),
          child: Text(
            'Varaus onnistui',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        );
      },
    );
  }

  void _reserveAndNavigateBack() async {
    if (selectedHour != null && laite != null) {
      final startTime = TimeOfDay(hour: selectedHour!, minute: 0);
      final endTime = TimeOfDay(hour: selectedHour! + 1, minute: 0);

      final pyykkitupaData = {
        "user_id": user!.uid,
        "laite": laite,
        "Päivämäärä":
            "${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}",
        "Aloitusaika": formatTimeOfDay(startTime),
        "Lopetusaika": formatTimeOfDay(endTime),
      };

      String reservationId =
          '${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}_${startTime.hour.toString().padLeft(2, '0')}${startTime.minute.toString().padLeft(2, '0')}-${endTime.hour.toString().padLeft(2, '0')}${endTime.minute.toString().padLeft(2, '0')}';

      await databaseReference
          .child('reservations/pyykkitupa/${user!.uid}/$reservationId')
          .set(pyykkitupaData);

      setState(() {
        selectedHour = null;
        isAllDay = false;
      });

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VarausKalenteri(),
        ),
      );
      _showReservationSuccessBottomSheet(context);
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final String hour = tod.hour.toString().padLeft(2, '0');
    final String minute = tod.minute.toString().padLeft(2, '0');
    return '$hour.$minute';
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  void _toggleAllDaySelection(bool value) {
    setState(() {
      isAllDay = value;
      selectedHours.clear();
      if (isAllDay) {
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
        title: Text('Pyykkituvan varaus',
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
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Text(
                "Valittu päivä: ${today.day.toString().padLeft(2, '0')}-${today.month.toString().padLeft(2, '0')}-${today.year}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TableCalendar(
                locale: 'fi_FI',
                rowHeight: 43,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: Theme.of(context).textTheme.titleLarge!,
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
              const SizedBox(height: 2),
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
                  final isSelected = selectedHour == index;
                  return ChoiceChip(
                    padding: const EdgeInsets.all(1),
                    label: Text(
                        '${index.toString().padLeft(2, '0')}-${(index + 1).toString().padLeft(2, '0')}'),
                    selected: isSelected && !isReserved,
                    selectedColor: Colors.green,
                    showCheckmark: false,
                    disabledColor: Colors.grey,
                    backgroundColor: isReserved ? Colors.red : null,
                    onSelected: isReserved
                        ? null
                        : (bool selected) {
                            setState(() {
                              if (selected) {
                                selectedHour = index;
                              } else {
                                selectedHour = null;
                              }
                            });
                          },
                  );
                }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) {
                    int i = index + 1;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          laite = i.toString();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: laite == i.toString()
                                ? Colors.blue
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'PyykkiTupa $i',
                              style: TextStyle(
                                color: laite == i.toString()
                                    ? Colors.blue
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.water_drop_sharp,
                              size: 20,
                              color: laite == i.toString()
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            Text(
                              laite == i.toString() ? 'Valittu' : 'Vapaana',
                              style: TextStyle(
                                color: laite == i.toString()
                                    ? Colors.blue
                                    : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 80, vertical: 12)),
                ),
                onPressed:
                    selectedHour != null ? _reserveAndNavigateBack : null,
                child: Text(
                  'Varaa pyykkitupa',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
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
      if (event.containsKey('pyykkitupa') && event['pyykkitupa'] == 1) {
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

    int freeHoursCount = 24 - reservedHoursCount;
    Color color = Colors.green;

    if (freeHoursCount == 0) {
      color = Colors.red;
    } else if (freeHoursCount <= 12) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 16.0,
      height: 16.0,
    );
  }
}

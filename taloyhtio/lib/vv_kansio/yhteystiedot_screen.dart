import 'package:flutter/material.dart';
import 'package:naytto/rh_kansio/main_drawer.dart';

import 'package:open_mail_app/open_mail_app.dart';

class YhteystiedotScreen extends StatelessWidget {
  const YhteystiedotScreen({super.key});

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Avaa sähköposti"),
          content: const Text("Sähköposti-sovelluksia ei ole asennettu"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yhteystiedot'),
      ),
      drawer: MainDrawer(
        activePage: 'Ota yhteyttä',
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                'Puh. 012 345 6789',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'taloyhtio123@email.com',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Lähetä sähköpostia taloyhtiölle!',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.mail),
                label: const Text("Avaa sähköposti"),
                onPressed: () async {
                  var result = await OpenMailApp.openMailApp();

                  // Jos sähköpostisovelluksia ei löydy, antaa errorin
                  if (!result.didOpen && !result.canOpen) {
                    showNoMailAppsDialog(context);

                    // iOS: antaa mahdollisuuden valita sähköpostisovelluksen,
                    // jos löytyy useampia
                  } else if (!result.didOpen && result.canOpen) {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return MailAppPickerDialog(
                          mailApps: result.options,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

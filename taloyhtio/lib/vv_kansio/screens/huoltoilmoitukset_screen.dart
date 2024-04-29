import 'package:flutter/material.dart';

class HuoltoilmoituksetScreen extends StatefulWidget {
  const HuoltoilmoituksetScreen({super.key});

  @override
  State<HuoltoilmoituksetScreen> createState() => _HuoltoilmoituksetScreenState();
}

class _HuoltoilmoituksetScreenState extends State<HuoltoilmoituksetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Huoltoilmoitukset'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Saunatilojen huolto',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        'Saunan kiuas epäkunnossa. Korjaus voi kestää useamman päivän.',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Text(
                        '11/03 klo. 12-14',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

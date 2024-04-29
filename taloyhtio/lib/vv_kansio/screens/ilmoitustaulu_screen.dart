import 'package:flutter/material.dart';

class IlmoitustauluScreen extends StatefulWidget {
  const IlmoitustauluScreen({super.key});

  @override
  State<IlmoitustauluScreen> createState() => _IlmoitustauluScreenState();
}

class _IlmoitustauluScreenState extends State<IlmoitustauluScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiedotteet'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        child: const Column(
          children: [
            Card(
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Taloyhtiön talkoot',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      'Taloyhtiön talkoisiin kaikki mukaan, jos mahdollista. Kaikille löytyy jonkinlaista tekemistä.',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Text(
                      '16/03 klo. 10-16',
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
    );
  }
}

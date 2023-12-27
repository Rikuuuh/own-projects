import 'package:flutter/material.dart';
import 'package:flappy_bird_game/main_drawer.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Aloitusalue',
          style: TextStyle(fontSize: 24),
        ),
      ),
      drawer: const MainDrawer(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              'Tervetuloa Mökkiolympialaisiin!',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 30),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ClipOval(
                      child: Image.asset(
                    'assets/images/miehet.png',
                    fit: BoxFit.fill,
                    width: 130,
                    height: 180,
                  )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipOval(
                      child: Image.asset(
                    'assets/images/naiset.png',
                    fit: BoxFit.fill,
                    width: 130,
                    height: 180,
                  )),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Valmistaudu ainutlaatuiseen seikkailuun, jossa yhdistyvät hauskuus, tieto ja taito.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Tietovisa - Testaa Tietosi:',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              'Oletko tietäjä vai tuurittaja? Selvitä kuinka hyvin tunnet mökkiolympialaisten historian ja salat tässä jännittävässä tietovisassa!',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Pelihetki - Olympic Bird:',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              'Näytä sormiesi nopeus ja taitavuus tässä koukuttavassa pelissä. Kuka teistä pääsee pisimmälle ja nappaa kultamitalin?',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Kisaajien Kunniajoukko:',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              'Tutustu muihin kisaajiin ja vertaile tuloksianne. Kuka on mökkiolympialaisten monitaituri?',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ).animate(
          effects: [
            const ScaleEffect(
                begin: Offset(0.2, 0.4),
                end: Offset(1.0, 1.0),
                duration: Duration(seconds: 5)),
            const FadeEffect(begin: 0, end: 1, duration: Duration(seconds: 3)),
          ],
        ),
      ),
    );
  }
}

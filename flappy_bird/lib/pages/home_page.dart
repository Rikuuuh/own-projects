import 'package:flappy_bird_game/components/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Etusivu // landingpage kun kirjautuu sisään
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showImageDialog(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        centerTitle: true,
        title: Text(
          'Aloitusalue',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 22),
        ),
        leading: const MenuWidget(),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                    .copyWith(fontSize: 35),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          _showImageDialog(context, 'assets/images/miehet.png'),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/miehet.png',
                          fit: BoxFit.fill,
                          width: 130,
                          height: 180,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          _showImageDialog(context, 'assets/images/naiset.png'),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/naiset.png',
                          fit: BoxFit.fill,
                          width: 130,
                          height: 180,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Valmistaudu ainutlaatuiseen seikkailuun, jossa yhdistyvät hauskuus, tieto ja taito.',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                'Tietovisa - Testaa Tietosi:',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 7),
              Text(
                'Onko sinulla tietoa vai onnea? Testaa tietämyksesi mökkiolympialaisten menneisyydestä ja mysteereistä tässä kiehtovassa visailussa!',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Pelihetki - Olympic Bird:',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 7),
              Text(
                'Näytä sormiesi nopeus ja taitavuus tässä koukuttavassa pelissä. Kuka pääsee pisimmälle ja nappaa pääpalkinnon?',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Hall of Fame:',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 7),
              Text(
                'Tutustu muihin kisaajiin ja vertaile tuloksianne. Kuka on mökkiolympialaisten monitaituri?',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ].animate(
              effects: [
                const FadeEffect(
                    curve: Curves.easeIn, duration: Duration(seconds: 2))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

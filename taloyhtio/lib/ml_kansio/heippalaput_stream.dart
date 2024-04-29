//HEIPPALAPPUTOIMINTOJEN KESKUS
//-WIDGETIN ALLA:
//models-kansiosta löytyy heippalappu.dart, jossa heippalapun sisältämien tietojen malli on määritelty
//widgets/heippalappurelated kansiosta löytyy
//
//heippalappu_list.dart<-heippalappu_item.dart, jotka luovat listan tässä widgetissä olevassa listassa olevista heippalapuista
//
//heippalappurelated kansiosta löytyy myös new_heippalappu.dart-tiedosto, joka on kytketty appBarissa olevaan lisäys kuvakkeeseen
//photo_delivery.dart tuottaa heippalappuun lapun lähettäneen käyttäjän kuvan

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:naytto/rh_kansio/main_drawer.dart';
import 'package:naytto/ml_kansio/models/heippalappu.dart';
import 'package:naytto/ml_kansio/widgets/heippalappurelated/heippalappu_list.dart';
import 'package:naytto/ml_kansio/widgets/heippalappurelated/new_heippalappu.dart';

User? currentUser;
String? uId;

//
int? omatViestitCount;

//
final databaseReference = FirebaseDatabase.instance.ref();

class HeippaLaput extends StatefulWidget {
  const HeippaLaput({super.key});

  @override
  State<HeippaLaput> createState() => _HeippaLaputState();
}

class _HeippaLaputState extends State<HeippaLaput> {
  //kuvan lisäys heippalappuun (toteutin omassa widgetissä)
  //late String imageUrl;
  final storage = FirebaseStorage.instance;
  //bool isSelected = false;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    uId = currentUser!.uid;
    omatViestitCount = 0;

    //kuvan lisäys heippalappuun
    //imageUrl = '';
    // getImageUrl;
  }

  final dB = FirebaseDatabase.instance.ref().child('laput').child('visible');

  //uuden heippalapuntallennuksen funktiot
  void _openAddHeippalappuOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => NewHeippalappu(onAddHeippalappu: _addFbHeippalappu),
    );
  }

//lapun lisäys FB
  void _addFbHeippalappu(Heippalappu heippalappu) async {
    final lappuData = {
      "title": heippalappu.title,
      "message": heippalappu.message,
      "id": heippalappu.id,
      "time": heippalappu.timeStamp,
      "likes": [],
      "dislikes": [],
      "reporters": []
    };

    if (omatViestitCount == 0 || omatViestitCount == null) {
      await databaseReference.child('laput/visible/$uId/').set(lappuData);
    } else /* if (omatViestitCount == 1)  */ {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vain yksi heippalappu kerrallaan, kiitos.'),
        ),
      );
    }
  }

  void _removeHeippalappu(Heippalappu heippalappu) async {
    final undoData = {
      "title": heippalappu.title,
      "message": heippalappu.message,
      "id": heippalappu.id,
      "time": heippalappu.timeStamp,
      "likes": heippalappu.likes,
      "dislikes": heippalappu.dislikes,
      "reporters": heippalappu.reporters
    };

//tämä tässä vain sen takia, että deletoidut viestit jäävät talteen adminia varten,
// timeStamppi tässä siksi, että saa rajoitettua poiston undon jälkeen vain yhteen
//viestiin
    await databaseReference
        .child('laput/deleted')
        .child(uId!)
        .child(heippalappu.timeStamp)
        .push()
        .set(undoData);
//
    await databaseReference
        .child('laput/visible')
        .child(uId!)
        .remove()
        .then((result) {
      setState(() {
        omatViestitCount = 0;
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.outlineVariant,
          duration: const Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal,
          content: Text(
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              'Heippalappu poistettu.'),
          action: SnackBarAction(
              textColor: Theme.of(context).colorScheme.inverseSurface,
              label: 'Peru poisto',
              onPressed: () async {
                await databaseReference
                    .child('laput/visible/$uId/')
                    .set(undoData);

                //kikkailin poiston rajoittumaan vain yhteen käyttäjän deletoimaan
                //viestiin asettamalla deletoidut viestit timeStampin alle (tuskin kukaan
                //on niin nopea että saa kaksi viestiä luotua ja poistettua samalla sekunnilla)
                await databaseReference
                    .child('laput/deleted/$uId/${heippalappu.timeStamp}')
                    .remove();

                setState(() {
                  omatViestitCount = 1;
                });
              }),
        ),
      );
    });
  }

  void _reportHeippalappu(Heippalappu heippalappu) async {
    //raportoijien Id:n tallennus listaan
    List updateReporters = heippalappu.reporters;
    if (!heippalappu.reporters.contains(uId)) {
      //jos käyttäjä ei ole vielä raportoinut viestiä, lisätään hänen käyttäjä-id:nsä raportoijien listalle
      updateReporters.add(uId);
    } else {
      //jos käyttäjä on jo raportoinut viestin, perutaan raportointi ja poistetaan käyttäjä-id listalta.
      updateReporters.remove(uId);
      /* setState(() {
        //reportNumber--;
        reportNumber = updateReporters.length;
        //isSelected = !isSelected;
      }); */
      //vaihtoehtona myös tehdä rajoittaminen ternaryoperaatiolla widgetissä, jossa raportointinappula
      //eli raportintinappula näkyy jos ei uId:tä löydy listalta
      //jos uId on jo listalle käyttäjä näkee raportoinnin perumispainikkeen raportointipainikkeen sijaan
      //täytyy tietty, myös tehdä funktio raportoinnin perumiseen
    }

    final reportData = {
      "title": heippalappu.title,
      "message": heippalappu.message,
      "id": heippalappu.id,
      "time": heippalappu.timeStamp,
      "likes": heippalappu.likes,
      "dislikes": heippalappu.dislikes,
      "reporters": updateReporters,

      //TIEDOKSI:
      //jos käyttäjällä on jo entuudestaan viesti reportedissa ja hän poistaa
      //edeltävän viesti, luo uuden ja saa siihenkin viisi raportointia kasaan
      //tämä funktio päällekirjoittaa reportedissa olevan tiedon. Tieto aiemmasta raportoidusta viestistä jää toki
      //talteen deleted osioon. Viesti ei poistu raportoiduista, mikäli käyttäjät peruvat raportointeja siinä määrin,
      //että määrä putoaa alle viiteen. Tämä ei ole mielestäni suuri ongelma. Ylläpidon hyvä tarkistaa
      //viesti asiattomuuksien varalta kumminkin.
    };

    //jos raportoijien määrä on uuden raportin jälkeen vielä alle 5,
    //tallennetaan tieto vain visible osioon.
    if (updateReporters.length < 5) {
      await databaseReference
          .child('laput/visible/${heippalappu.id}/')
          .update(reportData);

      //jos raportoijien määrä on 5 tai yli tiedot tallentuvat sekä visibleen
      //että reportediin
    } else if (updateReporters.length >= 5) {
      //päivitys visibleen
      await databaseReference
          .child('laput/visible/${heippalappu.id}/')
          .update(reportData);

      //tallennus reportediin, alkuun tsekataan onko viestistä jo raportoitu

      var checkIfNew =
          databaseReference.child('laput/reported/${heippalappu.id}');
      if (checkIfNew.path.isEmpty) {
        await databaseReference
            .child('laput/reported/${heippalappu.id}/')
            .set(reportData);
      } else {
        await databaseReference
            .child('laput/reported/${heippalappu.id}/')
            .update(reportData);
      }
      //ylläoleva if else homma on kyllä hieman turha. ilman sitäkin hoituu sama homma. tiedot vaan päällekirjoittuvat.
      //annan sen nyt olla näin.
    }
  }

  //LIKES
  void _likeHeippalappu(Heippalappu heippalappu) async {
    //lista olemassaolevista tykkääjistä
    List updateLikes = heippalappu.likes;
    //lista alapeukuista
    List updateDislikes = heippalappu.dislikes;

    //poistetaan alapeukku, jos uId listalla eikä uId:tä ole likes-listalla
    if (heippalappu.dislikes.contains(uId) &&
        !heippalappu.likes.contains(uId)) {
      updateDislikes.remove(uId);
    }

    if (!heippalappu.likes.contains(uId)) {
      //jos käyttäjä ei ole vielä tykännyt viestistä, lisätään hänen käyttäjä-id:nsä tykkääjien listalle
      updateLikes.add(uId);
    } else {
      //jos käyttäjä on jo tykännyt viestistä, perutaan tykkäys ja poistetaan käyttäjä-id listalta.
      updateLikes.remove(uId);
    }

    final likesData = {
      "likes": updateLikes,
      "dislikes": updateDislikes,
    };

    await databaseReference
        .child('laput/visible/${heippalappu.id}/')
        .update(likesData);
  }

  //DISLIKES
  void _dislikeHeippalappu(Heippalappu heippalappu) async {
    //lista olemassaolevista vihaajista
    List updateDislikes = heippalappu.dislikes;

    //lista olemassaolevista tykkääjistä
    List updateLikes = heippalappu.likes;
    //poistetaan yläpeukku, jos uId listalla eikä uId:tä ole dislikes-listalla
    if (heippalappu.likes.contains(uId) &&
        !heippalappu.dislikes.contains(uId)) {
      updateLikes.remove(uId);
    }

    if (!heippalappu.dislikes.contains(uId)) {
      //jos käyttäjä ei ole vielä tykännyt viestistä, lisätään hänen käyttäjä-id:nsä tykkääjien listalle
      updateDislikes.add(uId);
    } else {
      //jos käyttäjä on jo tykännyt viestistä, perutaan tykkäys ja poistetaan käyttäjä-id listalta.
      updateDislikes.remove(uId);
    }

    final dislikesData = {
      //MUUT ARVOT EIVÄT LIENE TARPEEN TÄSSÄKÄÄN
      "likes": updateLikes,
      "dislikes": updateDislikes,
    };

    await databaseReference
        .child('laput/visible/${heippalappu.id}/')
        .update(dislikesData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Heippalaput'),
          //Heippalapun lisäyspainike
          actions: [
            IconButton(
              onPressed: _openAddHeippalappuOverlay,
              icon: const Icon(Icons.note_add),
              tooltip: 'Lisää heippalappu',
            )
          ],
        ),
        drawer: MainDrawer(
          activePage: 'Heippalaput',
        ),
        body: Center(
          child: Column(
            children: [
              StreamBuilder(
                stream: dB.onValue,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snap.hasData &&
                      !snap.hasError &&
                      snap.data?.snapshot.value != null) {
                    var map = Map<Object?, Object?>.from(
                        snap.data!.snapshot.value as Map<Object?, Object?>);

                    List<Heippalappu> dataList = [];

                    map.forEach((key, value) {
                      dataList.add(
                          Heippalappu.fromJson(value as Map<Object?, Object?>));
//tsekataan onko käyttäjä jo postannut viestejä
                      if (value.values.any((element) => element == uId)) {
                        omatViestitCount = 1;
                      }

//heippalaput järjestykseen tuoreimmasta vanhimpaan
                      dataList
                          .sort((a, b) => b.timeStamp.compareTo(a.timeStamp));
                    });

                    return Expanded(
                      child: HeippalappuList(
                        heippalaput: dataList,
                        onRemoveHeippalappu: _removeHeippalappu,
                        currentUserId: currentUser!.uid,
                        onReportHeippalappu: _reportHeippalappu,
                        onLikeHeippalappu: _likeHeippalappu,
                        onDislikeHeippalappu: _dislikeHeippalappu,
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Center(
                        child: Text(
                          'Ei heippalappuja',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontSize: 15),
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

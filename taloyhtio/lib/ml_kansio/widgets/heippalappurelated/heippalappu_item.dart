import 'package:flutter/material.dart';
import 'package:naytto/ml_kansio/models/heippalappu.dart';
import 'package:naytto/ml_kansio/widgets/heippalappurelated/photo_delivery.dart';

class HeippalappuItem extends StatelessWidget {
  const HeippalappuItem(this.heippalappu,
      {super.key,
      required this.userId,
      required this.onRemoveHeippalappu,
      required this.onReportHeippalappu,
      required this.onLikeHeippalappu,
      required this.onDislikeHeippalappu});

  final Heippalappu heippalappu;
  final String userId;
  final Function(Heippalappu heippalappu) onRemoveHeippalappu;
  final Function(Heippalappu heippalappu) onReportHeippalappu;
  final Function(Heippalappu heippalappu) onLikeHeippalappu;
  final Function(Heippalappu heippalappu) onDislikeHeippalappu;

  @override
  Widget build(BuildContext context) {
    //tämän säätö-muuttujan ois voinut korvata alla ternary-operaatiolla.
    //päätin kuitenkin toteuttaa tällä tavalla selkeyden vuoksi, koska alhaalla
    // on jo entuudestaan yksi ternary.
    var reporting = TextButton.icon(
        onPressed: () {
          onReportHeippalappu(heippalappu);
        },
        icon: const Icon(Icons.hail_outlined),
        label: const Text(
          'Asiaton viesti',
        ));
    if (heippalappu.reporters.contains(userId)) {
      //raportoinnin peruminen käyttää samaa funktiota kuin raportoiminen
      reporting = TextButton.icon(
          onPressed: () {
            onReportHeippalappu(heippalappu);
          },
          icon: const Icon(Icons.cancel_rounded),
          label: const Text('Peru raportti'));
    }

    var likes = IconButton(
      enableFeedback: true,
      tooltip: 'Tykkää viestistä',
      icon: const Icon(Icons.thumb_up_off_alt),
      iconSize: 15,
      onPressed: () {
        //viittaus heippalappu_streamin funktioon
        onLikeHeippalappu(heippalappu);
      },
    );
    if (heippalappu.likes.contains(userId)) {
      //tykkäyksen peruminen
      likes = IconButton(
          enableFeedback: true,
          tooltip: 'Peru viestin tykkäys',
          icon: const Icon(Icons.thumb_up_off_alt_rounded),
          iconSize: 15,
          onPressed: () {
            onLikeHeippalappu(heippalappu);
          });
    }

    var dislikes = IconButton(
      enableFeedback: true,
      tooltip: 'Älä tykkää viestistä',
      icon: const Icon(Icons.thumb_down_off_alt_rounded),
      iconSize: 15,
      onPressed: () {
        //viittaus heippalappu_streamin funktioon
        onDislikeHeippalappu(heippalappu);
      },
    );
    if (heippalappu.dislikes.contains(userId)) {
      //tykkäämättömyyden peruminen käyttää samaa funktiota kuin ei tykkäminen
      dislikes = IconButton(
          enableFeedback: true,
          tooltip: 'Peru tykkäämättömyyden ilmaus',
          icon: const Icon(Icons.thumb_down_alt),
          iconSize: 15,
          onPressed: () {
            onDislikeHeippalappu(heippalappu);
          });
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color:
            Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.4),
      ),
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Theme.of(context).colorScheme.onSecondary,
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 13),
                          child: PhotoDelivery(uId: heippalappu.id)),
                      Expanded(
                        child: Text(
                          heippalappu.title,
                          softWrap: true,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  letterSpacing: 1.5,
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    heippalappu.message,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 15,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  const SizedBox(height: 7),
                  //poistonappi näkyy, jos oma viesti

                  userId == heippalappu.id
                      ? Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                onRemoveHeippalappu(heippalappu);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                            const Spacer(),
                            /* IconButton(
                                enableFeedback: true,
                                tooltip: 'Tykkäykset',
                                icon:
                                    const Icon(Icons.thumb_up_off_alt_rounded),
                                onPressed: () {
                                  //  onReportHeippalappu(heippalappu);
                                }), */
                            Column(
                              children: [
                                Text(
                                    'Tykkäykset: ${heippalappu.likes.length.toString()}'),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                    'Vihaajien määrä: ${heippalappu.dislikes.length.toString()}'),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            reporting,
                            const Spacer(),
                            likes,
                            Text(heippalappu.likes.length.toString()),
                            const SizedBox(
                              width: 5,
                            ),
                            dislikes,
                            Text(heippalappu.dislikes.length.toString()),

                            /* IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.thumb_up)) */
                          ],
                        ),
                ],
              ))),
    );
  }
}

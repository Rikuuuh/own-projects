import 'package:flutter/material.dart';
import 'package:naytto/ml_kansio/models/heippalappu.dart';
import 'package:naytto/ml_kansio/widgets/heippalappurelated/heippalappu_item.dart';

class HeippalappuList extends StatelessWidget {
  const HeippalappuList({
    super.key,
    required this.heippalaput,
    required this.onRemoveHeippalappu,
    required this.onReportHeippalappu,
    required this.onLikeHeippalappu,
    required this.onDislikeHeippalappu,
    required this.currentUserId,
  });
  //lista heippalappuja
  final List<Heippalappu> heippalaput;
  final void Function(Heippalappu heippalappu) onRemoveHeippalappu;
  final void Function(Heippalappu heippalappu) onReportHeippalappu;
  final void Function(Heippalappu heippalappu) onLikeHeippalappu;
  final void Function(Heippalappu heippalappu) onDislikeHeippalappu;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: heippalaput.length,
      itemBuilder: ((context, index) => HeippalappuItem(
            heippalaput[index],
            userId: currentUserId,
            onRemoveHeippalappu: onRemoveHeippalappu,
            onReportHeippalappu: onReportHeippalappu,
            onLikeHeippalappu: onLikeHeippalappu,
            onDislikeHeippalappu: onDislikeHeippalappu,
          )),
    );
  }
}

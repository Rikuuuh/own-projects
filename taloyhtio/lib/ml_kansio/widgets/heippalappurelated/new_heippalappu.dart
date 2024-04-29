import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:naytto/ml_kansio/models/heippalappu.dart';
import 'package:naytto/ml_kansio/widgets/heippalappurelated/nonowordlist.dart';

class NewHeippalappu extends StatefulWidget {
  const NewHeippalappu({super.key, required this.onAddHeippalappu});
  final void Function(Heippalappu uusiHeippalappu) onAddHeippalappu;

  @override
  State<NewHeippalappu> createState() => _NewHeippalappuState();
}

class _NewHeippalappuState extends State<NewHeippalappu> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final User? currentUser = FirebaseAuth.instance.currentUser;

//kirosanallisten otsikoiden ja viestien esto
  bool containsWordFromList(String text) {
    for (String word in nonoWordList) {
      if (text.toLowerCase().contains(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  void _submitHeippalappuData() {
    if (_titleController.text.trim().isEmpty ||
            _messageController.text.trim().isEmpty ||
            containsWordFromList(_titleController.text) == true ||
            containsWordFromList(_messageController.text) == true
        //||
        //_titleController.text.contains(perkele) ||
        //_messageController.text.contains('perkele')
        ) {
      //pitää tehdä parempi rajoitus kirosanoille
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Virhe tiedoissa'),
          content: const Text(
              'Täytäthän sekä otsikon että viestin ja vältä kirosanoja.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok!'),
            ),
          ],
        ),
      );
      return;
    }

    final timenow = DateTime.timestamp().toString();
    final timeInput = DateTime.parse(timenow).millisecondsSinceEpoch;
    //LIKES
    final List likesList = [];
    //DISLIKES
    final List dislikesList = [];
    //REPORTERS-ARVOON LIITTYVÄ
    final List reporterList = [];

    final tempLappu = Heippalappu(
      title: _titleController.text,
      message: _messageController.text,
      id: currentUser!.uid,
      timeStamp: timeInput.toString(),
      likes: likesList,
      dislikes: dislikesList,
      //REPORTERS-ARVOON LIITTYVÄ
      reporters: reporterList,
    );
    widget.onAddHeippalappu(tempLappu);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              maxLength: 40,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                label: Text('Otsikko'),
              ),
            ),
            TextField(
              controller: _messageController,
              maxLines: 3,
              maxLength: 140,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                label: Text('Viesti'),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _submitHeippalappuData,
              child: const Text('Tallenna heippalappu'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Peruuta'),
            )
          ],
        ));
  }
}

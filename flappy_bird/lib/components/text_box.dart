import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[600]),
              ),
              IconButton(onPressed: onPressed, icon: const Icon(Icons.settings))
            ],
          ),
          Text(text, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

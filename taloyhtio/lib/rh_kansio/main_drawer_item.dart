import 'package:flutter/material.dart';

class MainDrawerItem extends StatelessWidget {
  const MainDrawerItem(
      {required this.icon,
      required this.text,
      required this.onTap,
      this.isActive = false,
      super.key});

  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isActive
          ? Colors.blueGrey[500]
          : Theme.of(context).scaffoldBackgroundColor,
      leading: Icon(
        icon,
        size: 23,
        color:
            isActive ? const Color.fromARGB(255, 62, 217, 248) : Colors.black,
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontSize: 17,
            color: isActive
                ? const Color.fromARGB(255, 62, 217, 248)
                : Colors.black),
      ),
      onTap: onTap,
    );
  }
}

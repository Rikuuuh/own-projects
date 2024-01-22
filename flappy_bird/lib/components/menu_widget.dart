import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

// Käytössä joka sivun appbarissa, avaa ZoomDrawer widgetin (Menu_state.dart:in)

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => ZoomDrawer.of(context)!.toggle(),
        icon: Icon(Icons.menu,
            color: Theme.of(context).colorScheme.onSecondaryContainer),
      );
}

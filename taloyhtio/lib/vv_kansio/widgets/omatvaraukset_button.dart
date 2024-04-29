import 'package:flutter/material.dart';

class OmatVarauksetButton extends StatelessWidget {
  const OmatVarauksetButton({super.key, required this.title, required this.target});

  final String title;
  final Widget target;

  @override
  Widget build(BuildContext context) {
    return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => target,
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Spacer(),
                            Text(title, style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14
                            ),),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  );
  }
}
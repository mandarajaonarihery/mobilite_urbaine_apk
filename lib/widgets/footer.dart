import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onHistoryPressed;

  const CustomFooter({
    super.key,
    this.onNotificationPressed,
    this.onHistoryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width, // Largeur exacte de l'écran
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 170, 168, 168),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(31, 117, 115, 115),
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_active, color: Color(0xFF131313)),
              onPressed: onNotificationPressed ?? () {},
              iconSize: 30,
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.history, color: Color(0xFF131313)),
              onPressed: onHistoryPressed ?? () {},
              iconSize: 30,
            ),
          ],
        ),
      ),
    );
  }
}
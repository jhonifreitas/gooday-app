import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void _goToUser() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 22, top: 10, left: 15, right: 20),
              child: AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                    onPressed: _goToUser,
                    icon: const Icon(Icons.person_outline)),
                title: const Text('Meus Alertas'),
                actions: [
                  IconButton(
                      onPressed: _goToUser,
                      icon: const Icon(Icons.edit_square)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

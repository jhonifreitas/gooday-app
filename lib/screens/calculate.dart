import 'package:flutter/material.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
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
                title: const Text('Calculadora'),
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

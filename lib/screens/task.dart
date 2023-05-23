import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  void _goToUser() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 22, top: 10, left: 15, right: 20),
            child: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                  onPressed: _goToUser, icon: const Icon(Icons.person_outline)),
              title: const Text('Minhas Metas'),
              actions: [
                IconButton(
                    onPressed: _goToUser, icon: const Icon(Icons.edit_square)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TicketViewScreen extends StatefulWidget {
  const TicketViewScreen({super.key});

  @override
  State<TicketViewScreen> createState() => _TicketViewScreenState();
}

class _TicketViewScreenState extends State<TicketViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Ticket"),
      ),
    );
  }
}

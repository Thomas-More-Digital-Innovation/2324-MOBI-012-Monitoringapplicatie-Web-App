import 'package:flutter/material.dart';

class MijnProfiel extends StatefulWidget {
  const MijnProfiel({super.key});

  @override
  State<MijnProfiel> createState() => _MijnProfielState();
}

class _MijnProfielState extends State<MijnProfiel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mijn profiel'),
      ),
      body: const Center(
        child: Text('Mijn profiel'),
      ),
    );
  }
}

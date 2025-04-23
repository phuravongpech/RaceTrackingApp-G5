import 'package:flutter/material.dart';

class SegmentTrackingScreen extends StatelessWidget {
  const SegmentTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Segment Tracking')),
      body: Center(
        child: Text(
          'Segment Tracking Screen',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

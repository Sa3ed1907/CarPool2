import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip History'),
      ),
      body: Center(
        child: Text(
          'Your trip history will be displayed here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

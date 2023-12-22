import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              size: 100,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Your Name',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Your Email',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Implement the sign-out logic here
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

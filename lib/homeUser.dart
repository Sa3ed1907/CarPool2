import 'package:caruser/reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _RoutessState();
}

class _RoutessState extends State<HomePage> {
  bool isDrawerOpen = false;
  bool flag = false;
  CollectionReference trips = FirebaseFirestore.instance.collection('trips');
  TextEditingController searching = TextEditingController();

  @override
  void initState() {
    super.initState();
    searching.addListener(onTextChanged);
  }

  void onTextChanged() {
    String newText = searching.text;
    if (newText.isNotEmpty) {
      flag = true;
    } else {
      flag = false;
    }

    setState(() {});
  }

  void toggleDrawer() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  String? getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid; // Returns the user's ID (UID)
    }
    return null; // Returns null if the user is not authenticated
  }

  Future<List<Map<String, dynamic>>> getData() async {
    List<Map<String, dynamic>> userDataList = [];

    QuerySnapshot querySnapshot = await trips.get();

    // Loop through the documents in the query snapshot
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; // Add the document ID to the data map
      userDataList.add(data);
    }

    return userDataList;
  }

  Future<void> reserveTrip(String tripId) async {
    String? userId = getCurrentUserID();

    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('reservedTrips')
          .add({'tripId': tripId});
    }

    // You can add more logic here, such as updating the trip status
    // or showing a confirmation message to the user.
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple, // Set primary color
        hintColor: Colors.deepPurpleAccent, // Set accent color
        scaffoldBackgroundColor: Color(0xFF1A1A1A), // Set background color
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A), // Set app bar background color
        ),
        cardColor: Color(0xFF2A2A2A), // Set button color
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white), // Set text color
          bodyText2: TextStyle(color: Colors.white), // Set text color
          button: TextStyle(color: Colors.white), // Set button text color
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Trip Planner',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/main',
                  (route) => false,
                );
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searching,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  hintText: 'Search for trips',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: getData(),
                builder: (context, AsyncSnapshot<List<Map>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Driver Name: ${snapshot.data![i]['driverName']}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text('Time: ${snapshot.data![i]['time']}'),
                                  Text('From: ${snapshot.data![i]['from']}'),
                                  Text('To: ${snapshot.data![i]['to']}'),
                                  Text('Cost: ${snapshot.data![i]['cost']}'),
                                  Text(
                                    'Available seats: ${snapshot.data![i]['availableSeats']}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  // Navigate to the ReservationPage with trip ID
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReservationPage(
                                        tripId: snapshot.data![i]['id'],
                                      ),
                                    ),
                                  );
                                },
                                child: Text('Reserve Trip'),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

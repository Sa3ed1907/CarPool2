import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  final String tripId;

  ReservationPage({required this.tripId});

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  bool isCashOnDeliverySelected = false;

  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    cvvController.dispose();
    expiryDateController.dispose();
    super.dispose();
  }

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Card Number is required';
    }
    if (value.length != 16 || !int.tryParse(value)!.isFinite) {
      return 'Invalid Card Number';
    }
    return null;
  }

  String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry Date is required';
    }
    // Implement custom validation logic for expiry date if needed
    return null;
  }

  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }
    if (value.length != 3 || !int.tryParse(value)!.isFinite) {
      return 'Invalid CVV';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Trip ID: ${widget.tripId}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Payment Method:',
                style: TextStyle(fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: false,
                        groupValue: isCashOnDeliverySelected,
                        onChanged: (value) {
                          setState(() {
                            isCashOnDeliverySelected = value as bool;
                          });
                        },
                      ),
                      Text('Online Payment'),
                    ],
                  ),
                  SizedBox(width: 20),
                  Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: isCashOnDeliverySelected,
                        onChanged: (value) {
                          setState(() {
                            isCashOnDeliverySelected = value as bool;
                          });
                        },
                      ),
                      Text('Cash on Delivery'),
                    ],
                  ),
                ],
              ),
              if (!isCashOnDeliverySelected)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Credit Card Details:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: cardNumberController,
                      decoration: InputDecoration(
                        labelText: 'Card Number',
                        border: OutlineInputBorder(),
                        errorText:
                            validateCardNumber(cardNumberController.text),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: expiryDateController,
                            decoration: InputDecoration(
                              labelText: 'Expiry Date',
                              border: OutlineInputBorder(),
                              errorText:
                                  validateExpiryDate(expiryDateController.text),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: cvvController,
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              border: OutlineInputBorder(),
                              errorText: validateCVV(cvvController.text),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Add the Visa logo here
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'images/visa.png', // Adjust the path to your Visa logo
                          width: 200,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!isCashOnDeliverySelected) {
                    // Simulate a successful online payment
                    // You can add delay for simulation purposes
                    Future.delayed(Duration(seconds: 2), () {
                      // Show a pop-up message with animation
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AnimatedContainer(
                            duration: const Duration(
                                seconds: 1), // Adjust animation duration
                            curve: Curves.easeInOut, // Adjust animation curve
                            child: AlertDialog(
                              title: const Text('Payment Successful'),
                              content: const Text(
                                  'Your reservation has been confirmed.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // Close the dialog and navigate to the home page
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pushNamed('/home');
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    });
                  } else {
                    // For cash on delivery, mark the reservation as confirmed
                    // and navigate to a success page
                    // You can add your logic here
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple, // Background color
                  onPrimary: Colors.white, // Text color
                  elevation: 3, // Button shadow
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Button border radius
                  ),
                ),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0), // Adjust padding
                  child: const Center(
                    child: Text(
                      'Proceed to Payment',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

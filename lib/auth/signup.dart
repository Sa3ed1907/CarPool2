import 'package:caruser/auth/login.dart';
import 'package:caruser/component/myButton.dart';
import 'package:caruser/homeUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:caruser/component/myTextField.dart';
import 'package:caruser/component/squareTile.dart';

class Signup extends StatefulWidget {
  Signup({super.key});

  //Text Editing Controller

  @override
  State<Signup> createState() => _Signup();
}

class _Signup extends State<Signup> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  signUserUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: usernameController.text,
              password: passwordController.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
      } else {
        errorMessage = 'An error occurred, please try again later.';
      }

      // Show the error message to the user using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      // Handle other exceptions here
      String errorMessage =
          'An unexpected error occurred, please try again later.';
      print(e);

      // Show the error message to the user using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Image.asset(
                    "images/carpool-high-resolution-logo-black-transparent.png",
                    height: 85,
                    width: 85),
                const SizedBox(
                  height: 35,
                ),
                Text(
                  "Let's Create an account for you",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),

                // username field
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                //password field
                MyTextField(
                  controller: passwordController,
                  obscureText: true,
                  hintText: 'Password',
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  hintText: 'Enter your password again',
                ),

                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                MyButton(onTap: signUserUp, text: "SignUp"),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 0.6,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Or Continue With",
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 0.6,
                      ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    squareTile(imagePath: "images/google.png"),
                    SizedBox(
                      width: 20,
                    ),
                    squareTile(imagePath: "images/apple.png")
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "already have an account?",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login now!",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

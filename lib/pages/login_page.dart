// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gotaguig_admin/pages/dashboard.dart';
import 'package:gotaguig_admin/services/firestore_service.dart';
import 'package:window_manager/window_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double windowWidth = 0.0;
  double windowHeight = 0.0;

  bool isCredentialsCorrect = false;



  @override
  void initState() {
    super.initState();
    _getWindowWidth();
  }

  Future<void> _getWindowWidth() async {
    Size size = await windowManager.getSize();
    setState(() {
      windowWidth = size.width;
      windowHeight = size.height;
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final TextEditingController username = TextEditingController();
    final TextEditingController password = TextEditingController();
    return Scaffold(
      body: Container(
        height: windowHeight,
        width: windowWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.shade700, Colors.redAccent.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/logo/GoTaguig_Logo.png",
              scale: 1.5,
            ),
            SizedBox(height: windowHeight * 0.01),
            const Text(
              'GoTaguig! Admin',
              style: TextStyle(
                  color: Colors.white, fontFamily: "ConcertOne", fontSize: 30),
            ),
            SizedBox(height: windowHeight * 0.05),

            // Username TextField
            Padding(
              padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.35),
              child: TextField(
                cursorColor: Colors.white,
                obscureText: false,
                controller: username,
                expands: false,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon:
                      const Icon(Icons.person, color: Colors.yellowAccent),

                  // Label style size
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: "ConcertOne",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),

                  // Border Styles
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.white, // White border for the enabled state
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors
                          .yellowAccent, // White border when the field is focused
                      width: 2.0, // Optional: you can increase the border width
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.red, // Red border for the error state
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.red, // Red border when focused with error
                      width: 2.0,
                    ),
                  ),
                ),
                style: const TextStyle(
                    fontFamily: "ConcertOne",
                    color: Colors.white,
                    fontSize: 14), // Text color set to white
              ),
            ),

            SizedBox(height: windowHeight * 0.02),
            // Password TextField
            Padding(
              padding: EdgeInsets.symmetric(horizontal: windowWidth * 0.35),
              child: TextField(
                cursorColor: Colors.white,
                obscureText: true,
                controller: password,
                expands: false,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon:
                      const Icon(Icons.lock, color: Colors.yellowAccent),

                  // Label style size
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontFamily: "ConcertOne",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),

                  // Border Styles
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.white, // White border for the enabled state
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors
                          .yellowAccent, // White border when the field is focused
                      width: 2.0, // Optional: you can increase the border width
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.red, // Red border for the error state
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.red, // Red border when focused with error
                      width: 2.0,
                    ),
                  ),
                ),
                style: const TextStyle(
                    fontFamily: "ConcertOne",
                    color: Colors.white,
                    fontSize: 14), // Text color set to white
              ),
            ),

            SizedBox(height: windowHeight * 0.05),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.black,
                    fixedSize: Size(windowWidth * 0.29, windowHeight * 0.06)),
                onPressed: () async {
                  bool isAdminValidated = await FirestoreService()
                      .validateUser(username.text, password.text);

                  if (isAdminValidated == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Dashboard(),
                        ));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text("Wrong Username or Password"),
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                      fontFamily: "ConcertOne",
                      color: Colors.white,
                      fontSize: 18),
                ))
          ],
        ),
      ),
    );
  }
}

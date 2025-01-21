import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void login() {
    if (_formKey.currentState!.validate()) {
      String enteredEmail = emailController.text.trim();
      String enteredPassword = passwordController.text.trim();

      if (enteredEmail == 'kavach1@gmail.com' && enteredPassword == 'kavach@123') {
        navigateToHomePage();
        Fluttertoast.showToast(
          msg: "Logged in as $enteredEmail",
        );
      } else {
        Fluttertoast.showToast(
          msg: "Invalid email or password.",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 250,
                  child: Image.asset(
                    "assets/log6.png",
                  ),
                ),
                Text(
                  "Admin Login",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color(0xFF5C343E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  height: 2,
                  width: 150,
                  color: Colors.black12,
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: EdgeInsets.all(16.0),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Email",
                            hintStyle: TextStyle(fontSize: 17),
                            prefixIcon: Icon(
                              Icons.email,
                              size: 20,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Email";
                            } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return "Enter valid email";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: EdgeInsets.all(16.0),
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: "Password",
                            hintStyle: TextStyle(fontSize: 17),
                            prefixIcon: Icon(
                              Icons.lock,
                              size: 20,
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4C2559),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.90,
                              MediaQuery.of(context).size.height * 0.07,
                            ),
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
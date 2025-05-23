import 'package:flutter/material.dart';
import 'package:kidergarten/components/myButton.dart';
import 'package:kidergarten/components/textField.dart';
import 'package:kidergarten/pages/teacher.dart';
import 'package:kidergarten/pages/teacherDashboard.dart';
import 'package:kidergarten/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; // Gives the width
    double screenHeight = MediaQuery.of(context).size.height;

    final ApiService apiService = ApiService();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: screenWidth,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 79, 41, 159),
          Color.fromARGB(255, 2 + 11 * 16, 10 * 16 + 2, 14 * 16 + 3)
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: screenHeight * .7,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * .05,
                ),
                Image.asset(
                  "assets/tableau.png",
                  scale: 1,
                ),
                SizedBox(
                  height: screenHeight * .05,
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: Color.fromARGB(255, 79, 41, 159), fontSize: 35),
                ),
                Text(
                  "Log into your account",
                  style: TextStyle(
                      color: Color.fromARGB(255, 139, 139, 139), fontSize: 15),
                ),
                SizedBox(
                  height: screenHeight * .01,
                ),
                myTextField(
                  labelText: 'Email',
                  icon: Icons.email,
                  controller: emailController,
                ),
                SizedBox(
                  height: screenHeight * .01,
                ),
                myTextField(
                    labelText: 'Password',
                    controller: passwordController,
                    icon: Icons.password),
                SizedBox(
                  height: screenHeight * .05,
                ),
                myOutlinedButton(
                  text: "Submit",
                  onTap: () async {
                    print('🔐 Attempting to log in...');
                    final response = await apiService.loginUser(
                      'nox',
                      'nox',
                    );

                    if (response != null) {
                      print('✅ Login successful, token saved.');

                      // Try to extract user info from token
                      final userData = await apiService.getUserFromToken();
                      if (userData != null) {
                        print(
                            '🧾 User extracted from token: ${userData['id']}, ${userData['name']}');

                        // Use the extracted user data to fetch parent info
                        final parentInfo = await apiService.getParentInfo(
                            '67e865fa467eeb7c40462f0a', 'ESI'
                            //userData['id'],
                            //userData['name'],
                            );
                        print('👨‍👩‍👧 Parent Info: $parentInfo');
                        if (parentInfo != null) {
                          print('👨‍👩‍👧 Parent Info: $parentInfo');
                        } else {
                          print('⚠️ No parent info found or error occurred.');
                        }
                      } else {
                        print('❌ Failed to extract user info from token.');
                      }
                    } else {
                      print('❌ Login failed, cannot fetch parent info.');
                    }
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TeacherHomePage(),
                        ));
                  },
                ),
                SizedBox(
                  height: screenHeight * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: Colors.grey, // Grey text
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "create one",
                        style: TextStyle(
                          color: Colors.purple, // Purple text
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

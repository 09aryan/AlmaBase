import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/constent/inputText.dart';
import 'package:frontend/constent/pp_picker.dart';
import 'package:frontend/screens/signin.dart';
import 'package:frontend/screens/upDateBio.dart';
import 'package:frontend/services/register.dart';
import 'package:frontend/services/updateBio.dart';

import 'package:neopop/neopop.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Text(
                  'Welcome to Almabase',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ProfileImagePicker(
              pickedImage: _pickedImage,
              onImagePicked: (File image) {
                setState(() {
                  _pickedImage = image;
                });
              },
            ),
            SizedBox(height: 15),
            inputTextt(
              label: 'UserName',
              icon: Icons.person_2_outlined,
              controller: userName,
            ),
            SizedBox(height: 20),
            inputTextt(
              label: 'Full Name',
              icon: Icons.person_2_outlined,
              controller: fullName,
            ),
            SizedBox(height: 20),
            inputTextt(
              label: 'Email',
              icon: Icons.email_outlined,
              controller: email,
            ),
            SizedBox(height: 20),
            inputTextt(
              label: 'Password',
              icon: Icons.password_outlined,
              controller: password,
            ),
            SizedBox(height: 20),
            NeoPopTiltedButton(
              isFloating: true,
              onTapUp: () async {
                if (_pickedImage != null) {
                  await RegistrationService.registerUser(
                    fullName: fullName.text,
                    userName: userName.text,
                    email: email.text,
                    password: password.text,
                    pickedImage: _pickedImage!,
                    context: context,
                  );
                } else {
                  print('Please select an image');
                }
              },
              decoration: const NeoPopTiltedButtonDecoration(
                color: Color.fromRGBO(255, 235, 52, 1),
                plunkColor: Color.fromRGBO(255, 235, 52, 1),
                shadowColor: Color.fromRGBO(36, 36, 36, 1),
                showShimmer: true,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 70.0,
                  vertical: 15,
                ),
                child: Text('Register'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0, top: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateBioPage()),
                  );
                },
                child: Text(
                  'Already have an account? Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

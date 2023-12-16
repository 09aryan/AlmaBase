import 'package:flutter/material.dart';
import 'package:frontend/constent/inputText.dart';
import 'package:frontend/screens/signup.dart';
import 'package:frontend/services/LoginService.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20.0),
                      Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 10.0),
                      Image.asset(
                        'assets/logo.png', // Replace with the correct path to your image
                        width: 180.0,
                        height: 180.0,
                      ),
                      SizedBox(height: 10.0),
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
                        onTapUp: () {
                          LoginService.loginUser(
                              context: context,
                              email: email.text,
                              password: password.text);
                        },
                        decoration: const NeoPopTiltedButtonDecoration(
                          color: Color(0xFF757575),
                          plunkColor: Color(0XFFFAFAFA),
                          shadowColor: Color(0xFF757575),
                          border: Border.fromBorderSide(
                            BorderSide(color: Color(0XFFFAFAFA), width: 1),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 130.0, vertical: 15),
                          child: Text('Login',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
                },
                child: Text(
                  'Don\'t have an account? Sign Up',
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

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
}

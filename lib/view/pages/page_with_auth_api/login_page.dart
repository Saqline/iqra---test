

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iqra/view/pages/page_with_verify_api/email_verify/email_verify.dart';
import 'package:iqra/view/pages/page_with_verify_api/reset_password/reset_pass_email_verify.dart';
import 'package:iqra/models/constants.dart';
import 'package:iqra/view/pages/home_page.dart';
import 'package:iqra/view/pages/page_with_auth_api/registration_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = "";

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final email = _emailController.toString();
    final password = _passwordController.toString();
    final host = 'http://fg.ikra.my';

    final response = await http.post(
      Uri.parse("$host/authWeb"),
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['ev'] == 0){
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => EmailVerificationScreen(email: email,),
        ),
      );
      }else{
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(),
        ),
      );
      }
      
    } else {
      setState(() {
        _errorMessage = "Invalid email or password";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!value.contains("@")) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                  child:
                      _isLoading ? CircularProgressIndicator() : Text("Login"),
                ),
                SizedBox(height: 16.0),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(fontSize: 20, color: buttonColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Forget Password? ',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PasswordResetScreen(),
                        ),
                      ),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 20, color: buttonColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



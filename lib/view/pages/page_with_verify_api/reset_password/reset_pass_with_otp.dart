// ignore_for_file: nullable_type_in_catch_clause

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iqra/view/pages/page_with_auth_api/login_page.dart';

class ResetPasswordPage extends StatefulWidget {
  String email;
  ResetPasswordPage(this.email);
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      String email = _emailController.text;
      String otp = _otpController.text;
      String password = _passwordController.text;

      try {
        // Call API to reset password
        await PasswordResetApi().resetPassword(email, otp, password);
        // Navigate to login page after successful reset
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen(),
          ),
        );
      }
      //
      catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'An unknown error occurred';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(                 //controller: _emailController,
                   widget.email,
                  ),                           
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'OTP',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the OTP sent to your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your new password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                if (_isLoading)
                  Center(
                    child: CircularProgressIndicator(),
                  )
                else if (_errorMessage.isNotEmpty)
                  Center(
                    child: Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _resetPassword();
                  },
                  child: Text('Reset Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordResetApi {
  static const String baseUrl = 'http://fg.ikra.my';

  Future<bool> resetPassword(String email, String otp, String password) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/resetPass'),
      body: {
        'email': email,
        'otp': otp,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to reset password');
    }
  }
}

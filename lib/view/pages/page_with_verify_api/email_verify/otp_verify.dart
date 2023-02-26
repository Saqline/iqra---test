import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iqra/view/pages/home_page.dart';

class VerifOtpScreen extends StatefulWidget {
  final String email;
  VerifOtpScreen({required this.email});

  @override
  _VerifOtpScreenState createState() => _VerifOtpScreenState();
}

class _VerifOtpScreenState extends State<VerifOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _submitOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final otp = _otpController.text.trim();
        await EmailVerifyApi().verifyOtp(widget.email, otp);
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(),
        ),
      );
      } catch (error) {
        setState(() {
          _errorMessage = error.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter 6-digit OTP sent to ${widget.email}',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter OTP';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitOTP,
                      child: Text('Submit'),
                    ),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailVerifyApi {
  Future<bool> verifyOtp(String email, String otp) async {
    final response = await http.patch(
      Uri.parse('http://fg.ikra.my/verifyEmail'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(<String, String>{'emailotp': otp}),
    );
    
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to verify OTP: ${response.body}');
    }
  }
}
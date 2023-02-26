import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  EmailVerificationScreen({required this.email});

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isLoading = false;

  void _verifyEmail() async {
    setState(() {
      _isLoading = true;
    });

    final String email = widget.email;
    final String url = "http://fg.ikra.my/emailOtp";

    try {
      final response = await http.patch(Uri.parse(url), body: {"email": email});

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => EmailVerificationScreen(
              email: email,
            ),
          ),
        );

        // handle successful response
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Success"),
            content: Text(responseData['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      } else {
        final responseData = json.decode(response.body);

        // handle error response
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text(responseData['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      // handle exception
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Something went wrong."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Email"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "A verification otp has been sent to ${widget.email}. Please check your email and click the link to verify your email address.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyEmail,
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text("Resend Verification Email"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

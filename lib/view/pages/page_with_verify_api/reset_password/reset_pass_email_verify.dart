import 'dart:convert';
import 'package:http/http.dart' as http;



import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iqra/view/pages/page_with_verify_api/reset_password/reset_pass_with_otp.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text.trim();
    final String url = "http://fg.ikra.my/resetPassword ";

    try {
      final response = await http.patch(Uri.parse(url), body: {"email": email});

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => ResetPasswordPage(email),
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
        title: Text("Reset Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email is required";
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return "Invalid email address";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                child: _isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text("Reset Password"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

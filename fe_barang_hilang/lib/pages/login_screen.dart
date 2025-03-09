import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.endsWith('@student.universitaspertamina.ac.id') && !value.endsWith('@universitaspertamina.ac.id')) {
                    return 'Only @student.universitaspertamina.ac.id or @universitaspertamina.ac.id emails are allowed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Lakukan login disini
                    String email = _emailController.text.trim();
                    String password = _passwordController.text.trim();

                    UserCredential? userCredential = await _authService.signInWithEmailAndPassword(email, password);

                    if (userCredential != null) {
                      // Login berhasil
                      print('Login successful!');
                      Navigator.pushReplacementNamed(context, '/home'); // Navigate ke home
                    } else {
                      // Login gagal
                      print('Login failed. Check your credentials.');
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login failed. Check your credentials.'))
                      );
                    }
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
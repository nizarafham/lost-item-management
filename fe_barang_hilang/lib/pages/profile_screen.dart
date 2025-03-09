import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

    class ProfileScreen extends StatefulWidget {
      @override
      _ProfileScreenState createState() => _ProfileScreenState();
    }

    class _ProfileScreenState extends State<ProfileScreen> {
      final AuthService _authService = AuthService();
      User? _currentUser;

      @override
      void initState() {
        super.initState();
        _currentUser = _authService.getCurrentUser();
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('Profile')),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Icon(Icons.person, size: 50), // Replace with user's profile picture
                ),
                SizedBox(height: 16),
                Text('Email: ${_currentUser?.email ?? 'N/A'}'),
                Text('Username: ${_currentUser?.displayName ?? 'N/A'}'),
                SizedBox(height: 24),
                Text('Ketentuan Aplikasi:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit...'),
                SizedBox(height: 16),
                Text('Versi Aplikasi: 1.0.0'),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    await _authService.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text('Logout'),
                ),
              ],
            ),
          ),
        );
      }
    }
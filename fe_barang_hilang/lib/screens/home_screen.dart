import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lost & Found Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Selamat Datang di Aplikasi Olivia!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
                Navigator.pushReplacementNamed(context, "/");
              },
              child: Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}

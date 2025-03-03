import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth_bloc/auth_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lost_found_screen.dart';
import 'screens/add_lost_item_screen.dart';
import 'screens/add_found_item_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lost & Found App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        routes: {
          "/home": (context) => HomeScreen(),
          "/lost_found": (context) => LostFoundScreen(),
          "/add_lost_item": (context) => AddLostItemScreen(),
          "/add_found_item": (context) => AddFoundItemScreen(),
        },
      ),
    );
  }
}

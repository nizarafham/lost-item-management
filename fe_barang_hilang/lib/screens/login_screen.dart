import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../blocs/auth_bloc/auth_event.dart';
import '../blocs/auth_bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, "/home");
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
                TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(
                      LoginEvent(email: emailController.text, password: passwordController.text),
                    );
                  },
                  child: Text("Login"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

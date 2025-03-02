import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../core/api_service.dart';
import '../../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService = ApiService();

  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await apiService.postData("login", {
          "email": event.email,
          "password": event.password,
        });

        if (response.statusCode == 200) {
          final user = User.fromJson(response.data);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('token', user.token);
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthError(message: "Login gagal"));
        }
      } catch (e) {
        emit(AuthError(message: "Terjadi kesalahan"));
      }
    });

    on<LogoutEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      emit(AuthInitial());
    });
  }
}

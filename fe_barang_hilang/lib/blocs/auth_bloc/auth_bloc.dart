import 'package:fe_barang_hilang/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../core/api_service.dart';
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
          final accessToken = response.data["access"]; // Ambil token dari JSON
          final refreshToken = response.data["refresh"];

          // Simpan token ke SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', accessToken);
          await prefs.setString('refresh_token', refreshToken);

          final user = User(email: event.email, token: accessToken);
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthError(message: "Login gagal. Periksa email dan password."));
        }
      } catch (e) {
        emit(AuthError(message: "Terjadi kesalahan saat login."));
      }
    });

    on<LogoutEvent>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('refresh_token');
      emit(AuthInitial());
    });
  }
}

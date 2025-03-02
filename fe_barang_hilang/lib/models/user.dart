class User {
  final String email;
  final String nim;
  final String token;

  User({required this.email, required this.nim, required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      nim: json['nim'],
      token: json['token'],
    );
  }
}

class UserModel {
  String? uid;
  String? email;
  String? username;
  String? photoURL;

  UserModel({this.uid, this.email, this.username, this.photoURL});

  // Menerima data dari Firebase
  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    email = map['email'];
    username = map['username'];
    photoURL = map['photoURL'];
  }

  // Mengirim data ke Firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'photoURL': photoURL,
    };
  }
}
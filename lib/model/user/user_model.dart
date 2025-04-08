class UserModel {
  int? id;
  String? uid;
  String? displayName;
  String? email;
  String? photoUrl;
  String? provider;
  String? token;

  UserModel({
    this.id,
    this.uid,
    this.displayName,
    this.email,
    this.photoUrl,
    this.provider,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      uid: json['uid'],
      displayName: json['displayName'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      provider: json['provider'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'provider': provider,
      'token': token,
    };
  }
}

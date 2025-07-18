class UserModel {
  int? id;
  String? uid;
  String? displayName;
  String? email;
  String? photoUrl;
  String? provider;
  String? token;
  int? credits;
  DateTime? deletedAt;

  UserModel({
    this.id,
    this.uid,
    this.displayName,
    this.email,
    this.deletedAt,
    this.credits,
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
      deletedAt: json['deleted_at'] == null ? null : DateTime.parse(json['deleted_at'].toString()),
      credits: json['credits'],
      photoUrl: json['photoUrl'],
      provider: json['provider'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'deleted_at': deletedAt,
      'displayName': displayName,
      'email': email,
      'credits': credits,
      'photoUrl': photoUrl,
      'provider': provider,
      'token': token,
    };
  }
}

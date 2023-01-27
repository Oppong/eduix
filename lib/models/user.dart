class User {
  User({
    this.id,
    this.email,
    this.token,
    this.name,
  });

  int? id;
  String? email;
  String? name;
  String? token;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      email: json['user']['email'],
      name: json['user']['name'],
      token: json['token'],
    );
  }
}

import 'package:app/model/user.dart';

class User {
  final int id;
  final String name;

  User(
      this.id,
      this.name
  );

  factory User.fromJson(Map<String,dynamic> json) => User(json['user']['id'], json['user']['name'],);
}

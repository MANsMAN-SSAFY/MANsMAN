import 'package:app/model/user.dart';
import 'package:flutter/cupertino.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
final Ip = "10.0.2.2:3000"; // 이거 localhost 수정해야함.

class User extends ChangeNotifier {
  String? _token;
  User? user;
}
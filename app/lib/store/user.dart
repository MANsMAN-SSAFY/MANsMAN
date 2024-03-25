import 'package:app/model/user.dart';
import 'package:flutter/cupertino.dart';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
final Ip = "https://j10e106.p.ssafy.io/api"; //

class User extends ChangeNotifier {
  String? _token;
  User? user;
}
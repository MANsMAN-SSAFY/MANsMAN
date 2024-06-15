// page

import 'package:app/pages/board_page.dart';
import 'package:app/pages/camera_page.dart';
import 'package:app/pages/cosmetics/cosmetics_favorites_page.dart';
import 'package:app/pages/cosmetics/cosmetics_detail_page.dart';
import 'package:app/pages/cosmetics/hair_page.dart';
import 'package:app/pages/cosmetics/maskpack_page.dart';
import 'package:app/pages/cosmetics/review_page.dart';
import 'package:app/pages/cosmetics/skincare_page.dart';
import 'package:app/pages/diary_page.dart';
import 'package:app/pages/login/login_page.dart';
import 'package:app/pages/login/splash_page.dart';
import 'package:app/pages/main_page.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/pages/notifications_page.dart';
import 'package:app/pages/profile/profile_page.dart';
import 'package:app/components/camera/analysis.dart';
import 'package:app/pages/serach_page.dart';
import 'package:app/pages/profile/setting_page.dart';
import 'package:app/pages/login/signup_page.dart';
import 'package:app/pages/board_detail_page.dart';
import 'package:app/pages/board_create_page.dart';
import 'package:app/pages/profile/others_profile_page.dart';

import 'package:app/store/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static final pages = {
    '/': (context) => const LoginPage(),
    '/splash': (context) => SplashPage(),
    // '/home': (context) => const HomePage(),
    '/main': (context) => const MainPage(),
    '/serach': (context) => const SearchPage(),
    '/signup': (context) => const SignupPage(),
    '/myProfile': (context) => ProfilePage(
          onTabSelected: (index) {},
        ),
    '/otherProfile': (context) => OtherProfilePage(
          onTabSelected: (index) {},
          memberId: ModalRoute.of(context)!.settings.arguments as int,
        ),
    '/setting': (context) => const SettingPage(),
    '/notifications': (context) => const NotificationsPage(),
    '/detail': (context) => const BoardDetailPage(),
    '/skin': (context) => SkinPage(),
    '/hair': (context) => HairPage(),
    '/maskpack': (context) => MaskPackPage(),
    // '/cosmetics_detail': (context) => const CosmeticsDetailPage(),
    '/favorites': (context) => const CosmeticsFavoritesPage(),
    '/diary': (context) => const DiaryPage(),
    '/review': (context) => ReviewPage(),
    '/create': (context) => const BoardCreatePage(),
    '/board': (context) => const BoardPage(),
    '/camera': (context) => const CameraPage(),
  };

  static const login = '/';
  static const home = '/home';
  static const main = '/main';
  static const serach = '/serach';
  static const signup = '/signup';
  static const myprofile = '/myProfile';
  static const otherprofile = '/otherProfile';
  static const setting = '/setting';
  static const notifications = '/notifications';
  static const detail = '/detail';
  static const skin = '/skin';
  static const hair = '/hair';
  static const maskpack = '/maskpack';
  static const cosmetics_detail = '/cosmetics_detail';
  static const favorites = '/favorites';
  static const diary = '/diary';
  static const splash = '/splash';
  static const review = '/review';
  static const create = '/create';
  static const board = '/board';
  static const camera = '/camera';
}

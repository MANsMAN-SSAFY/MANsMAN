// 패키지
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/components/Modal/new_nickname_modal.dart';
import 'package:app/pages/board_page.dart';
import 'package:app/pages/camera_page.dart';
import 'package:app/pages/cosmetics/cosmetics_page.dart';
import 'package:app/pages/diary_page.dart';
import 'package:app/pages/home_page.dart';
import 'package:app/store/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// components
import 'package:app/components/myProfile_image.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/store/router.dart';

// style
import 'package:app/common/style/app_colors.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomePageState();
}

class _HomePageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? result;
  final storage = FlutterSecureStorage();
  final Dio dio = Dio();

  Future<Map<String, dynamic>> getProfile() async {
    print('여기 통과');
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    String apiUrl = 'https://j10e106.p.ssafy.io/api/members/profiles';
    try {
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      print('여기는 통과하나');

      result = response.data as Map<String, dynamic>;

      print(result?['nickname']);
      if (result?['nickname'] == null) {
        _showNicknameModal(context);
      }
      return response.data;
    } on DioException catch (e) {
      // 에러 핸들링
      print("Error occurred while fetching search results: ${e.message}");
      return {};
    }
  }

  late TabController controller; // late 나중에 이 값이 선언됨

  int index = 0; // 최초의 값
  final int _selectedIndex = 0; // 외부 라우터

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfile();
    controller = TabController(length: 4, vsync: this);
    controller.addListener(tabListener); // 여기에서 리스너를 추가합니다.

    // 사용자 정보를 Provider로부터 가져옴
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<User>(context, listen: false);
      final nickname = userProvider.profile?['nickname'];

      // 닉네임이 없으면 모달 띄움
      // if (result?['nickname'] == null) {
      //   _showNicknameModal(context);
      // }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final router = Provider.of<MainRouter>(context, listen: false);
      setState(() {
        controller.index = router.routeIndex; // MainRouter의 인덱스로 초기화
      });
      controller.addListener(tabListener); // TabController의 인덱스 변경 감지
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // arguments에서 tabIndex 가져오기
  //   final args = ModalRoute.of(context)?.settings.arguments as Map?;
  //   if (args != null && args['tabIndex'] != null) {
  //     int newIndex = args['tabIndex'];
  //     if (controller.length > newIndex) {
  //       // 새로운 index가 유효한지 확인
  //       setState(() {
  //         _selectedIndex = newIndex;
  //         controller.animateTo(newIndex); // TabController의 index를 업데이트
  //       });
  //     }
  //   }
  // }

  void _showNicknameModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const NewNicknameModal();
      },
    );
  }

  @override
  void dispose() {
    controller.removeListener(tabListener); // dispose에서 리스너를 제거합니다.
    super.dispose();
  }

  void tabListener() {
    if (!mounted) return;
    final router = Provider.of<MainRouter>(context, listen: false);
    // MainRouter의 인덱스를 현재 TabController의 인덱스로 업데이트
    router.setIndex(controller.index);
  }

  @override
  Widget build(BuildContext context) {
    final router = Provider.of<MainRouter>(context);

    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.iconBlack,
        unselectedItemColor: AppColors.iconBlack.withOpacity(0.3),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: router.routeIndex, // MainRouter의 인덱스를 사용
        onTap: (int newIndex) {
          router.setIndex(newIndex); // MainRouter의 인덱스 업데이트
          controller.animateTo(newIndex); // TabController의 인덱스 업데이트
        },
        items: const [
          BottomNavigationBarItem(
            icon: AppIcons.home,
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: AppIcons.camera,
            label: '카메라',
          ),
          BottomNavigationBarItem(
            icon: AppIcons.cosmetics,
            label: '맨픽',
          ),
          BottomNavigationBarItem(
            icon: AppIcons.board,
            label: '게시판',
          ),
        ],
      ),
      child: TabBarView(
        physics:
            const NeverScrollableScrollPhysics(), // 가로 스크롤을 방지해서, 위아래 스크롤에 영향을 주지 않도록 함.
        controller: controller,
        children: const [
          DiaryPage(),
          // HomePage(),
          CameraPage(),
          CosmeticsPage(),
          BoardPage(),
        ],
      ),
    );
  }
}

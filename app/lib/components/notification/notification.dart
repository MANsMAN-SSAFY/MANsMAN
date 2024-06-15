import 'dart:async';

import 'package:app/config/app_routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/store/notification/noti.dart';
import 'package:app/components/notification/firestore.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/store/router.dart';

class NotificationComponent extends StatefulWidget {
  String token;
  NotificationComponent({
    super.key,
    required this.token,
  });

  @override
  State<NotificationComponent> createState() => _NotificationComponentState();
}

class _NotificationComponentState extends State<NotificationComponent> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("noti")
          .where("token", isEqualTo: widget.token)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // 로딩 상태 처리
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // 에러 처리
          return Text('Error: ${snapshot.error}');
        } else {
          // 데이터가 정상적으로 도착한 경우
          List<QueryDocumentSnapshot> notiDocs =
              snapshot.data!.docs; // 데이터 가져오기
          List<Notis> notisList = notiDocs
              .map((doc) =>
                  Notis.fromJson(doc.id, doc.data() as Map<String, dynamic>))
              .toList();

          return SingleChildScrollView(
            child: notisList.isEmpty
                ? Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 100,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "새로운 알림이 없습니다",
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    children: notisList
                        .asMap()
                        .entries
                        .toList()
                        .reversed
                        .map(
                          (entry) => TextButton(
                            onPressed: () {
                              // 클릭 이벤트 처리
                              if (entry.value.type == "community") {
                                Navigator.of(context).popAndPushNamed(
                                    AppRoutes.detail,
                                    arguments: entry.value.data['id']);
                                print(entry.value.data['id']);
                                firestore
                                    .collection('noti')
                                    .doc(entry.value.docId)
                                    .delete();
                              } else {
                                final router = Provider.of<MainRouter>(context,
                                    listen: false);
                                // 타겟 탭의 인덱스를 설정합니다.
                                router.setIndex(
                                    0); // 예를 들어 '추천 화장품' 탭으로 이동하려면 인덱스를 1로 설정
                                // MainPage로 이동합니다.
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AppRoutes.main,
                                  ModalRoute.withName('/'),
                                );
                                firestore
                                    .collection('noti')
                                    .doc(entry.value.docId)
                                    .delete();
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 15,
                                            ),
                                            decoration: const BoxDecoration(
                                              color: AppColors.blue,
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                right: Radius.circular(20),
                                                left: Radius.circular(20),
                                              ),
                                            ),
                                            child: Text(
                                              entry.value.type == "community"
                                                  ? "커뮤니티"
                                                  : "리마인드",
                                              style: const TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            entry.value.notification["title"],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        entry.value.time.length >= 17
                                            ? '${entry.value.time.substring(5, 10)}${entry.value.time.substring(10, 16)}'
                                            : entry.value
                                                .time, // 길이가 충분히 길지 않을 때는 그대로 출력
                                        style: const TextStyle(
                                          color: AppColors.tag,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    entry.value.notification["body"],
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 1.0,
                                    width: double.infinity,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          );
        }
      },
    );
  }
}

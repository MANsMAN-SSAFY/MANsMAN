import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> fireStoreInit({notification, data, type, time, token}) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Firestore에서 자동으로 생성된 문서 ID를 사용하여 문서를 추가합니다.
  DocumentReference docRef = await firestore.collection("noti").add(
    {
      "notification": notification,
      "data": data,
      "type": type,
      'time': time,
      "token": token,
    },
  );

  print('firebase 통신');
  print('추가된 알림의 ID: ${docRef.id}'); // 추가된 알림의 ID를 출력합니다.
}

// // 일련번호를 생성하는 함수
// Future<int> _generateDocumentId() async {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   // 'noti' 컬렉션의 문서 개수를 조회합니다.
//   QuerySnapshot snapshot = await firestore.collection("noti").get();

//   // 현재 문서 개수를 기반으로 일련번호를 생성합니다.
//   int nextId = snapshot.size + 1;

//   return nextId;
// }

class Notis {
  final String docId; // 문서 ID 추가
  final Map<String, dynamic> notification;
  final Map<String, dynamic> data;
  final String type;
  final String time;

  Notis({
    required this.docId, // 생성자에 문서 ID 추가
    required this.notification,
    required this.data,
    required this.type,
    required this.time,
  });

  factory Notis.fromJson(String docId, Map<String, dynamic> json) {
    // JSON에서 docId를 가져와 Notis 객체 생성
    return Notis(
      docId: docId, // 문서 ID 설정
      notification: json['notification'],
      data: json['data'],
      type: json['type'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notification': notification,
      'data': data,
      'type': type,
      'time': time,
    };
  }
}

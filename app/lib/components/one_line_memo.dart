// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// import 'package:app/components/Modal/memo_ui.dart';

// class OneLineMemo extends StatefulWidget {
//   final String? memo;

//   const OneLineMemo({
//     super.key,
//     this.memo,
//   });

//   @override
//   State<OneLineMemo> createState() => _OneLineMemoState();
// }

// class _OneLineMemoState extends State<OneLineMemo> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(10),
//       color: const Color.fromARGB(255, 241, 241, 241),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 '한줄메모',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Color.fromARGB(255, 0, 0, 0),
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return const MemoUI();
//                     },
//                   );
//                 },
//                 icon: const Icon(Icons.edit_document),
//               ),
//             ],
//           ),
//           Text(widget.memo ?? '메모가 없습니다'),
//         ],
//       ),
//     );
//   }
// }

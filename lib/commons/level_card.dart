// import 'package:english_test_app/controller/level_controller.dart';
// import 'package:english_test_app/model/question_model.dart';
// import 'package:english_test_app/theme/colors.dart';
// import 'package:english_test_app/theme/dimens.dart';
// import 'package:english_test_app/utils/utils.dart';
// import 'package:english_test_app/widget/app_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:get/get.dart';
//
// class LevelCard extends StatefulWidget {
//   final General general;
//
//   const LevelCard({Key key, this.general}) : super(key: key);
//
//   @override
//   _LevelCardState createState() => _LevelCardState();
// }
//
// class _LevelCardState extends State<LevelCard> {
//   final LevelController levelController = Get.find();
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             AppText(
//               text: widget.general.nameGeneral,
//               color: AppColors.clickableText,
//             ),
//             Dimens.height10,
//             RatingBar.builder(
//               unratedColor: Colors.yellow,
//               initialRating: double.tryParse(widget.general.rate.toString()),
//               minRating: 0,
//               direction: Axis.horizontal,
//               allowHalfRating: true,
//               itemCount: 5,
//               itemSize: 20,
//               itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
//               itemBuilder: (context, _) => Icon(
//                 Icons.star_border,
//                 color: Colors.amber,
//               ),
//               onRatingUpdate: (rating) {
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

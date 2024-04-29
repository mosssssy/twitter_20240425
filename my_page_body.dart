// StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('tweets')
//             .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//             .orderBy('createdAt', descending: true)
//             .snapshots(),
//         builder: (context,
//             AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // データのロード中はローディング状態を表示
//             return const SizedBox.shrink();
//           } else if (snapshot.hasError) {
//             // エラーが発生した場合はエラーメッセージを表示
//             return Text('Error: ${snapshot.error}');
//           } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: SizedBox(
//                   width: double.infinity,
//                   child: StreamBuilder<Object>(
//                       stream: FirebaseFirestore.instance
//                           .collection('users')
//                           .doc(myUserId)
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const SizedBox.shrink();
//                         }
//                         if (snapshot.hasData == false) {
//                           return const SizedBox.shrink();
//                         }
//                         final DocumentSnapshot<Map<String, dynamic>>?
//                             documentSnapshot = snapshot.data
//                                 as DocumentSnapshot<Map<String, dynamic>>?;
//                         if (documentSnapshot == null ||
//                             !documentSnapshot.exists) {
//                           // ドキュメントが存在しない場合の処理
//                           return const SizedBox.shrink();
//                         }
//                         final Map<String, dynamic> userDataMap =
//                             documentSnapshot.data()!;
//                         final UserData userData =
//                             UserData.fromJson(userDataMap);

//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             if (userData.imageUrl != '')
//                               ClipOval(
//                                 child: Image.network(
//                                   userData.imageUrl,
//                                   width: 100,
//                                   height: 100,
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                             else
//                               ClipOval(
//                                 child: Image.asset(
//                                   'assets/images/default_user_icon.png',
//                                   width: 100,
//                                   height: 100,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             MarginSizedBox.smallHeightMargin,
//                             Text(
//                               userData.userName,
//                               style: CustomFontSize.bigFontSize,
//                             ),
//                             MarginSizedBox.smallHeightMargin,
//                             Text(myUserEmail ?? ''),
//                             MarginSizedBox.miniHeightMargin,
//                             Text(
//                               userData.profileIntroduction,
//                               style: CustomFontSize.mediumFontSize,
//                             ),
//                             MarginSizedBox.mediumHeightMargin,
//                           ],
//                         );
//                       }),
//                 ),
//               ),
//             );
//           }
//           // 目標形： [{}, {}, {}]
//           // 現在：   ⭕️💎[{}, {}, {}]💎⭕️
//           final QuerySnapshot<Map<String, dynamic>> querySnapshot =
//               snapshot.data!;
//           // 現在：   💎[{}, {}, {}]💎
//           final List<QueryDocumentSnapshot<Map<String, dynamic>>> listData =
//               querySnapshot.docs;
//           // 現在：   [🐶{}🐶, 🐶{}🐶, 🐶{}🐶]
//           return ListView.builder(
//             cacheExtent: 250.0 * 10.0,
//             itemCount: listData.length,
//             itemBuilder: (context, index) {
//               final QueryDocumentSnapshot<Map<String, dynamic>>
//                   queryDocumentSnapshot = listData[index];
//               Map<String, dynamic> mapData = queryDocumentSnapshot.data();
//               // ゴール！： [{}, {}, {}]
//               TweetData tweetData = TweetData.fromJson(mapData);

//               UserData userName;
//               UserData imageUrl;

//               return Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: 
//                     FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                         future: FirebaseFirestore.instance
//                             .collection('users')
//                             .doc(tweetData.userId)
//                             .get(),
//                         builder: (context, userSnapshot) {
//                           if (userSnapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const SizedBox.shrink();
//                           }

//                           if (userSnapshot.hasError) {
//                             return Text('Error: ${userSnapshot.error}');
//                           }
//                           final DocumentSnapshot<Map<String, dynamic>>
//                               documentSnapshot = userSnapshot.data!;
//                           final Map<String, dynamic> userMap =
//                               documentSnapshot.data()!;
//                           final UserData postUser = UserData.fromJson(userMap);
//                           return Column(
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Row(
//                                     children: [
//                                       (postUser.imageUrl != '')
//                                           ? ClipOval(
//                                               child: Image.network(
//                                                 postUser.imageUrl,
//                                                 width: 50,
//                                                 height: 50,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             )
//                                           :
//                                           //imageUrlが空文字だったら
//                                           ClipOval(
//                                               child: Image.asset(
//                                                 'assets/images/default_user_icon.png',
//                                                 width: 50,
//                                                 height: 50,
//                                                 fit: BoxFit.cover,
//                                               ),
//                                             ),
//                                       MarginSizedBox.miniWidthMargin,
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             postUser.userName,
//                                             overflow: TextOverflow.ellipsis,
//                                             maxLines: 1,
//                                             style: CustomFontSize
//                                                 .boldMediumFontSize,
//                                           ),
//                                           Text(
//                                             DateFormat('yyyy年MM月dd日 HH:mm')
//                                                 .format(tweetData.createdAt
//                                                     .toDate()),
//                                             style: CustomFontSize.smallFontSize,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   IconButton(
//                                     onPressed: () {
//                                       showConfirmDialog(
//                                           context: context,
//                                           text: '本当に削除しますか？',
//                                           onPressed: () async {
//                                             Navigator.pop(context);
//                                             await FirebaseFirestore.instance
//                                                 .collection('tweets')
//                                                 .doc(tweetData.tweetId)
//                                                 .delete();
//                                             bottomShowToast('削除成功しました');
//                                           });
//                                     },
//                                     icon: const Icon(
//                                       Icons.close,
//                                       color: Colors.deepPurple,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               MarginSizedBox.miniHeightMargin,
//                               Container(
//                                 // ignore: sort_child_properties_last
//                                 child: Row(
//                                   children: [
//                                     (tweetData.addedImageUrl.isNotEmpty)
//                                         ? Row(
//                                             children: [
//                                               Image.network(
//                                                 tweetData.addedImageUrl,
//                                                 width: 75,
//                                                 height: 75,
//                                                 fit: BoxFit.scaleDown,
//                                               ),
//                                               MarginSizedBox.smallWidthMargin,
//                                             ],
//                                           )
//                                         : const SizedBox.shrink(),
//                                     Expanded(
//                                         child: Text(tweetData.tweetContent)),
//                                   ],
//                                 ),
//                                 width: double.infinity,
//                                 color: Colors.white,
//                                 padding: const EdgeInsets.all(16.0),
//                               ),
//                             ],
//                           );
//                         }),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
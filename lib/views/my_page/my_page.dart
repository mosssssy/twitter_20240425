import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_20240425/common_widget/close_only_dialog.dart';
import 'package:twitter_20240425/common_widget/confirm_dialog.dart';
import 'package:twitter_20240425/common_widget/custom_font_size.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';
import 'package:twitter_20240425/data_models/tweetdata/tweetdata.dart';
import 'package:twitter_20240425/data_models/userdata/userdata.dart';
import 'package:twitter_20240425/functions/global_functions.dart';
import 'package:twitter_20240425/views/my_page/edit_email/edit_email_page.dart';
import 'package:twitter_20240425/views/my_page/edit_profile/edit_icon_page.dart';
import 'package:twitter_20240425/views/my_page/edit_profile/edit_profile_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final String? myUserEmail = FirebaseAuth.instance.currentUser!.email;
    String? myUserId = FirebaseAuth.instance.currentUser!.uid;
    UserData userData;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PROFILE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: Colors.deepPurple[100],
      body: ListView(
        children: [
          MarginSizedBox.mediumHeightMargin,
          StreamBuilder<Object>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(myUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                if (snapshot.hasData == false) {
                  return const SizedBox.shrink();
                }
                final DocumentSnapshot<Map<String, dynamic>>? documentSnapshot =
                    snapshot.data as DocumentSnapshot<Map<String, dynamic>>?;
                if (documentSnapshot == null || !documentSnapshot.exists) {
                  // ドキュメントが存在しない場合の処理
                  return const SizedBox.shrink();
                }
                final Map<String, dynamic> userDataMap =
                    documentSnapshot.data()!;
                userData = UserData.fromJson(userDataMap);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (userData.imageUrl != '')
                      ClipOval(
                        child: Image.network(
                          userData.imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      ClipOval(
                        child: Image.asset(
                          'assets/images/default_user_icon.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    MarginSizedBox.smallHeightMargin,
                    Text(
                      userData.userName,
                      style: CustomFontSize.bigFontSize,
                    ),
                    MarginSizedBox.smallHeightMargin,
                    Text(myUserEmail ?? ''),
                    MarginSizedBox.miniHeightMargin,
                    Text(
                      userData.profileIntroduction,
                      style: CustomFontSize.mediumFontSize,
                    ),
                    MarginSizedBox.mediumHeightMargin,
                  ],
                );
              }),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tweets')
                .where('userId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData == false || snapshot.data == null) {
                return const SizedBox.shrink();
              }
              // 目標形： [{}, {}, {}]
              // 現在：   ⭕️💎[{}, {}, {}]💎⭕️
              final QuerySnapshot<Map<String, dynamic>> querySnapshot =
                  snapshot.data!;
              // 現在：   💎[{}, {}, {}]💎
              final List<QueryDocumentSnapshot<Map<String, dynamic>>> listData =
                  querySnapshot.docs;
              // 現在：   [🐶{}🐶, 🐶{}🐶, 🐶{}🐶]
              return ListView.builder(
                shrinkWrap: true, //追加
                physics: const NeverScrollableScrollPhysics(), //追加
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  final QueryDocumentSnapshot<Map<String, dynamic>>
                      queryDocumentSnapshot = listData[index];
                  Map<String, dynamic> mapData = queryDocumentSnapshot.data();
                  // ゴール！： [{}, {}, {}]
                  TweetData tweetData = TweetData.fromJson(mapData);
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(tweetData.userId)
                            .snapshots(),
                        builder: (context, userSnapshot) {
                          // print(userSnapshot);
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (userSnapshot.hasError) {
                            return Text('Error: ${userSnapshot.error}');
                          }

                          final DocumentSnapshot<Map<String, dynamic>>
                              documentSnapshot = userSnapshot.data!;
                          final Map<String, dynamic> userMap =
                              documentSnapshot.data()!;
                          final UserData postUser = UserData.fromJson(userMap);
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      (postUser.imageUrl != '')
                                          ? ClipOval(
                                              child: Image.network(
                                                postUser.imageUrl,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          :
                                          //imageUrlが空文字だったら
                                          ClipOval(
                                              child: Image.asset(
                                                'assets/images/default_user_icon.png',
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                      MarginSizedBox.miniWidthMargin,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            postUser.userName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: CustomFontSize
                                                .boldMediumFontSize,
                                          ),
                                          Text(
                                            DateFormat('yyyy年MM月dd日 HH:mm')
                                                .format(tweetData.createdAt
                                                    .toDate()),
                                            style: CustomFontSize.smallFontSize,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  (tweetData.userId ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid)
                                      ? IconButton(
                                          onPressed: () {
                                            showConfirmDialog(
                                                context: context,
                                                text: '本当に削除しますか？',
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('tweets')
                                                      .doc(tweetData.tweetId)
                                                      .delete();
                                                  bottomShowToast('削除成功しました');
                                                });
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.deepPurple,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                              MarginSizedBox.miniHeightMargin,
                              Container(
                                // ignore: sort_child_properties_last
                                child: Row(
                                  children: [
                                    (tweetData.addedImageUrl.isNotEmpty)
                                        ? Row(
                                            children: [
                                              Image.network(
                                                tweetData.addedImageUrl,
                                                width: 75,
                                                height: 75,
                                                fit: BoxFit.scaleDown,
                                              ),
                                              MarginSizedBox.smallWidthMargin,
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                    Expanded(
                                        child: Text(tweetData.tweetContent)),
                                  ],
                                ),
                                width: double.infinity,
                                color: Colors.white,
                                padding: const EdgeInsets.all(16.0),
                              ),
                            ],
                          );
                        }),
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: StreamBuilder<Object>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(myUserId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }
            if (snapshot.hasData == false) {
              return const SizedBox.shrink();
            }
            final DocumentSnapshot<Map<String, dynamic>>? documentSnapshot =
                snapshot.data as DocumentSnapshot<Map<String, dynamic>>?;
            if (documentSnapshot == null || !documentSnapshot.exists) {
              // ドキュメントが存在しない場合の処理
              return const SizedBox.shrink();
            }
            final Map<String, dynamic> userDataMap = documentSnapshot.data()!;
            final UserData userData = UserData.fromJson(userDataMap);
            return SizedBox(
              width: 225,
              child: Drawer(
                backgroundColor: Colors.deepPurple,
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: <Widget>[
                    MarginSizedBox.bigHeightMargin,
                    ListTile(
                      title: const Text(
                        'メールアドレス変更',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        Navigator.pop(context); // Drawerを閉じる
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditEmailPage()),
                        );
                        setState(() {});
                      },
                    ),
                    MarginSizedBox.mediumHeightMargin,
                    ListTile(
                      title: const Text(
                        'パスワード変更',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        showConfirmDialog(
                          context: context,
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: myUserEmail!);
                              bottomShowToast("パスワードリセット用のメールを送信しました");
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);
                            } catch (e) {
                              showCloseOnlyDialog(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  e.toString(),
                                  'メール送信失敗');
                            }
                          },
                          text: 'パスワード再設定メールを送信しますか？',
                        );
                      },
                    ),
                    MarginSizedBox.mediumHeightMargin,
                    ListTile(
                      title: const Text(
                        'プロフィールアイコン編集',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return EditIconPage(
                              imageUrl: userData.imageUrl,
                            );
                          }),
                        );
                      },
                    ),
                    MarginSizedBox.mediumHeightMargin,
                    ListTile(
                      title: const Text(
                        'ユーザーネーム・\nプロフィール文章編集',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return EditProfilePage(
                              userName: userData.userName,
                              profileIntroduction: userData.profileIntroduction,
                            );
                          }),
                        );
                      },
                    ),
                    MarginSizedBox.mediumHeightMargin,
                    ListTile(
                      title: const Text(
                        'ログアウト',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                    ),
                    MarginSizedBox.bigHeightMargin,
                  ],
                ),
              ),
            );
          }),
    );
  }
}

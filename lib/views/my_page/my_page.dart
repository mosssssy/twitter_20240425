import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:twitter_20240425/common_widget/close_only_dialog.dart';
import 'package:twitter_20240425/common_widget/confirm_dialog.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';
import 'package:twitter_20240425/data_models/userdata/userdata.dart';
import 'package:twitter_20240425/functions/global_functions.dart';
import 'package:twitter_20240425/views/my_page/edit_email/edit_email.dart';
import 'package:twitter_20240425/views/my_page/edit_profile/edit_profile_page.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? myUserEmail = FirebaseAuth.instance.currentUser!.email;
    String? myUserId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PROFILE',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                print('ログアウトしました');
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: double.infinity,
          child: StreamBuilder<Object>(
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
                final UserData userData = UserData.fromJson(userDataMap);

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
                    Text(
                      userData.userName,
                      style: const TextStyle(),
                    ),
                    MarginSizedBox.smallHeightMargin,
                    Text(myUserEmail ?? ''),
                    MarginSizedBox.smallHeightMargin,
                    Text(userData.profileIntroduction),
                    MarginSizedBox.bigHeightMargin,
                  ],
                );
              }),
        ),
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
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  MarginSizedBox.bigHeightMargin,
                  ListTile(
                    title: const Text('メールアドレス変更'),
                    onTap: () {
                      Navigator.pop(context); // Drawerを閉じる
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditEmailPage()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('パスワード変更'),
                    onTap: () async {
                      showConfirmDialog(
                        context: context,
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: myUserEmail!);
                            showToast("パスワードリセット用のメールを送信しました");
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          } catch (e) {
                            showCloseOnlyDialog(
                                context, e.toString(), 'メール送信失敗');
                          }
                        },
                        text: 'パスワード再設定メールを送信しますか？',
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('プロフィール編集'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return EditProfilePage(
                            userName: userData.userName,
                            imageUrl: userData.imageUrl,
                          );
                        }),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('ログアウト'),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      print('ログアウトしました');
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}

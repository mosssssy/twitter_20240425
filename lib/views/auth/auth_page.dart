import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_20240425/common_widget/close_only_dialog.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';
import 'package:twitter_20240425/data_models/userdata/userdata.dart';
import 'package:twitter_20240425/views/auth/components/auth_text_form_field.dart';
import 'package:twitter_20240425/views/auth/password_reminder_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    return Scaffold(
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AuthTextFormField(
                controller: emailController,
                label: 'メールアドレス',
              ),
              MarginSizedBox.smallHeightMargin,
              AuthTextFormField(
                controller: passController,
                label: 'パスワード',
              ),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    // 1) 指定した画面に遷移する
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const PasswordReminderPage();
                      // 2) 実際に表示するページを指定する
                    }));
                  },
                  child: const Text(
                    'パスワードを忘れた方はこちら >',
                    style: TextStyle(color: Colors.deepPurple),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              MarginSizedBox.bigHeightMargin,
              ElevatedButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate() == false) {
                      // 失敗時に処理ストップ
                      return;
                    }
                    // 成功
                    try {
                      final User? user = (await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passController.text))
                          .user;
                      if (user != null) {
                        print('ユーザーを登録しました');
                        // FirebaseStore に userドキュメントを作成
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .set({
                          'userName': '',
                          'imageUrl': '',
                          'userId': '',
                          'profileIntroduction': '',
                          'createdAt': Timestamp.now(),
                          'updatedAt': Timestamp.now(),
                        });
                        AlertDialog(
                          title: const Text("会員登録成功"),
                          content: const Text('ユーザーを登録しました'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("close"),
                            )
                          ],
                        );
                      } else {
                        showCloseOnlyDialog(
                            context, '予期せぬエラーが出ました。\nやり直してください。', '会員登録失敗');
                      }
                    } on FirebaseAuthException catch (error) {
                      if (error.code == 'invalid-email') {
                        print('メールアドレスの形式ではありません');
                        showCloseOnlyDialog(
                            context, 'メールアドレスの形式ではありません', '会員登録失敗');
                      }
                      if (error.code == 'email-already-in-use') {
                        print('すでに使われているメールアドレスです');
                        showCloseOnlyDialog(
                            context, '既に使われているメールアドレスです', '会員登録失敗');
                      }
                      if (error.code == 'weak-password') {
                        print('パスワードが弱すぎます');
                        showCloseOnlyDialog(context, 'パスワードが弱すぎます', '会員登録失敗');
                      }
                    } catch (error) {
                      print('予期せぬエラーです');
                      showCloseOnlyDialog(
                          context, '予期せぬエラーが出ました。\nやり直してください。', '会員登録失敗');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                  child: const Text(
                    '会員登録',
                    style: TextStyle(color: Colors.white),
                  )),
              MarginSizedBox.smallHeightMargin,
              ElevatedButton(
                  onPressed: () async {
                    if (formkey.currentState!.validate() == false) {
                      return;
                    }
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final User? user = (await auth.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passController.text,
                      ))
                          .user;
                      if (user != null) {
                        print('ログイン成功');
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .update({
                          'updatedAt': Timestamp.now(),
                        });
                      } else {
                        print('ログイン失敗');
                        showCloseOnlyDialog(
                            context, '予期せぬエラーが出ました。\n再度やり直してください。', 'ログイン失敗');
                      }
                    } on FirebaseAuthException catch (error) {
                      if (error.code == 'user-not-found') {
                        showCloseOnlyDialog(context, 'ユーザーが見つかりません', 'ログイン失敗');
                      } else if (error.code == 'invalid-email') {
                        showCloseOnlyDialog(
                            context, 'メールアドレスの形式ではありません', 'ログイン失敗');
                      }
                    } catch (error) {
                      showCloseOnlyDialog(
                          context, '予期せぬエラーがきたよ。$error', 'ログイン失敗');
                    }
                  },
                  child: const Text(
                    'ログイン',
                    style: TextStyle(color: Colors.deepPurple),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

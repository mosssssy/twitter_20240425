import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_20240425/common_widget/close_only_dialog.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';

class PasswordReminderPage extends StatelessWidget {
  const PasswordReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'パスワード再設定',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                validator: (value) {
                  if (value == null || value == '') {
                    return '未入力です';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text('メールアドレス'),
                ),
              ),
              MarginSizedBox.bigHeightMargin,
              ElevatedButton(
                onPressed: () async {
                  if (formkey.currentState!.validate() == false) {
                    return;
                  }
                  try {
                    // メール/パスワードでログイン
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: emailController.text);
                    print("パスワードリセット用のメールを送信しました");
                  } on FirebaseAuthException catch (error) {
                    print(error.code);
                    if (error.code == 'invalid-email') {
                      showCloseOnlyDialog(
                          context, 'メールアドレスの形式ではありません', 'メール送信失敗');
                    } else if (error.code == 'user-disabled') {
                      showCloseOnlyDialog(
                          context, 'このアカウントは無効化されています', 'メール送信失敗');
                    } else if (error.code == 'invalid-credential') {
                      showCloseOnlyDialog(context, '無効なメールアドレスです', 'メール送信失敗');
                    }
                  } catch (error) {
                    showCloseOnlyDialog(
                        context, '予期せぬエラーが出ました。$error', 'メール送信失敗');
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text('パスワード再設定メールを送信する'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_20240425/common_widget/auth_text_form_field.dart';
import 'package:twitter_20240425/common_widget/close_only_dialog.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';
import 'package:twitter_20240425/functions/global_functions.dart';

class PasswordReminderPage extends StatelessWidget {
  const PasswordReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'パスワード再設定',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MarginSizedBox.bigHeightMargin,
                  GonTwitterTextFormField(
                      trimMsg: 'スペースは使えません',
                      controller: emailController,
                      maxLines: 1,
                      readOnlyBool: false,
                      label: 'メールアドレス'),
                  MarginSizedBox.bigHeightMargin,
                  ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate() == false) {
                        return;
                      }
                      try {
                        // メール/パスワードでログイン
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: emailController.text);
                        topShowToast('パスワードリセット用のメールを送信しました');
                      } on FirebaseAuthException catch (error) {
                        if (error.code == 'invalid-email') {
                          showCloseOnlyDialog(
                              context, 'メールアドレスの形式ではありません', 'メール送信失敗');
                        } else if (error.code == 'user-disabled') {
                          showCloseOnlyDialog(
                              context, 'このアカウントは無効化されています', 'メール送信失敗');
                        } else if (error.code == 'invalid-credential') {
                          showCloseOnlyDialog(
                              context, '無効なメールアドレスです', 'メール送信失敗');
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
        ),
      ),
    );
  }
}

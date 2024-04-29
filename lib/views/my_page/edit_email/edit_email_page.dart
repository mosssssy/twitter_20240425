// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_20240425/common_widget/auth_text_form_field.dart';
import 'package:twitter_20240425/common_widget/close_only_dialog.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';
import 'package:twitter_20240425/views/my_page/components/blue_button.dart';

class EditEmailPage extends StatelessWidget {
  const EditEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    String myUserEmail = FirebaseAuth.instance.currentUser!.email!;
    final GlobalKey<FormState> formkey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController newEmailController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    emailController.text = myUserEmail;
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'メールアドレス変更',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.deepPurple,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MarginSizedBox.mediumHeightMargin,
                  GonTwitterTextFormField(
                    trimMsg: 'スペースは使えません',
                    controller: emailController,
                    maxLines: 1,
                    label: '今のメールアドレス',
                    readOnlyBool: true,
                  ),
                  MarginSizedBox.smallHeightMargin,
                  GonTwitterTextFormField(
                    trimMsg: 'スペースは使えません',
                    controller: newEmailController,
                    maxLines: 1,
                    label: '新しいメールアドレス',
                    readOnlyBool: false,
                  ),
                  MarginSizedBox.smallHeightMargin,
                  GonTwitterTextFormField(
                    trimMsg: 'スペースは使えません',
                    controller: passController,
                    maxLines: 1,
                    label: 'パスワード',
                    readOnlyBool: false,
                  ),
                  MarginSizedBox.bigHeightMargin,
                  BlueButton(
                    buttonText: 'メールアドレス変更',
                    onBlueButtonPressed: () async {
                      try {
                        //まず一回ログインする
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passController.text);
                        //メールアドレスを変更する
                        await FirebaseAuth.instance.currentUser!
                            .verifyBeforeUpdateEmail(newEmailController.text);
                        showCloseOnlyDialog(context,
                            'メールアドレス変更用のメールを送信しました。\nログアウトします。', 'メール送信完了');
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pop();
                      } on FirebaseAuthException catch (error) {
                        if (error.code == 'invalid-email') {
                          showCloseOnlyDialog(
                              context, 'メールアドレスの形式ではありません', '失敗しました');
                        } else if (error.code == 'email-already-in-use') {
                          showCloseOnlyDialog(
                              context, '既に使われているメールアドレスです', '失敗しました');
                        } else if (error.code == 'wrong-password') {
                          showCloseOnlyDialog(
                              context, 'パスワードが間違っています', '失敗しました');
                        } else if (error.code == 'invalid-credential') {
                          showCloseOnlyDialog(
                              context, '無効なメールアドレスまたはパスワードです', '失敗しました');
                        } else {
                          showCloseOnlyDialog(
                              context, '予期せぬエラーが出ました。$error', '失敗しました');
                        }
                      } catch (error) {
                        showCloseOnlyDialog(
                            context, '予期せぬエラーが出ました。$error', '失敗しました');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

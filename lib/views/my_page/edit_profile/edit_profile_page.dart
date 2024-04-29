// ignore_for_file: must_be_immutable, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_20240425/common_widget/gon_twitter_text_form_field.dart';
import 'package:twitter_20240425/common_widget/close_only_dialog.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';
import 'package:twitter_20240425/functions/global_functions.dart';
import 'package:twitter_20240425/views/my_page/components/blue_button.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.userName,
    required this.profileIntroduction,
  });
  final String userName;
  final String profileIntroduction;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController profileIntroductionController =
      TextEditingController();
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    userNameController.text = widget.userName;
    profileIntroductionController.text = widget.profileIntroduction;
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'ユーザーネーム・プロフィール文章編集',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            backgroundColor: Colors.deepPurple,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      MarginSizedBox.mediumHeightMargin,
                      GonTwitterLimitedTextFormField(
                          trimMsg: 'ユーザーネームを入力してください',
                          controller: userNameController,
                          maxLength: 12,
                          maxLines: 1,
                          label: 'ユーザーネーム'),
                      MarginSizedBox.mediumHeightMargin,
                      GonTwitterLimitedTextFormField(
                          trimMsg: 'プロフィール文章を入力してください',
                          controller: profileIntroductionController,
                          maxLength: 50,
                          maxLines: 3,
                          label: 'プロフィール文章'),
                      MarginSizedBox.mediumHeightMargin,
                      BlueButton(
                        buttonText: 'プロフィールを変更する',
                        onBlueButtonPressed: () async {
                          if (formKey.currentState!.validate() == false) {
                            return;
                          }
                          try {
                            ///imageがnull
                            ///画像を選択していないとき
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user.uid)
                                .update(
                              {
                                'userName': userNameController.text,
                                'profileIntroduction':
                                    profileIntroductionController.text,
                                'updatedAt': DateTime.now(),
                              },
                            );
                            topShowToast('変更成功しました！');
                            Navigator.of(context).pop();
                          } catch (error) {
                            showCloseOnlyDialog(
                                context, error.toString(), '更新失敗しました');
                          }
                        },
                      ),
                    ],
                  )))),
    );
  }
}

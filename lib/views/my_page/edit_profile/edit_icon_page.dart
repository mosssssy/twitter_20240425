// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_20240425/common_widget/close_only_dialog.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';
import 'package:twitter_20240425/functions/global_functions.dart';
import 'package:twitter_20240425/views/my_page/components/blue_button.dart';

class EditIconPage extends StatefulWidget {
  EditIconPage({
    super.key,
    required this.imageUrl,
  });
  String imageUrl;

  @override
  State<EditIconPage> createState() => _EditIconPageState();
}

class _EditIconPageState extends State<EditIconPage> {
  final User user = FirebaseAuth.instance.currentUser!;
  File? image; // 画像を入れる変数

  @override
  Widget build(BuildContext context) {
    Widget previewWidget;
    if (image != null) {
      previewWidget = ClipOval(
        child: Image.file(
          image!,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    } else {
      if (widget.imageUrl != '') {
        // imageUrlが空文字のとき
        previewWidget = ClipOval(
          child: Image.network(
            widget.imageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        );
      } else {
        previewWidget = ClipOval(
            child: Image.asset(
          'assets/images/default_user_icon.png',
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ));
      }
    }

    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'プロフィールアイコン編集',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.deepPurple,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          child: previewWidget,
                        ),
                        if (widget.imageUrl != '')
                          Positioned(
                            top: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.grey, // 背景色を設定
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                ), // アイコンを設定
                                onPressed: () async {
                                  // ボタンがタップされたときの処理
                                  // 画像削除
                                  // 上記で取得したURLを使ってUserドキュメントを更新する
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .update(
                                    {
                                      'imageUrl': '',
                                      'updatedAt': DateTime.now(),
                                    },
                                  );
                                  await FirebaseStorage.instance
                                      .ref('userIcon/${user.uid}')
                                      .delete();
                                  widget.imageUrl = '';
                                  bottomShowToast('画像削除しました');
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                MarginSizedBox.mediumHeightMargin,
                BlueButton(
                    buttonText: '画像を選択する',
                    onBlueButtonPressed: () {
                      //Image Pickerをインスタンス化
                      getImageFromGallery();
                    }),
                MarginSizedBox.mediumHeightMargin,
                BlueButton(
                  buttonText: 'プロフィールを変更する',
                  onBlueButtonPressed: () async {
                    try {
                      ///ストレージに選択した画像をアップロードする
                      final storedImage = await FirebaseStorage.instance
                          .ref('userIcon/${user.uid}')
                          .putFile(image!);
                      //ストレージにあげた画像のURLを取得する
                      final String imageUrl =
                          await storedImage.ref.getDownloadURL();
                      //上記で取得したURLを使ってUserドキュメントを更新する
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .update(
                        {
                          'imageUrl': imageUrl,
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
            ),
          )),
    );
  }

  Future getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery); //アルバムから画像を取得

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_20240425/common_widget/gon_twitter_text_form_field.dart';
import 'package:twitter_20240425/functions/global_functions.dart';
import 'package:twitter_20240425/views/my_page/components/small_blue_button.dart';
import 'package:uuid/uuid.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';

class AddTweetPage extends StatefulWidget {
  const AddTweetPage({super.key});

  @override
  State<AddTweetPage> createState() => _AddTweetPageState();
}

class _AddTweetPageState extends State<AddTweetPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController tweetContentController = TextEditingController();
  File? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ツイートする',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepPurple,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: formkey,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SmallBlueButton(
                      buttonText: '画像を選択',
                      onBlueButtonPressed: () {
                        //Image Pickerをインスタンス化
                        getImageFromGallery();
                      },
                    ),
                    MarginSizedBox.smallWidthMargin,
                    SmallBlueButton(
                      buttonText: 'ツイート',
                      onBlueButtonPressed: () async {
                        if (formkey.currentState!.validate() == false) {
                          return;
                        }
                        final String uuid = const Uuid().v4();
                        FirebaseFirestore.instance
                            .collection('tweets')
                            .doc(uuid)
                            .set({
                          'tweetContent': tweetContentController.text,
                          'userId': FirebaseAuth.instance.currentUser!.uid,
                          'createdAt': DateTime.now(),
                          'updatedAt': DateTime.now(),
                          'addedImageUrl': "",
                          'tweetId': uuid,
                        });
                        if (image != null) {
                          ///ストレージに選択した画像をアップロードする
                          final storedImage = await FirebaseStorage.instance
                              .ref('addedImage/$uuid')
                              .putFile(image!);
                          //ストレージにあげた画像のURLを取得する
                          final String addedImageUrl =
                              await storedImage.ref.getDownloadURL();
                          await FirebaseFirestore.instance
                              .collection('tweets')
                              .doc(uuid)
                              .update({
                            'addedImageUrl': addedImageUrl,
                          });
                        }
                        tweetContentController.clear();
                        image = null;
                        setState(() {});
                        topShowToast('ツイートが追加されました');
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                MarginSizedBox.smallHeightMargin,
                GonTwitterLimitedTextFormField(
                    trimMsg: 'ツイート内容を入力してください',
                    controller: tweetContentController,
                    maxLength: 140,
                    maxLines: 7,
                    label: 'ツイート'),
                MarginSizedBox.smallHeightMargin,
                (image != null)
                    ? Stack(children: [
                        Image.file(
                          image!,
                          fit: BoxFit.cover,
                        ),
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
                                image = null;
                                bottomShowToast('画像削除しました');
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ])
                    : const SizedBox.shrink(),
                MarginSizedBox.bigHeightMargin,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getImageFromGallery() async {
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

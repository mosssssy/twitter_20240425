import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_20240425/functions/global_functions.dart';
import 'package:uuid/uuid.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';
import 'package:twitter_20240425/views/my_page/components/blue_button.dart';

class AddTweetPage extends StatefulWidget {
  const AddTweetPage({super.key});

  @override
  State<AddTweetPage> createState() => _AddTweetPageState();
}

class _AddTweetPageState extends State<AddTweetPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tweetContentController = TextEditingController();
  File? image;

  @override
  Widget build(BuildContext context) {
    Widget previewWidget;
    if (image != null) {
      previewWidget = Image.file(
        image!,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    } else {
      previewWidget = Container(
        width: 200,
        height: 200,
        color: Colors.grey,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('ツイートする'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: tweetContentController,
                maxLength: 140,
                validator: (value) {
                  if (value == null || value == '') {
                    return '未入力です';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  label: Text('ツイート'),
                ),
              ),
              MarginSizedBox.smallHeightMargin,
              BlueButton(
                buttonText: '画像を選択する',
                onBlueButtonPressed: () {
                  //Image Pickerをインスタンス化
                  getImageFromGallery();
                },
              ),
              MarginSizedBox.smallHeightMargin,
              previewWidget,
              MarginSizedBox.bigHeightMargin,
              BlueButton(
                buttonText: 'ツイートを追加する',
                onBlueButtonPressed: () async {
                  if (formKey.currentState!.validate() == false) {
                    return;
                  }
                  final String uuid = const Uuid().v4();
                  FirebaseFirestore.instance
                      .collection('tweets')
                      .doc(uuid)
                      .set({
                    'tweetContent': tweetContentController.text,
                    'userId': FirebaseAuth.instance.currentUser!.uid,
                    'createdAt': Timestamp.now(),
                    'updatedAt': Timestamp.now(),
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

                  showToast('ツイートが追加されました');
                  tweetContentController.clear();
                },
              ),
            ],
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

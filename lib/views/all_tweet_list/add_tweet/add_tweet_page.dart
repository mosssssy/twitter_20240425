import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:twitter_20240425/functions/global_functions.dart';
import 'package:uuid/uuid.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';
import 'package:twitter_20240425/data_models/tweetdata/tweetdata.dart';
import 'package:twitter_20240425/views/my_page/components/blue_button.dart';

class AddTweetPage extends StatelessWidget {
  const AddTweetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController tweetContentController =
        TextEditingController();
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
              MarginSizedBox.bigHeightMargin,
              BlueButton(
                buttonText: 'ツイートを追加する',
                onBlueButtonPressed: () async {
                  if (formKey.currentState!.validate() == false) {
                    return;
                  }
                  final String uuid = const Uuid().v4();
                  TweetData addTweetData = TweetData(
                    tweetContent: tweetContentController.text,
                    userId: FirebaseAuth.instance.currentUser!.uid,
                    createdAt: Timestamp.now(),
                    updatedAt: Timestamp.now(),
                    addedImageUrl: "",
                    tweetId: uuid,
                  );
                  await FirebaseFirestore.instance
                      .collection('tweets')
                      .doc(uuid)
                      .set(addTweetData.toJson());
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
}

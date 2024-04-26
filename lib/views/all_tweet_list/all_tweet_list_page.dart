import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:twitter_20240425/common_widget/confirm_dialog.dart';
import 'package:twitter_20240425/common_widget/margin_sizedbox.dart';
import 'package:twitter_20240425/data_models/tweetdata/tweetdata.dart';
import 'package:twitter_20240425/data_models/userdata/userdata.dart';
import 'package:twitter_20240425/functions/global_functions.dart';
import 'package:twitter_20240425/views/all_tweet_list/add_tweet/add_tweet_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoAllListPage extends StatelessWidget {
  const TodoAllListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'みんなの投稿一覧',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.deepPurple[100],
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('tweets')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData == false || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          // 目標形： [{}, {}, {}]
          // 現在：   ⭕️💎[{}, {}, {}]💎⭕️
          final QuerySnapshot<Map<String, dynamic>> querySnapshot =
              snapshot.data!;
          // 現在：   💎[{}, {}, {}]💎
          final List<QueryDocumentSnapshot<Map<String, dynamic>>> listData =
              querySnapshot.docs;
          // 現在：   [🐶{}🐶, 🐶{}🐶, 🐶{}🐶]
          return ListView.builder(
            itemCount: listData.length,
            itemBuilder: (context, index) {
              final QueryDocumentSnapshot<Map<String, dynamic>>
                  queryDocumentSnapshot = listData[index];
              Map<String, dynamic> mapData = queryDocumentSnapshot.data();
              // ゴール！： [{}, {}, {}]
              TweetData tweetData = TweetData.fromJson(mapData);
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(tweetData.userId)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                            userSnapshot) {
                      if (userSnapshot.hasData == false ||
                          userSnapshot.data == null) {
                        return Container();
                      }
                      final DocumentSnapshot<Map<String, dynamic>>
                          documentSnapshot = userSnapshot.data!;
                      final Map<String, dynamic> userMap =
                          documentSnapshot.data()!;
                      final UserData postUser = UserData.fromJson(userMap);
                      return Column(
                        children: [
                          ListTile(
                            leading: (postUser.imageUrl != '')
                                ? ClipOval(
                                    child: Image.network(
                                      postUser.imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                :
                                //imageUrlが空文字だったら
                                ClipOval(
                                    child: Image.asset(
                                      'assets/images/default_user_icon.png',
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            title: Text(postUser.userName),
                            subtitle: Row(
                              children: [
                                Text(
                                  tweetData.createdAt
                                      .toDate()
                                      .toString()
                                      .substring(0, 16),
                                ),
                              ],
                            ),
                            trailing: (tweetData.userId ==
                                    FirebaseAuth.instance.currentUser!.uid)
                                ? IconButton(
                                    onPressed: () {
                                      showConfirmDialog(
                                          context: context,
                                          text: '本当に削除しますか？',
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await FirebaseFirestore.instance
                                                .collection('tweets')
                                                .doc(tweetData.tweetId)
                                                .delete();
                                            showToast('削除成功しました');
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.deepPurple,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                          Container(
                            // ignore: sort_child_properties_last
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(tweetData.tweetContent),
                            ),
                            width: double.infinity,
                            color: Colors.white,
                          ),
                        ],
                      );
                    }),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddTweetPage();
          }));
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

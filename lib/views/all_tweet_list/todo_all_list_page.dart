import 'package:flutter/material.dart';
import 'package:twitter_20240425/views/all_tweet_list/add_tweet/add_tweet_page.dart';

class TodoAllListPage extends StatelessWidget {
  const TodoAllListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'みんなの投稿一覧',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddTweetPage();
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

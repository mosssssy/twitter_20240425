// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:twitter_20240425/views/my_page/my_page.dart';
import 'package:twitter_20240425/views/all_tweet_list/all_tweet_list_page.dart';

class BottomNavigationPage extends StatelessWidget {
  BottomNavigationPage({super.key});

  List children = [
    const TodoAllListPage(),
    const MyPage(),
  ];

  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: children[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int value) {
          currentIndex = value;
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'MyPage',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutteryoutubeclone/widgets/home_item_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return HomeItemWidget(index);
      }, childCount: 30),
    );
  }
}
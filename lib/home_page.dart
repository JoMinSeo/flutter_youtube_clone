import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutteryoutubeclone/screens/detail_screen.dart';
import 'package:flutteryoutubeclone/screens/home_screen.dart';
import 'package:flutteryoutubeclone/constants/size.dart';
import 'package:flutteryoutubeclone/screens/subscription_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutteryoutubeclone/constants/common_size.dart';
import 'package:flutteryoutubeclone/data/bool_change_notifier.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

TextStyle _bottomNavTextStyle = TextStyle(fontSize: 12);

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<BottomNavigationBarItem> btmNavItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home', style: _bottomNavTextStyle),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.explore),
      title: Text('Explore', style: _bottomNavTextStyle),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.subscriptions),
      title: Text('Subscriptions', style: _bottomNavTextStyle),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.inbox),
      title: Text('Inbox', style: _bottomNavTextStyle),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.video_library),
      title: Text('Library', style: _bottomNavTextStyle),
    ),
  ];

  static List<Widget> _screens = <Widget>[
    HomeScreen(),
    SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Ink(
          color: Colors.accents[1],
          child: ListTile(
            title: Text('text one'),
          ),
        );
      }, childCount: 30),
    ),
    SubscriptionScreen(),
    SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Ink(
          color: Colors.accents[5],
          child: ListTile(
            title: Text('text three'),
          ),
        );
      }, childCount: 30),
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Ink(
          color: Colors.accents[7],
          child: ListTile(
            title: Text('text four'),
          ),
        );
      }, childCount: 30),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (size == null) {
      size = MediaQuery.of(context).size;
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                leading: Padding(
                  padding: const EdgeInsets.only(
                    top: common_xxxs_gap,
                    bottom: common_xxxs_gap,
                    left: common_gap,
                  ),
                  child: Image.asset(
                    'assets/youtube.png',
                  ),
                ),
                titleSpacing: common_xxxs_gap,
                title: Text(
                  'Premium',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.videocam,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl:
                          'https://api.adorable.io/avatars/30/abott@adorable.png',
                          width: avatar_size,
                          height: avatar_size,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              _screens[_selectedIndex]
            ],
          ),
          ChangeNotifierProvider<BoolNotifier>(
            create: (_) => BoolNotifier(),
            child: Consumer<BoolNotifier>(
              builder: (BuildContext context, BoolNotifier boolNotifier, Widget child) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  child: DetailScreen(),
                  transform: Matrix4.translationValues(
                      0, boolNotifier.value ? 0 : size.height, 0),
                );
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.white,
        items: btmNavItems,
        currentIndex: _selectedIndex,
        onTap: _onBtmItemClick,
      ),
    );
  }

  void _onBtmItemClick(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
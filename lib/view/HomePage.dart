import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:vote/view/poll.dart';
import 'package:vote/view/userPoll.dart';

import 'AllPols.dart';


class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _pageController = PageController();
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: _pageController,
          children: <Widget>[
          AddPoll(),
          AllPoll(),
          UserPoll(),
         //   ShowPanier(),
         //  DashChat(),
          ],
          onPageChanged: (int index) {
            setState(() {
              _pageController.jumpToPage(index);
            });
          }),
      bottomNavigationBar: CurvedNavigationBar(
        animationCurve: Curves.decelerate,
        index: 0,
        items: <Widget>[       
        
          Icon(Icons.add, size: 20, color: Colors.white),
          Icon(Icons.picture_in_picture, size: 20, color: Colors.white),
          Icon(Icons.person, size: 20, color: Colors.white),
         
        ],
        color: Colors.blueAccent,
        backgroundColor: Colors.white,
        height: 50.0,
        onTap: (int index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}

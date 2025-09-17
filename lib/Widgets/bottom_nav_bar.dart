import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone_flutter/Constant/pallete.dart';
import 'package:instagram_clone_flutter/Screens/add_post_screen.dart';
import 'package:instagram_clone_flutter/Screens/feed_screen.dart';
import 'package:instagram_clone_flutter/Screens/profile_screen.dart';
import 'package:instagram_clone_flutter/Screens/search_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final pages = [
    const FeedScreen(),
    const SearchScreen(),
    const AddPostScreen(),
    const Center(
      child: Text('4nd '),
    ),
    ProfileScreen(
      uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        elevation: 0.0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Pallete.textFieldFillColor,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
              size: 29.0,
              color: Pallete.bottomNavIconColor,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              size: 29.0,
              color: Pallete.bottomNavIconColor,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box_sharp,
              size: 29.0,
              color: Pallete.bottomNavIconColor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'Assets/Images/video.png',
              scale: 23,
              color: Pallete.bottomNavIconColor,
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Pallete.bottomNavIconColor,
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6Q82WISxpWPp5dHBTWHypFOZbRTvc0ST0xQ&s'),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}

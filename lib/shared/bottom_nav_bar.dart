import 'package:flutter/material.dart';
//import 'package:project_coconut/features/achievements/view/achievements_screen.dart';
import 'package:project_coconut/features/add/view/add_screen.dart';
//import 'package:project_coconut/features/explore/view/explore_screen.dart';
import 'package:project_coconut/features/home/view/home_screen.dart';
import 'package:project_coconut/features/profile/view/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;
  final screens = [
    const HomeScreen(),
    //const ExploreScreen(),       //Not yet implemented
    const AddScreen(),
    //const AchievementsScreen(),  //Not yet implemented
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //indexedStack allows the State to stay alive when the Screen changes
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) => setState(() => currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          //BottomNavigationBarItem(
          //  icon: Icon(
          //    Icons.search,
          //  ),
          //  label: 'Explore',
          //),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box_outlined,
            ),
            label: 'Add',
          ),
          //BottomNavigationBarItem(
          //  icon: Icon(
          //    Icons.task_alt,
          //  ),
          //  label: 'Achieved',
          //),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

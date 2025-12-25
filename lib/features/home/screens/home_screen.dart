import 'package:mivro/features/home/screens/scanner_screen.dart';
import 'package:mivro/features/chat/screens/chat_screen.dart';
import 'package:mivro/features/marketplace/screens/marketplace_screen.dart';
import 'package:mivro/features/tracker/screens/tracker_screen.dart';
import 'package:mivro/features/profile/screens/profile_screen.dart';
import 'package:mivro/core/hex_color.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var myIndex = 2;

  List<Widget> screens = [
    const ChatbotScreen(),
    const MarketplaceScreen(),
    const ScannerScreen(),
    const TrackerScreen(),
    const ProfileScreen(),
  ];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[myIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            showUnselectedLabels: false,
            type: BottomNavigationBarType.shifting,
            selectedLabelStyle: const TextStyle(color: Colors.black),
            selectedItemColor: Colors.black,
            backgroundColor: Theme.of(
              context,
            ).bottomNavigationBarTheme.backgroundColor,
            onTap: (index) {
              setState(() {
                myIndex = index;
              });
            },
            currentIndex: myIndex,
            items: [
              BottomNavigationBarItem(
                icon: const Image(
                  image: AssetImage('assets/icons/navigation/chat.png'),
                  height: 35,
                ),
                label: 'Chat',
                backgroundColor: myColorFromHex("#EEF1FF"),
              ),
              BottomNavigationBarItem(
                icon: const Image(
                  image: AssetImage('assets/icons/navigation/marketplace.png'),
                  height: 35,
                ),
                label: 'Marketplace',
                backgroundColor: myColorFromHex("#EEF1FF"),
              ),
              BottomNavigationBarItem(
                icon: const Image(
                  image: AssetImage('assets/icons/navigation/scanner.png'),
                  height: 35,
                ),
                label: 'Scanner',
                backgroundColor: myColorFromHex("#EEF1FF"),
              ),
              BottomNavigationBarItem(
                icon: const Image(
                  image: AssetImage('assets/icons/navigation/tracker.png'),
                  height: 35,
                ),
                label: 'Tracker',
                backgroundColor: myColorFromHex("#EEF1FF"),
              ),
              BottomNavigationBarItem(
                icon: const Image(
                  image: AssetImage('assets/icons/navigation/profile.png'),
                  height: 35,
                ),
                label: 'Profile',
                backgroundColor: myColorFromHex("#EEF1FF"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

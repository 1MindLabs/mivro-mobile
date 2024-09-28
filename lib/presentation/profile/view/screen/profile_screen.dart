import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mivro/presentation/auth/screens/login_screen.dart';
import 'package:mivro/presentation/profile/api/load_profile.dart';
import 'package:mivro/presentation/profile/view/screen/profile_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = '';
  String password = '';
  Map<String, dynamic> profileDetails = {};
  @override
  void initState() {
    getEmailAndPassword();
    super.initState();
  }

  void getEmailAndPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      email = prefs.getString('email') ?? '';
      password = prefs.getString('password') ?? '';
      profileDetails = await loadProfile(email, password);
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileDetailsScreen(
                    personalDetails: profileDetails['health_profile'] ?? {}),
              ),
            );
          },
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(30),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                      profileDetails['account_info']['photo_url'] ?? ''),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileDetails['account_info']['display_name'] ?? '',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(),
        _buildMenuItem(context, 'Account Settings'),
        _buildMenuItem(context, 'Privacy and Security'),
        _buildMenuItem(context, 'Activity and Records'),
        _buildMenuItem(context, 'Notification Preferences'),
        _buildMenuItem(context, 'Support and Feedback'),
        _buildMenuItem(context, 'Legal'),
        _buildMenuItem(context, 'Advanced'),
        Spacer(),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', false);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, String title) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {},
    );
  }
}

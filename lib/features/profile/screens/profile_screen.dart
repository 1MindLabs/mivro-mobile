import 'package:flutter/material.dart';
import 'package:mivro/features/auth/screens/signin_screen.dart';
import 'package:mivro/features/profile/services/load_profile_service.dart';
import 'package:mivro/features/profile/screens/profile_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';
  String password = '';
  Map<String, dynamic>? profileDetails;
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    getEmailAndPassword();
  }

  Future<void> getEmailAndPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = prefs.getString('email') ?? '';
      username = email.split('@').first;
      password = prefs.getString('password') ?? '';
      profileDetails = await loadProfile(email, password);

      setState(() {
        isLoading = false; // Data loaded
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading even if an error occurs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator()); // Show loader
    }

    if (profileDetails == null || profileDetails!.isEmpty) {
      return const Center(child: Text("Failed to load profile"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileDetailsScreen(
                  personalDetails: profileDetails!['health_profile'] ?? {},
                ),
              ),
            );
          },
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(30),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      profileDetails!['account_info']['photo_url'] != null
                      ? NetworkImage(
                          profileDetails!['account_info']['photo_url'],
                        )
                      : null,
                  child: profileDetails!['account_info']['photo_url'] == null
                      ? const Icon(Icons.person, size: 40) // Placeholder icon
                      : null,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profileDetails!['account_info']['display_name'] ??
                          'Unknown',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      username,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        _buildMenuItem(context, 'Account Settings'),
        _buildMenuItem(context, 'Privacy and Security'),
        _buildMenuItem(context, 'Activity and Records'),
        _buildMenuItem(context, 'Notification Preferences'),
        _buildMenuItem(context, 'Support and Feedback'),
        _buildMenuItem(context, 'Legal'),
        _buildMenuItem(context, 'Advanced'),
        const Spacer(),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', false);

                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 150,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'SignOut',
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
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {},
    );
  }
}

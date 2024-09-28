import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:mivro/constants.dart';
import 'package:mivro/presentation/auth/api/create_account.dart';
import 'package:mivro/presentation/auth/model/personal_details.dart';
import 'package:mivro/presentation/auth/screens/details_screen.dart';
import 'package:mivro/presentation/auth/screens/login_screen.dart';
import 'package:mivro/presentation/home/view/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void onSignUpSubmit() async {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        if (_passwordController.text == _confirmPasswordController.text) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', _emailController.text);
          prefs.setString('password', _passwordController.text);

          var response = await createAccount(
              _emailController.text, _passwordController.text);

          if (response) {
            prefs.setBool('isLoggedIn', true);
            prefs.setBool('details', false);
            prefs.setBool('isUser', true);

            SnackBar snackBar = const SnackBar(
              content: Text('Sign Up Successful'),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(
                  email: _emailController.text,
                  password: _passwordController.text,
                ),
              ),
            );
          } else {
            SnackBar snackBar = const SnackBar(
              content: Text('Account creation failed'),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        } else {
          SnackBar snackBar = const SnackBar(
            content: Text('Password couldnt be verified'),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        SnackBar snackBar = const SnackBar(
          content: Text('Details empty'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Account!'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.01, // Adjust the position as needed
            left: MediaQuery.of(context).size.width *
                0.2, // Adjust left position as needed
            child: Container(
              width: 400, // Define size of the circle
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF5C8374), // Background color for the circle
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height *
                0.2, // Adjust the position as needed
            right: MediaQuery.of(context).size.width *
                0.2, // Adjust left position as needed
            child: Container(
              width: 400, // Define size of the circle
              height: 400,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(
                    104, 158, 200, 185), // Background color for the circle
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: 'Enter your email',
                            prefixIcon:
                                Icon(Icons.email, color: Color(0xFF001F3F)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: 'Enter your Password',
                            prefixIcon:
                                Icon(Icons.lock, color: Color(0xFF001F3F)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.name,
                          controller: _passwordController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.black),
                            hintText: 'Enter your Password',
                            prefixIcon:
                                Icon(Icons.lock, color: Color(0xFF001F3F)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.name,
                          controller: _confirmPasswordController,
                        ),
                      ),
                    ),
                    const Gap(25),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: onSignUpSubmit,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 120, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: const Color(0xFF31363F)),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            child: Text(
                              'Sign In!',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

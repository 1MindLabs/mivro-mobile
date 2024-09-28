import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mivro/constants.dart';
import 'package:mivro/presentation/auth/api/sign_in.dart';
import 'package:mivro/presentation/auth/screens/signup_screen.dart';
import 'package:mivro/presentation/home/view/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> verifyLogin() async {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _emailController.text);
        prefs.setString('password', _passwordController.text);

        var response =
            await signin(_emailController.text, _passwordController.text);
        if (response) {
          prefs.setBool('isLoggedIn', true);
          prefs.setBool('isUser', true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Successfull'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid Credentials'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Back!'),
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
                    const Gap(5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          )),
                    ),
                    const Gap(25),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: verifyLogin,
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 120, vertical: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: const Color(0xFF31363F)),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpScreen()));
                            },
                            child: Text(
                              'Sign Up!',
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

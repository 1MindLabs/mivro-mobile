import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mivro/presentation/auth/api/forgot_password.dart';
import 'package:mivro/presentation/auth/widgets/custom_background.dart';
import 'package:mivro/presentation/auth/widgets/custom_button.dart';
import 'package:mivro/presentation/auth/widgets/custom_text.dart';
import 'package:mivro/presentation/auth/widgets/custom_text_form_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  bool isResetPassword = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void sendResetPasswordInstruction() {}

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<bool>>(resetPasswordProvider, (previous, next) {
      next.when(
        data: (isSuccess) {
          if (isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Password reset link sent successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to send password reset link.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        loading: () {},
        error: (err, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An error occurred: $err')),
          );
        },
      );
    });

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Your Password?'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: formKey,
        child: CustomBackground(
          isHintText: true,
          widget: const CustomText(
            text:
                'Enter your email and we will send you instructions to reset your password.',
            fontWeight: FontWeight.w700,
            textColor: Colors.black,
            fontSize: 20,
          ),
          children: [
            CustomTextFormField(
              labelText: 'Your email address',
              controller: _emailController,
              icon: Icons.email,
            ),
            const Gap(25),
            CustomButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  ref
                      .read(resetPasswordProvider.notifier)
                      .resetPassword(email: _emailController.text);
                }
              },
              text: 'Request reset link',
            )
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moody/Widgets/round_button.dart';
import 'package:moody/utils/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Email',
            ),
          ),
          SizedBox(height: 40),
          RoundButton(
              title: 'Forgot',
              onTap: () {
                auth
                    .sendPasswordResetEmail(
                        email: emailController.text.toString())
                    .then((value) {
                  Utils().toastMessage(
                      " We've sent you email to recover the pass, please check the mail");
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              }),
        ],
      ),
    );
  }
}

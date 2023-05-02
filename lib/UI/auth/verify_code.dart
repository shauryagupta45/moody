import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moody/UI/posts/post_screen.dart';
import '../../Widgets/round_button.dart';
import '../../utils/utils.dart';

class VerifyCodeScreen extends StatefulWidget {
  String verificationId;
  VerifyCodeScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final verificationCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 120),
            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: " Enter 6 Digit Code",
              ),
            ),
            const SizedBox(height: 50),
            RoundButton(
              title: 'Verify',
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });
                final credentials = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: verificationCodeController.text.toString());

                try {
                  await auth.signInWithCredential(credentials);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PostScreen()));
                } catch (e) {
                  setState(() {
                    loading = false;
                  });

                  Utils().toastMessage(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

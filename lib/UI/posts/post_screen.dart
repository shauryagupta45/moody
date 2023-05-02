import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moody/UI/auth/login_screen.dart';
import 'package:moody/utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moody Post'),
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
              }).onError((error, stackTrace) {
                Utils().toastMessage(error.toString());
              });
            },
            icon: Row(
              children: const [
                Text("Logout"),
                Icon(Icons.logout_outlined),
              ],
            ), // By using the Row in icon section, we've combined the "logout" text and the logout outline symbol as a single IconButton.
          ), //LogoutButton
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}

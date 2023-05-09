import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:moody/Widgets/round_button.dart';
import 'package:moody/utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Note : In hot reload, changes are accepted from this line onwards
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              maxLines: 8,
              controller: postController,
              decoration: InputDecoration(
                hintText: 'What your thought today, Post it!',
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(1.0),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: 'Post',
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });

                databaseRef
                    .child(DateTime.now().millisecondsSinceEpoch.toString())
                    .set({
                  'title': postController.text.toString(),
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                }).then((value) {
                  Utils().toastMessage('Post Added');
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

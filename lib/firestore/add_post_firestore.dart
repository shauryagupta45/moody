import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:moody/Widgets/round_button.dart';
import 'package:moody/firestore/firestore_listScreen.dart';
import 'package:moody/utils/utils.dart';

class AddPostFirestore extends StatefulWidget {
  const AddPostFirestore({Key? key}) : super(key: key);

  @override
  State<AddPostFirestore> createState() => _AddPostFirestoreState();
}

class _AddPostFirestoreState extends State<AddPostFirestore> {
  bool loading = false;

  //Note that we are using firebase realtime database in here, not firebase storage, for this we use the library firebase_database
  final postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    // Note : In hot reload, changes are accepted from this line onwards
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Add Post firestore'),
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

                String id = DateTime.now().millisecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  'title': postController.text.toString(),
                  'id': id,
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FireStoreScreen()));
                  Utils().toastMessage('Post added');
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });

                setState(() {
                  loading = false;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FireStoreScreen()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

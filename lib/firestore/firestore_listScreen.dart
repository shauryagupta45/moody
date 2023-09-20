import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:moody/UI/auth/login_screen.dart';
import 'package:moody/UI/posts/add_posts.dart';
import 'package:moody/firestore/add_post_firestore.dart';
import 'package:moody/utils/utils.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({Key? key}) : super(key: key);

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  @override
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('users');
  // or the other method is final ref = FirebaseFirestore.instance.collection('users')  ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // ref.onValue.listen(
    //     (event) {});

    // The line ref.onValue.listen((event) {}) sets up a listener on a Firebase Realtime Database reference (ref) to listen for changes in the data at that reference location. The listener will trigger a callback function whenever the data at the specified reference changes.

    // we can't do this for FirebaseAnimatedList, coz it's a widget but stream isn't one.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Moody Post ( Firestore )'),
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
      body: Column(
        children: [
          const SizedBox(height: 10),
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();

                if (snapshot.hasError) return Text('Error');

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onDoubleTap: () {
                          ref.doc(snapshot.data!.docs[index]['id']).delete();
                        },
                        child: ListTile(
                          onTap: () {
                            ref
                                .doc(
                                    snapshot.data!.docs[index]['id'].toString())
                                .update({'title': 'update done'}).then((value) {
                              Utils().toastMessage('updated');
                            }).onError((error, stackTrace) {
                              Utils().toastMessage((error.toString()));
                            }); //this is just a exmaple of how you can update the code .
                          },
                          title: Text(
                              snapshot.data!.docs[index]['title'].toString()),
                          subtitle:
                              Text(snapshot.data!.docs[index]['id'].toString()),
                        ),
                      );
                    },
                  ),
                );
              }),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostFirestore()));
        },
        child: const Icon(Icons.add),
      ), //To add an app
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: InputDecoration(
                hintText: "Edit",
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ), //Cancel Button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Update'),
            ), //Update Button
          ],
        );
      },
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:moody/UI/auth/login_screen.dart';
import 'package:moody/UI/posts/add_posts.dart';
import 'package:moody/utils/utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchFilter = TextEditingController();
  final editController = TextEditingController();

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
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: Text('Loading'),
              itemBuilder: (context, snapshot, animation, index) {
                final title = snapshot.child('title').value.toString();

                if (searchFilter.text.isEmpty) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              showMyDialog(
                                  title, snapshot.child('id').value.toString());
                            },
                            leading: Icon(Icons.edit),
                            title: Text("Edit"),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(
                                  context); // This will automatically close the popupmenu that opened up using trailing option dots
                              ref
                                  .child(snapshot.child('id').value.toString())
                                  .remove();
                            },
                            leading: Icon(Icons.delete),
                            title: Text("Delete"),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (searchFilter.text
                    .toLowerCase()
                    .contains(title.toLowerCase().toLowerCase())) {
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 1,
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              showMyDialog(
                                  title, snapshot.child('id').value.toString());
                            },
                            leading: Icon(Icons.edit),
                            title: Text("Edit"),
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: ListTile(
                            onTap: () {
                              ref
                                  .child(snapshot.child('id').value.toString())
                                  .remove();
                            },
                            leading: Icon(Icons.delete),
                            title: Text("Delete"),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPostScreen()));
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
                ref.child(id).update(
                    {'title': editController.text.toLowerCase()}).then((value) {
                  Utils().toastMessage('Post Updated');
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              child: Text('Update'),
            ), //Update Button
          ],
        );
      },
    );
  }
}

// Below is the code for displaying the fetched database using StreamBuilder

// body: Column(
// children: [
// Expanded(
// child: StreamBuilder(
// stream: ref.onValue,
// builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
// if (!snapshot.hasData) {
// return CircularProgressIndicator();
// } else {`
// Map<dynamic, dynamic> map =
// snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list = map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context, index) {
// return ListTile(
// title: Text(list[index]['title']),
// );
// });
// }
// }),
// )
// ],
// ),

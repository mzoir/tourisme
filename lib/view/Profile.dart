import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import "package:tourisme/viewmodels/UserViewModel.dart";

import '../models/Client.dart';

class ProfilePage extends StatefulWidget {
  final String email;

  const ProfilePage({Key? key, required this.email}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController name = TextEditingController();

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  String nameHint = "Loading..."; // Placeholder for hint text

  bool isnotEdit = true;

  bool isEdit = false ;

  @override
  void initState() {
    super.initState();
    // Fetch data when the widget is initialized
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final client = Provider.of<UserViewModel>(context, listen: false);

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 250.0,
                  color: Color(0xffacbbee),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 25.0),
                              child: Text(
                                'PROFILE',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  fontFamily: 'sans-serif-light',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Stack(
                          fit: StackFit.loose,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 140.0,
                                  height: 140.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: ExactAssetImage('images/prof.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Personal Information:',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                             isEdit? ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isEdit = false;

                                  });
                                },
                                child: Icon(Icons.save, color: Colors.red),
                              ):ElevatedButton(
                               onPressed: () {
                                 setState(() {
                                   isEdit = true;

                                 });
                               },
                               child: Icon(Icons.edit, color: Colors.red),
                             )

                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 27.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                       isEdit ?
                       Padding(
                         padding:
                         EdgeInsets.only(left: 25.0, right: 25.0),
                         child: Row(
                           mainAxisSize: MainAxisSize.max,
                           children: <Widget>[
                             Flexible(
                               child: TextField(
                                 controller: name,
                                 decoration: InputDecoration(
                                   hintText:
                                   nameHint, // Use non-constant InputDecoration
                                 ),
                                 enabled: _status,
                                 autofocus: _status,

                                 onSubmitted: (value) async {
  try {
    String uid = client.client.id;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'Name': value }

    ,);
    } catch(e) {
    SnackBar(content: Text("email or password wrong failed: ${e.toString()}"));
    }
                                 }
    ),
                             ),    ],
                         ),
                       )
                           : Padding(
                                padding:
                                    EdgeInsets.only(left: 25.0, right: 25.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: TextField(
                                        controller: name,
                                        decoration: InputDecoration(
                                          hintText:
                                              nameHint, // Use non-constant InputDecoration
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                        onChanged: (value) {
                                          setState(() {
                                            isnotEdit = false;
                                          });
                                        },
                                        onSubmitted: (value) async {
                                          User? user =
                                              FirebaseAuth.instance.currentUser;
                                          if (user != null) {
                                            String uid = user.uid;
                                            Map<String, dynamic> userData = {
                                              "Name": name.text,
                                            };

                                            await FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(uid)
                                                .set(userData)
                                                .then((_) {
                                              client.client.username =
                                                  name.text;
                                              print(
                                                  'DocumentSnapshot added with ID: $uid');
                                            }).catchError((error) {
                                              print(
                                                  'Error adding document: $error');
                                            });
                                          } else {
                                            print('No user is logged in.');
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                        const Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: Card(
                                  child: Text(client.client.email),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3.0),
                        const Divider(
                          height: 10,
                          thickness: 1,
                          endIndent: 10,
                          indent: 10,
                          color: Color(0x319c9292),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 19.0, right: 26.0, top: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text("Historique",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 10,
                          thickness: 1,
                          endIndent: 10,
                          indent: 10,
                          color: Color(0x319c9292),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 19.0, right: 26.0, top: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text("favorites",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 10,
                          thickness: 1,
                          endIndent: 10,
                          indent: 10,
                          color: Color(0x319c9292),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 19.0, right: 26.0, top: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text("Settings",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 10,
                          thickness: 1,
                          endIndent: 10,
                          indent: 10,
                          color: Color(0x319c9292),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 19.0, right: 26.0, top: 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Flexible(
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text("donate us",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      )),
                                ),
                              ),
                              const Divider(
                                height: 10,
                                thickness: 1,
                                endIndent: 10,
                                indent: 10,
                                color: Color(0x319c9292),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

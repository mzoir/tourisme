import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourisme/viewmodels/attraction_viewmodel.dart';
import '../models/attraction.dart';
import 'favatt.dart';
import 'Profile.dart';
import 'package:tourisme/viewmodels/UserViewModel.dart';
import 'attraction_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttractionsPage extends StatefulWidget {
  @override
  _AttractionsPageState createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  @override
  void initState() {
    super.initState();
    // Load attractions when the page is initialized
    Provider.of<AttractionViewModel>(context, listen: false).loadAttractions();
  }
  static int count = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addFavoriteItem(String userId, String itemName, String category, String images, int id) async {
    try {
      // Reference to the user's favorites subcollection
      DocumentReference userDocRef = firestore.collection('users').doc(userId);

      // Query to check if the item already exists in the favorites collection
      QuerySnapshot querySnapshot = await userDocRef.collection('favorites')
          .where('id', isEqualTo: id)
          .get();

      // If the item does not exist, add it to the favorites collection
      if (querySnapshot.docs.isEmpty) {
        await userDocRef.collection('favorites').add({
          'name': itemName,
          'location': category,
          'image': images,
          'id': id,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("Favorite item added successfully!");
      } else {
        print("Item already exists in favorites.");
      }
    } catch (e) {
      print("Error adding favorite item: $e");
    }
  }

  Future<void> addFavoriteIfNotExists(String userId, String name, String location,String images,int id) async {
    final CollectionReference favorites = FirebaseFirestore.instance.collection('favorites');

    try {
      // Query to check if the attraction with the given ID already exists in favorites
      QuerySnapshot querySnapshot = await favorites
          .where('id', isEqualTo: id)
          .where('userId', isEqualTo: userId) // assuming you have userId in the favorites collection
          .get();

      // If the attraction does not exist in the collection, add it
      if (querySnapshot.docs.isEmpty) {
        await favorites.add({
          'name': name,
          'location': location,
          'image': images,
          'id': id,
          'userId': userId,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("Favorite item added successfully!");
      } else {
        print("Item already exists in favorites.");
      }
    } catch (e) {
      print("Error adding favorite item: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,
      appBar: AppBar(
        title: Text('Attractions'),
        titleTextStyle: TextStyle(color: Colors.black,fontFamily: 'raleway',fontSize: 23,fontWeight: FontWeight.bold),
        centerTitle: true,

        actions : [
        IconButton(
        tooltip: "viewaccount",
        icon:
        const Icon(Icons.account_circle, color: Colors.black, size: 32),
        onPressed: () {
          final FirebaseAuth _auth = FirebaseAuth.instance;
          final user = FirebaseAuth.instance.currentUser;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProfilePage(email:  user!.email.toString()),
          ));


        },
      ),
        ],
      ),
      body: Consumer<AttractionViewModel>(
        builder: (context, attractionViewModel, child) {
          final Client = Provider.of<UserViewModel>(context, listen: false);

          if (attractionViewModel.attractions.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: attractionViewModel.attractions.length,
              itemBuilder: (context, index) {
                var attraction = attractionViewModel.attractions[index];
                bool isFavorite =
                    attractionViewModel.favoriteAttractions.contains(index);
                return SizedBox(
                  height: 125,
                  child:
                Card(
                    color: Colors.blueGrey,
child:Center( child: ListTile(
                    leading: Image.network(
                      attraction.image[0],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text(attraction.name,style :TextStyle(color:Colors.white)),
                    subtitle: Text(attraction.location,style :TextStyle(color:Colors.black,fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      onPressed: () async {
                        addFavoriteItem(Client.client.id,attraction.name,attraction.location, attraction.image[0],attraction.id);
                // Reference to the 'attractions' collection
                 showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return isFavorite
                                ? AlertDialog(
                              elevation: 2,
                              content: Text("removed from favourite"),
                              contentTextStyle:
                              const TextStyle(color: Colors.red),
                              actions: [
                                BackButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )
                                : AlertDialog(
                              elevation: 2,
                              content: Text("added to favourite"),
                              contentTextStyle:
                              const TextStyle(color: Colors.green),
                              actions: [
                                BackButton(
                                  color: Colors.black,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        size: 34,
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                      color: isFavorite ? Colors.red : Colors.red,
                    ),

                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AttractionDetails(item:attraction ),
                        ));
                      },

                  ),
                ),),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoriteAttractionsPage()),
          );
        },
        child: Icon(Icons.favorite),
      ),
    );
  }
}

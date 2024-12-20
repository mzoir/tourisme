import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/attraction.dart';
import 'attraction_details.dart';
import 'favatt.dart';
import 'Profile.dart';
import 'package:tourisme/viewmodels/attraction_viewmodel.dart';
import 'package:tourisme/viewmodels/UserViewModel.dart';

class AttractionsPage extends StatefulWidget {
  @override
  _AttractionsPageState createState() => _AttractionsPageState();
}

class _AttractionsPageState extends State<AttractionsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static Map<int, bool> favoriteStates = {};

  @override
  void initState() {
    super.initState();
    // Load attractions when the page is initialized
    Provider.of<AttractionViewModel>(context, listen: false).loadAttractions();
  }

  Future<void> addFavoriteItem(String userId, Attraction attraction) async {
    try {
      final userDocRef = firestore.collection('users').doc(userId);

      // Check if the item already exists in favorites
      final querySnapshot = await userDocRef
          .collection('favorites')
          .where('id', isEqualTo: attraction.id)
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Add the item if not exists
        await userDocRef.collection('favorites').add({
          'name': attraction.name,
          'location': attraction.location,
          'image': attraction.image[0],
          'id': attraction.id,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          favoriteStates[attraction.id] = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item is already in favorites.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Attractions',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Raleway',
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "View Account",
            icon: Icon(Icons.account_circle, color: Colors.black, size: 32),
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(email: user.email!),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<AttractionViewModel>(
        builder: (context, attractionViewModel, child) {
          final client = Provider.of<UserViewModel>(context, listen: false);

          if (attractionViewModel.attractions.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: attractionViewModel.attractions.length,
            itemBuilder: (context, index) {
              final attraction = attractionViewModel.attractions[index];
              final isFavorite = favoriteStates[attraction.id] ?? false;

              return SizedBox(
                height: 125,
                child: Card(
                  color: Colors.blueGrey,
                  child: Center(
                    child: ListTile(
                      leading: Image.network(
                        attraction.image[0],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        attraction.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        attraction.location,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          await addFavoriteItem(
                            client.client.id,
                            attraction,
                          );

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 2,
                                content: Text(
                                  isFavorite
                                      ? "Removed from favorites"
                                      : "Added to favorites",
                                ),
                                contentTextStyle: TextStyle(
                                  color: isFavorite ? Colors.red : Colors.green,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "OK",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                          size: 34,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AttractionDetails(item: attraction),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
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

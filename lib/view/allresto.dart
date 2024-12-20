import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourisme/view/restodetails.dart';
import '../viewmodels/UserViewModel.dart';
import '../viewmodels/ViewRestoModel.dart';
import 'Profile.dart';
import 'favatt.dart';
import 'favrestopage.dart';

class RestoPage extends StatefulWidget {
  const RestoPage({super.key});

  @override
  State<RestoPage> createState() => _RestoPageState();
}

class _RestoPageState extends State<RestoPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<RestaurantViewModel>(context, listen: false).loadRestaurants();
  }
  static Map<int,bool> favoriteStates = {};
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addFavoriteItem(String userId, String itemName, String category, String images, int id) async {
    try {
      DocumentReference userDocRef = firestore.collection('users').doc(userId);

      QuerySnapshot querySnapshot = await userDocRef.collection('favoriterestau')
          .where('id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await userDocRef.collection('favorites').add({
          'name': itemName,
          'location': category,
          'image': images,
          'id': id,
          'timestamp': FieldValue.serverTimestamp(),
        });
        setState(() {
          favoriteStates[id] = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Favorite item added successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item already exists in favorites.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding favorite item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Restaurants'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Raleway',
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            tooltip: "View Account",
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 32),
            onPressed: () {
              final FirebaseAuth _auth = FirebaseAuth.instance;
              final user = _auth.currentUser;
              if (user != null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(email: user.email.toString()),
                ));
              }
            },
          ),
        ],
      ),
      body: Consumer<RestaurantViewModel>(
        builder: (context, restaurantViewModel, child) {
          final client = Provider.of<UserViewModel>(context, listen: false);
          if (restaurantViewModel.restaurants.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: restaurantViewModel.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = restaurantViewModel.restaurants[index];
                bool isFavorite = restaurantViewModel.favoriterestos.contains(index);
                return SizedBox(
                  height: 125,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.orange[100],
                    elevation: 8,
                    margin: EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.orange[200],
                      ),
                      child: Center(
                        child: ListTile(
                          onTap:() {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Restode(item: restaurant),
                            ));
                          } ,
                          leading: Image.network(
                            restaurant.images[0],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            restaurant.name,
                            style: TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              addFavoriteItem(client.client.id, restaurant.name,
                                  restaurant.ville, restaurant.images[0], restaurant.id);

                              restaurantViewModel.toggleFavorite(index);
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

                          subtitle: Text(
                            restaurant.rating.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
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
            MaterialPageRoute(builder: (context) => const FavRestoPage()),
          );
        },
        child: Icon(Icons.favorite),
      ),
    );
  }
}

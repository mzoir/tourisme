import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourisme/viewmodels/hotel_viewmodel.dart';
import '../viewmodels/UserViewModel.dart';
import 'Profile.dart';
import 'home_page.dart';
import 'hotel_details.dart';
import 'favhotel.dart';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HotelsPage extends StatefulWidget {
  @override
  _HotelsPageState createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {
  bool _isSearching = false;
  String _searchText = "";
  static Map<int, bool> favoriteStates = {};
  @override
  void initState() {
    super.initState();
    Provider.of<HotelViewModel>(context, listen: false).loadHotels();
  }
  Future<void> addFavoriteHotel(
      String userId, String hotelName, String city, String imageURL, int hotelId) async {
    try {
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('users').doc(userId);

      QuerySnapshot querySnapshot = await userDocRef
          .collection('favoriteshotel')
          .where('hotelId', isEqualTo: hotelId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        await userDocRef.collection('favoriteshotel').add({
          'hotelName': hotelName,
          'city': city,
          'imageURL': imageURL,
          'hotelId': hotelId,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          favoriteStates[hotelId] = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hotel added to favorites successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hotel already exists in favorites.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding hotel to favorites: $e')),
      );
    }
  }
  Future<void> deleteItemById(int id , String userId) async {
    try {
      // Reference your Firestore collection
      final collectionRef = FirebaseFirestore.instance.collection('users')
          .doc(userId)
          .collection('favoriteshotel');

      // Query the document with the matching `id` field
      final querySnapshot = await collectionRef.where('id', isEqualTo: id).get();

      // Check if any document matches the query
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the document(s)
        for (var doc in querySnapshot.docs) {
          await collectionRef.doc(doc.id).delete();
        }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item deleted successfully!')));
      } else {
        print('No item found with id $id');
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    void _onItemTapped(int index) {
      setState(() {
        _currentIndex = index;
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HoMepa(email: ''),
            ),
          );
        } else if (index == 1) {
          setState(() {
            SystemNavigator.pop();
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.black),
                onChanged: _filtedHotel,
              )
            : Text(
                'Hotel',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontFamily: "Roboto",
                    color: Colors.black),
              ),
        centerTitle: false,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          _isSearching
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isSearching = false;
                      _searchText = "";
                      _filtedHotel(""); // Reset to all foods
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                ),
          IconButton(
            tooltip: "viewaccount",
            icon:
                const Icon(Icons.account_circle, color: Colors.black, size: 32),
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    ProfilePage(email: user!.email.toString()),
              ));
            },
          ),
        ],
        bottomOpacity: 0.5,
      ),
      body: Consumer<HotelViewModel>(
        builder: (context, hotelViewModel, child) {
          final client = Provider.of<UserViewModel>(context, listen: false);
          if (hotelViewModel.filtres.isEmpty) {
            return Center(child: Text('Not Found'));
          } else {
            return ListView.builder(
              itemCount: hotelViewModel.filtres.length,
              itemBuilder: (context, index) {
                var hotel = hotelViewModel.filtres[index];
                bool isFavorite = hotelViewModel.favoriteHotels.contains(index);
                return Container(
                  height: 125,
                  padding: EdgeInsets.symmetric(),
                  child: Card(
                    margin: EdgeInsets.all(6),
                    borderOnForeground: true,
                    color: Colors.grey,
                    child: Center(
                      child: ListTile(
                        leading: Image.network(
                          hotel.images[0],
                          width: 80,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        title: Text(hotel.name),
                        titleTextStyle: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                        subtitle: Text(
                          '${hotel.location} \nrating:${hotel.rating}',
                        ),
                        subtitleTextStyle: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        trailing: IconButton(
                          tooltip: "add to favourite",
                          onPressed: () {
                            addFavoriteHotel(client.client.id, hotel.name,
                                hotel.location, hotel.images[0], hotel.id);
                            hotelViewModel.toggleFavorite(index);
                            print(hotelViewModel.hotels.length);
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
                                        contentTextStyle: const TextStyle(
                                            color: Colors.green),
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
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 34),
                          color: Colors.red,
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => eveHotel(item: hotel),
                          ));
                        },
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
            MaterialPageRoute(builder: (context) => FavPage()),
          );
        },
        child: Icon(Icons.favorite),
      ),
      bottomNavigationBar: Builder(
        // Wrap with Builder widget
        builder: (context) => Stack(
          children: <Widget>[
            SizedBox(
              height: 58,
              child: BottomNavigationBar(
                backgroundColor: Color(0xffc8b7f8),
                elevation: 0.0,
                currentIndex: _currentIndex,
                selectedItemColor: Color(0xf0f6f7fb),
                onTap: _onItemTapped,
                unselectedItemColor: Color(0xf7f8e700),
                unselectedLabelStyle: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
                useLegacyColorScheme: true,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: Color(0xff050202),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.sort,
                      color: Color(0xff050202),
                      size: 20.0,
                    ),
                    label: 'Exit',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _filtedHotel(String query) {
    final viewModel = Provider.of<HotelViewModel>(context, listen: false);

    setState(() {
      _searchText = query;
      if (query.isEmpty) {
        viewModel.filtredHotel = viewModel.hotels;
      } else {
        viewModel.filtredHotel = viewModel.hotels
            .where((hotel) =>
                hotel!.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
}

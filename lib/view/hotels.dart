import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourisme/viewmodels/hotel_viewmodel.dart';
import 'Profile.dart';
import 'home_page.dart';
import 'hotel_details.dart';
import 'fav.dart';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HotelsPage extends StatefulWidget {
  @override
  _HotelsPageState createState() => _HotelsPageState();
}

class _HotelsPageState extends State<HotelsPage> {

  bool _isSearching= false;
  String _searchText="";

  @override
  void initState() {
    super.initState();
    Provider.of<HotelViewModel>(context, listen: false).loadHotels();
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
        }
        else if (index == 1) {
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
                builder: (context) => ProfilePage(email:  user!.email.toString()),
              ));


            },
          ),
        ],
        bottomOpacity: 0.5,
      ),
      body: Consumer<HotelViewModel>(
        builder: (context, hotelViewModel, child) {
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
                padding : EdgeInsets.symmetric(),
                    child:Card(
                  margin: EdgeInsets.all(6),
                  borderOnForeground: true,
                  color: Colors.blue,
                      child: Center(

                  child: ListTile(
                    leading: Image.network(
                      hotel.images[0],
                      width: 80,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    title: Text(hotel.name),
                    titleTextStyle: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color:Colors.white),
                    subtitle: Text('${hotel.location} \nrating:${hotel.rating}',),
                    subtitleTextStyle: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold,color:Colors.black),
                    trailing: IconButton(
                      tooltip: "add to favourite",
                      onPressed: () {
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
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          size: 34),
                      color: Colors.red,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => eveHotel(item: hotel),
                      ));
                    },
                  ),
                ),),);
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
            .where(
                (hotel) => hotel!.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

    });


  }
}

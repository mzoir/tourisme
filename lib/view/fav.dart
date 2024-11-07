import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourisme/viewmodels/hotel_viewmodel.dart';

import 'hotel_details.dart';
class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Hotels'),
        centerTitle: true,
      ),
      body: Consumer<HotelViewModel>(
        builder: (context, hotelViewModel, child) {
          var favoriteHotels = hotelViewModel.getFavoriteHotels();
          if (favoriteHotels.isEmpty) {
            return Center(child: Text('No favorite hotels'));
          } else {
            return ListView.builder(
              itemCount: favoriteHotels.length,
              itemBuilder: (context, index) {
                var hotel = favoriteHotels[index];
                return Card(
                  color: Color(0xfff6f2cd),
                  child: ListTile(
                    leading: Image.network(
                      hotel.images[0],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    title: Text(hotel.name),
                    subtitle: Text('${hotel.location}, ${hotel.location}'),
                    trailing: ElevatedButton(
                      child: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          hotelViewModel.toggleFavorite(hotelViewModel.hotels.indexOf(hotel));

                        });
                      },
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => eveHotel(item: hotel),
                      ));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

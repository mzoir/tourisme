import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ViewRestoModel.dart';

class FavRestoPage extends StatefulWidget {
  const FavRestoPage({super.key});

  @override
  State<FavRestoPage> createState() => _FavRestoPageState();
}

class _FavRestoPageState extends State<FavRestoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Restaurants'),
        centerTitle: true,
      ),
      body: Consumer<RestaurantViewModel>(
        builder: (context, restaurantViewModel, child) {
          var favRestos = restaurantViewModel.getFavoriteResto();

          if (favRestos.isEmpty) {
            return const Center(child: Text('No favorite restaurant yet.'));
          } else {
            return ListView.builder(
              itemCount: favRestos.length,
              itemBuilder: (context, index) {
                var resto = favRestos[index];
                return Card(
                  color: Colors.yellow,
                  child: ListTile(
                    leading: resto.images.isNotEmpty
                        ? Image.network(
                      resto.images[0], // Using network image
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.restaurant, size: 80),
                    title: Text(resto.name),
                    subtitle: Text(resto.ville),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {

                        restaurantViewModel.toggleFavorite(
                          restaurantViewModel.restaurants.indexOf(resto),
                        );
                      },
                    ),
                    onTap: () {
                      // Handle onTap event, maybe navigate to a detail page
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

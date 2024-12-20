import 'package:flutter/material.dart';
import '../models/resto.dart';

class Restode extends StatefulWidget {
  final Restaurant item;
  const Restode({super.key, required this.item});

  @override
  State<Restode> createState() => _RestodeState();
}

class _RestodeState extends State<Restode> {
  @override
  Widget build(BuildContext context) {
    final restaurant = widget.item;

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        backgroundColor: Colors.deepPurple,
      ),
      body:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(child:
    Card( color: Colors.deepPurple[100],

      child: Center(child : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 90),
              // Restaurant Name
              Text(
                restaurant.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Address and City
              Text(
                "${restaurant.address}, ${restaurant.ville}",
                style: TextStyle(fontSize: 16, color: Colors.redAccent,fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Rating
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    restaurant.rating.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Image Carousel
              if (restaurant.images.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: restaurant.images.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            restaurant.images[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),

              // Additional Information
              Text(
                "Discover the flavors of ${restaurant.name} located in ${restaurant.ville}.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: () {
                  // Add your booking functionality here
                },
                icon: const Icon(Icons.book_online),
                label: const Text("Book Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
              ),


            ],
          ),
        ),
      ),
    ),
      ),
      );
  }
}

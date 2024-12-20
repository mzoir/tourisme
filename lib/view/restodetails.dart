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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant Name
              Text(
                restaurant.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Address and City
              Text(
                "${restaurant.address}, ${restaurant.ville}",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
                            restaurant.images[index],
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
            ],
          ),
        ),
      ),
    );
  }
}

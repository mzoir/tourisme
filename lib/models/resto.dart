import 'dart:convert';

import 'package:flutter/services.dart';

class Restaurant {
  final int id;
  final String name;
  final String address;
  final String ville;
  final double rating;
  final List<String> images;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.ville,
    required this.rating,
    required this.images,
  });

  // Factory method to create a Restaurant from JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['nom'],
      address: json['adresse'],
      ville: json['ville'],
      rating: json['rating'].toDouble(),
      images: List<String>.from(json['images']),
    );
  }

  static Future<List<Restaurant>> loadResto() async {
    try {
      String jsonString =
      await rootBundle.loadString('images/resto.json');
      final jsonData = json.decode(jsonString);
      List<dynamic> attractionsData = jsonData['restaurant'];
      List<Restaurant> restaurants =
      attractionsData.map((json) => Restaurant.fromJson(json)).toList();
      return restaurants;
    } catch (e) {
      print('Error loading resto: $e');
      return [];
    }
  }



}

import 'dart:convert';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'package:flutter/services.dart';

class Hotel {
  String name;
  String location;
  String description;
  final List<String> images;
  double rating;
  double price;
  String reservation_link;
  String phone_number;
  String map ;

  Hotel({
    required this.name,
    required this.location,
    required this.description,
    required this.images,
    required this.price,
    required this.reservation_link,
    required this.phone_number,
    required this.rating,
    required this.map
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'],
      location: json['location'],
      description: json['description'],
      images: List<String>.from(json['image']),
      price: json['price'],
        reservation_link : json['reservation_link'],
        phone_number :  json['phone_number'],
      map : json['map'],
        rating: json['rating']
    );
  }

  static Future<List<Hotel>> loadHotels() async {
    try {
      String jsonString =
          await rootBundle.loadString('images/attraction1.json');
      final jsonData = json.decode(jsonString);
      List<dynamic> hotelsData = jsonData['hotels'];
      List<Hotel> hotels =
          hotelsData.map((json) => Hotel.fromJson(json)).toList();
      return hotels;
    } catch (e) {
      print('Error loading Hotels: $e');
      return [];
    }
  }
}

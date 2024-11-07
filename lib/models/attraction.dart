import 'dart:convert';
import 'package:flutter/services.dart';

class Attraction {
  String name;
  String location;
  String description;
  int id; // Change id to int
  final List<String> image;

  Attraction({
    required this.name,
    required this.location,
    required this.description,
    required this.image,
    required this.id,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) {
    return Attraction(
      name: json['name'],
      location: json['location'],
      description: json['description'],
      image: List<String>.from(json['image']),
      id: json['id'], // This will be parsed as int
    );
  }

  static Future<List<Attraction>> loadAttractions() async {
    try {
      String jsonString =
      await rootBundle.loadString('images/attractions.json');
      final jsonData = json.decode(jsonString);
      List<dynamic> attractionsData = jsonData['attractions'];
      List<Attraction> attractions =
      attractionsData.map((json) => Attraction.fromJson(json)).toList();
      return attractions;
    } catch (e) {
      print('Error loading attractions: $e');
      return [];
    }
  }
}

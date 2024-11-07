import 'dart:convert';
import 'package:flutter/services.dart';  // For loading asset files
import '../models/resto.dart';

import 'package:flutter/material.dart';

class RestaurantViewModel extends ChangeNotifier {
  List<Restaurant> _restaurants = [];

  List<Restaurant> get restaurants => _restaurants;
Set<int> _favoriterestos = {} ;

  Set<int> get favoriterestos => _favoriterestos; // Load data from JSON file
  Future<void> loadRestaurants() async {
    _restaurants = await Restaurant.loadResto();
    notifyListeners();
  }

  void addRestaurant(Restaurant restaurant) {
    _restaurants.add(restaurant);
    notifyListeners();
  }

  void removeRestaurant(String id) {
    _restaurants.removeWhere((restaurant) => restaurant.id == id);
    notifyListeners();
  }

  void updateRestaurant(Restaurant updatedRestaurant) {
    final index = _restaurants.indexWhere((restaurant) => restaurant.id == updatedRestaurant.id);
    if (index != -1) {
      _restaurants[index] = updatedRestaurant;
      notifyListeners();
    }
  }
  void toggleFavorite(int index) {
    if (_favoriterestos.contains(index)) {
      _favoriterestos.remove(index);
    } else {
      _favoriterestos.add(index);
    }
    notifyListeners();
  }

  List<Restaurant> getFavoriteResto() {
    return _favoriterestos.map((index) => _restaurants[index]).toList();
  }
}

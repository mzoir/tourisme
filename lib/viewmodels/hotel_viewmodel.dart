import 'package:flutter/material.dart';
import 'package:tourisme/models/hotel.dart';

class HotelViewModel with ChangeNotifier {
  List<Hotel> _hotels = [];
  List<Hotel> _filtredHotel =[];

  List<Hotel> get filtres => _filtredHotel;
  Set<int> _favoriteHotels = {};

  List<Hotel> get hotels => _hotels;
  Set<int> get favoriteHotels => _favoriteHotels;

  set filtredHotel(List<Hotel> value) {
    _filtredHotel = value;
  }

  Future<void> loadHotels() async {
    _hotels = await Hotel.loadHotels();
    _filtredHotel = _hotels;
    notifyListeners();
  }

  void toggleFavorite(int index) {
    if (_favoriteHotels.contains(index)) {
      _favoriteHotels.remove(index);
    } else {
      _favoriteHotels.add(index);
    }
    notifyListeners();
  }

  List<Hotel> getFavoriteHotels() {
    return _favoriteHotels.map((index) => _hotels[index]).toList();
  }
}

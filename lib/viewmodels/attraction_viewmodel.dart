import 'package:flutter/material.dart';
import 'package:tourisme/models/attraction.dart';


class AttractionViewModel with ChangeNotifier {
  List<Attraction> _attractions = [];
  Set<int> _favoriteAttractions = {};

  List<Attraction> get attractions => _attractions;
  Set<int> get favoriteAttractions => _favoriteAttractions;

  Future<void> loadAttractions() async {
    _attractions = await Attraction.loadAttractions();
    notifyListeners();
  }

  void toggleFavorite(int index) {
    if (_favoriteAttractions.contains(index)) {
      _favoriteAttractions.remove(index);
    } else {
      _favoriteAttractions.add(index);
    }
    notifyListeners();
  }

  List<Attraction> getFavoriteAttrs() {
    return _favoriteAttractions.map((index) => _attractions[index]).toList();
  }
}

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../models/pfile.dart';

class VideoViewModel extends ChangeNotifier {
  List<Video> _videos = [];

  List<Video> get videos => _videos;

  Future<List<Video>> loadVideosFromJson() async {
    final String response = await rootBundle.loadString('images/videos.json');
    final List<dynamic> data = json.decode(response);
    _videos = data.map((video) => Video.fromJson(video)).toList();
    return _videos;
  }
  @override
   notifyListeners();
}

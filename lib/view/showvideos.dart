import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../models/pfile.dart';
import '../viewmodels/ViewModel.dart';


class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  late Future<List<String>> _videoUrls;
  late List<Video> Videoinfo;
  @override
  void initState() {
    super.initState();
    Provider.of<VideoViewModel>(context, listen: false).loadVideosFromJson();
    Videoinfo = Provider.of<VideoViewModel>(context, listen: false).videos;
    _videoUrls = fetchVideoUrls();

  }

  Future<List<String>> fetchVideoUrls() async {
    try {
      List<String> urls = [];
      String folderPath = 'videos/'; // Replace with your Firebase Storage path
      Reference storageRef = FirebaseStorage.instance.ref().child(folderPath);

      ListResult result = await storageRef.listAll();
      var index =0;
      for (var item in result.items) {
        String url = await item.getDownloadURL();
        urls.add(url);
        index++;
        addVideoToFirestore(url,index);
      }

      return urls;
    } catch (e) {
      print('Failed to fetch video URLs: $e');
      return [];
    }
  }

  void addVideoToFirestore(String videoUrl,int index) async {
    // Reference to Firestore collection
    CollectionReference videos = FirebaseFirestore.instance.collection('videos');

    // Create a document with the video URL and other metadata
    await videos.add({
      'url': videoUrl,
      'title': Videoinfo[index].name, // Add any other metadata you want
      'description': 'A description of the video',
      'uploadDate': FieldValue.serverTimestamp(), // Automatically set the current timestamp
    }).then((value) => print("Video Added"))
        .catchError((error) => print("Failed to add video: $error"));
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text('For u:'),actions: [
        ElevatedButton(
          onPressed: () {

          },
          child: Icon(
             Icons.search,
            color:Colors.red

          ),
        ),


      ],),

      body: FutureBuilder<List<String>>(
        future: _videoUrls,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var videoUrls = snapshot.data!;

          return ListView.builder(
            itemCount: videoUrls.length,
            itemBuilder: (context, index) {
              String url = videoUrls[index];
              return Column(
                children: [
                  Text(Videoinfo[index].name),
                  VideoPlayerWidget(url: url),
                  SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;

  VideoPlayerWidget({required this.url});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red,
      child :
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : Center(child: CircularProgressIndicator()),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.all(1.0),

        child : ElevatedButton(



          onPressed: _togglePlayPause,
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,

          ),
        ),
        ),
      ],
      ),
    );
  }
}

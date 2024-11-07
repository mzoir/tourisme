import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourisme/models/Client.dart';
import 'package:tourisme/viewmodels/attraction_viewmodel.dart';
import 'package:tourisme/viewmodels/UserViewModel.dart';

class FavoriteAttractionsPage extends StatefulWidget {
  @override
  State<FavoriteAttractionsPage> createState() => _FavoriteAttractionsPageState();
}

class _FavoriteAttractionsPageState extends State<FavoriteAttractionsPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getFavorites(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      print("Snapshot received: ${snapshot.docs.length}");
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    final client = Provider.of<UserViewModel>(context, listen: false).client;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Attractions'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getFavorites(client.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No favorites added yet."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final favorite = snapshot.data![index];
              return Card(
                color: Colors.yellow,
                child: ListTile(
                  title: Text(favorite['name'].toString()),
                  subtitle: Text(favorite['location'].toString()),
                  leading: Image.network(
                    favorite['image'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  trailing: ElevatedButton(
                    child: Icon(Icons.close),
                    onPressed: () {
                      // Add functionality to remove item from favorites
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

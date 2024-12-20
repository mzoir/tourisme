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
  Future<void> deleteItemById(int id , String userId) async {
    try {
      // Reference your Firestore collection
      final collectionRef = FirebaseFirestore.instance.collection('users')
        .doc(userId)
        .collection('favorites');

      // Query the document with the matching `id` field
      final querySnapshot = await collectionRef.where('id', isEqualTo: id).get();

      // Check if any document matches the query
      if (querySnapshot.docs.isNotEmpty) {
        // Delete the document(s)
        for (var doc in querySnapshot.docs) {
          await collectionRef.doc(doc.id).delete();
        }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Item deleted successfully!')));
      } else {
        print('No item found with id $id');
      }
    } catch (e) {
      print('Error deleting item: $e');
    }
  }

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
                  title: Text(favorite['name'].toString() ?? 'Unnamed Attraction'),
                  subtitle: Text(favorite['location'].toString() ?? ""),
                  leading: favorite['image'] != null
                      ? Image.network(
                    favorite['image']!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  )
                      : const Icon(Icons.image, size: 80),
                  trailing: ElevatedButton(
                    child: const Icon(Icons.close),
                    onPressed: () {
                      deleteItemById(favorite['id'],client.id);

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

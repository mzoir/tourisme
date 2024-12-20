import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'hotel_details.dart';
import '../viewmodels/UserViewModel.dart';

class FavPage extends StatefulWidget {
  const FavPage({super.key});

  @override
  State<FavPage> createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getFavorites(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('favoriteshotel')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
  Future<void> deleteItemById(int id , String userId) async {
    try {
      // Reference your Firestore collection
      final collectionRef = FirebaseFirestore.instance.collection('users')
          .doc(userId)
          .collection('favoriteshotel');

      // Query the document with the matching `id` field
      final querySnapshot = await collectionRef.where('hotelId', isEqualTo: id).get();

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

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final client = Provider.of<UserViewModel>(context, listen: false).client;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Hotels'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getFavorites(client.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No favorites added yet.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }

          final favoriteHotels = snapshot.data!;

          return ListView.builder(
            itemCount: favoriteHotels.length,
            itemBuilder: (context, index) {
              final hotel = favoriteHotels[index];

              return Card(
                color: const Color(0xfff6f2cd),
                child: ListTile(
                  leading: Image.network(
                    hotel['imageURL'],
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(hotel['hotelName']),
                  subtitle: Text(hotel['city']),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      deleteItemById(hotel['hotelId'],client.id);
                    },
                  ),
                  onTap: () {

                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
